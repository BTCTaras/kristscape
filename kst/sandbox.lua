local sandboxEnviroment = {} --If you want you can shorten the name later, also add whitelist of stuff that should be available
local w,h = term.getSize()
local ww,wh = w, h-4
local win = window.create(term.current(), 1, 4,ww,wh, true)
win.setBackgroundColor(colors.white)
win.setTextColor(colors.black)
function addToSandboxEnv(name) --Someone PLEASE find a better name
    local entry = _G[name]
    local wmt = setmetatable({}, {__index=entry, __metatable = "protected"})
    sandboxEnviroment[name] = wmt
end

sandboxEnviroment["term"] = setmetatable({}, {__index=win, __metatable="protected"})

local function run(script)
  local executable = loadstring(script)
  setfenv(executable,sandboxEnviroment)
  executable()
end

return run
