local sandboxEnviroment = {} --If you want you can shorten the name later, also add whitelist of stuff that should be available

function addToSandboxEnv(name) --Someone PLEASE find a better name
    local entry = _G[name]
    local wmt = setmetatable({}, {__index=entry, __metatable = "protected"})
    sandboxEnviroment[name] = wmt
end

local function allow(api)
  _,y = term.getSize()
  term.setCursorPos(1,y-1)
  term.setBackgroundColor(colors.red)
  term.setTextColor(colors.black)
  term.clearLine()
  term.write("Allow access to "..api.." api? [Y/N]")
  _,key = os.pullEvent("char")
  if key:lower() == "y" then
  	addToSandboxEnv(api)
  	return true
  else
  	return false
  end
end

_G.api = {nksml="", append=function(ksml)
  api.nksml = api.nksml..tostring(ksml)
end,
request = function(api)
  return allow(api)
end}
addToSandboxEnv("api")

function run(script)
  local f, err = loadstring(script)
  if err ~= nil then
  	return "[BR][C:RED]"..err
  end
  setfenv(f,sandboxEnviroment)
  local ok, err = pcall(f)
  if ok then
 	return sandboxEnviroment.api.nksml
  else
   	return "[BR][C:RED]"..err
  end
end

return run
