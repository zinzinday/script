function OnLoad()
  BlockChat()
end

local dontPrintHeaders = {[0x15] = {}, [0x29] = {}, [0x54] = {}, [0x55] = {}, [0x110] = {}, [0x114] = {}, [0x6D] = {}, [0x8F] = {}}
function OnSendPacket(p)
  local head = p.header
  if not dontPrintHeaders[head] then print("Header: "..('0x%02X'):format(head)) end
  if head == 0x87 then -- old: 0x00E9
    p.pos=23
    local printer = ""
    --for i=20,30 do
      local opc = p:Decode1()
      if opc == nil then
        p:Block()
        p.skip(p, 1)
      else
        printer = printer..('0x%02X'):format(opc).." "
      end
    --end
    print(printer)
  end
end
-- EC
-- 6C
-- 74
-- 98
