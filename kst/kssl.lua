local args = ... or {}
local scriptname = args[1] or "kristscapescript"
local script = args[2] or
[[
print ("hi, tell me a secret")
local pass = read ("*")
assert (pass ~= "LEMMMYSSOUL", "satan")
if pass == "3d6" then
  print ("Your Welcome.")
else
  error ("Get out!")
end
return pass .. "-000"
]]

local env = {}

env = {
  error = function (msg)
    return error (msg or "",2)
  end,
  print = function (...)
    print (...) -- maybe unsafe
  end,
  read = function (replaceChar, history, fncomplete)
    return read (replaceChar, history, fncomplete)
  end,
  assert = function (v, msg, ...)
    if not v then
      env.error (msg or "assertion failed!")
    else
      return ...
    end
  end,
  _G = env,
  tonumber = function (e, base) return tonumber (e, base or 10) end,
  tostring = function (e) return tostring (e) end,
  type = function (v) return type (v) end
}

local f, r = load (script, "=(" .. scriptname .. ")", "t", env)
assert (f, r)
f ()
