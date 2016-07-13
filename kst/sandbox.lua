local sandboxEnviroment = {} --If you want you can shorten the name later, also add whitelist of stuff that should be available

function addToSandboxEnv(name) --Someone PLEASE find a better name
    local entry = _G[name]
    local wmt = setmetatable({}, {__index=entry, __metatable = "protected"})
    sandboxEnviroment[name] = wmt
end

_G.nksml = ""
addToSandboxEnv(nksml)

local function append(ksml)
  nksml = nksml..ksml
end

function run(script)
  local f = loadstring(script)
  setfenv(f,sandboxEnviroment)
  f()
  return sandboxEnviroment[nksml]
end

return run
