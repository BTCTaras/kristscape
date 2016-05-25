local args = {...}
local script = args[1]
local ksml = ""

local const = {}
const.width = args[2]
const.height = args[3]
const.contw = args[4]
const.conts = args[5]
const.recordx = args[6]
const.recordy = args[7]
const.x = args[8]
const.y = args[9]
const.url = args[10]
const.http = args[11]
const.name = args[12]
const.certified = args[13]
const.id = os.getComputerID()
const.cc = os.version()
const.ks = args[14]
const.host = _HOST
const.from = args[15]
--const.true = true
--const.false = false
const.pocket = pocket
const.command = command
const.lastlink = args[16]
const.nsfw = args[17]

local var = args[18]

local function material(word)
	local identifier = word:sub(1,1)
	
	if identifier == "\"" or identifier == "'" then
		--String
		if word:sub(#word) == identifier then
			return word:sub(2,#word-1)
		end
	end
	
	if identifier == "#" then
		--Constant
		return tostring(const[word:sub(2):lower()])
	end
	
	if identifier == "$" then
		--Variable
		if true then
			return tostring(var[word:sub(2):lower()])
		else
			return ""
		end
	end
	
	return ""
end

local I, mode = 0, 0
while I < #script do
	if script:sub(I,I) == "'" then
		mode = math.abs(mode-.1)
		if mode == 0.9 then mode = 1 end
	end
	if script:sub(I,I) == '"' then
		mode = mode == math.floor(mode) and math.abs(mode-1) or mode
	end
	if mode ~= 0 then
		if script:sub(I,I) == " " then
			script = script:sub(1,I-1) .. "[SP]" .. script:sub(I+1,#script)
			I = I + 4
		else
			I = I + 1
		end
	else
		I = I + 1
	end
end

while script:find("%;") do
	local statement = script:sub(1,script:find("%;")-1)
	script = script:sub(script:find("%;")+1)
	while statement:sub(1,1) == " " do statement = statement:sub(2) end
	
	local command = statement:sub(1,statement:find(" ")-1 or #statement):lower()
	local words = {}
	if statement:find(" ") then
		statement = statement:sub(statement:find(" ")+1)
		local s = statement .. " "
		local n = 0
		while s:find(" ") do
			n = n + 1
			words[n] = s:sub(1,s:find(" ")-1)
			s = s:sub(s:find(" ")+1)
		end
	end
	
	if command == "echo" then
		for i=1,#words do
			ksml = ksml .. material(words[i])
		end
	end
	
	if command == "set" then
		local vword = words[1]:lower()
		local vval = ""
		if #words > 1 then
			for i=2,#words do
				vval = vval .. material(words[i])
			end
		end
		if vword:sub(1,1) == "$" then
			var[vword:sub(2)] = vval
		end
	end
end

return ksml:gsub(" ","[SP]"), var