--[[

   _____             _____          __  .__                            
  /     \_______    /  _  \________/  |_|__| ____  __ __  ____   ____  
 /  \ /  \_  __ \  /  /_\  \_  __ \   __\  |/ ___\|  |  \/    \ /  _ \ 
/    Y    \  | \/ /    |    \  | \/|  | |  \  \___|  |  /   |  (  <_> )
\____|__  /__|    \____|__  /__|   |__| |__|\___  >____/|___|  /\____/ 
        \/                \/                    \/           \/        

]]


local hashKey = {124,532,123,22,20};

local function convert(chars,dist,inv)
  local charInt = string.byte(chars);
  for i=1,dist do
    if(inv)then charInt = charInt - 1; else charInt = charInt + 1; end
    if(charInt<32)then
      if(inv)then charInt = 126; else charInt = 126; end
    elseif(charInt>126)then
      if(inv)then charInt = 32; else charInt = 32; end
    end
  end
  return string.char(charInt);
end

local function crypt(str,k,inv)
  local enc= "";
  for i=1,#str do
    if(#str-k[5] >= i or not inv)then
      for inc=0,3 do
        if(i%4 == inc)then
          enc = enc .. convert(string.sub(str,i,i),k[inc+1],inv);
          break;
        end
      end
    end
  end
  if(not inv)then
    for i=1,k[5] do
      enc = enc .. string.char(math.random(32,126));
    end
  end
  return enc;
end

function encodeScript(str,key)
  return crypt(str,key)
end

function decodeScript(str,key)
  return crypt(str,key,true)
end

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function openFile(fileName)
  local str = ""
  local lines = lines_from(fileName)
  for k,v in pairs(lines) do
    str = (str..v)
  end
  lines_from(fileName)
  return str
end

function makeFile(fileName, str)

  file = io.open(fileName, "w")
  file:write(encodeScript(str,hashKey))
  file:close()
  
end

function tcpParser(url)

  local http = require("socket.http")
  local page = http.request(url)
  
  return page
  
end


--UPDATEURL=
--HASH=52B9566B3967A4F2425F4C10CBBD15C1
