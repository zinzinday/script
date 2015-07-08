

function readScript(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
return content
end

load(readScript(LIB_PATH.."DivinePred.luac"), "Divine Prediction","bt",_ENV)()


