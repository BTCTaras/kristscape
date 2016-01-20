local args = ... or {}
local ksml = args[1] or "Lemmmy is shit[KSML]Jay[SHIT]OK?"
local kasm = args[2] or {}
local w = args[3]

local lines = 0
local x, y = args[3] or 1, args[4] or 1

local fg,bg = "f","0"

local function makemea(thing,from)
	if thing == "color" then
		if from == "WHITE" then return "0" end
		if from == "ORANGE" then return "1" end
		if from == "MAGENTA" then return "2" end
		if from == "LIGHTBLUE" then return "3" end
		if from == "LTBLUE" then return "3" end
		if from == "YELLOW" then return "4" end
		if from == "LIME" then return "5" end
		if from == "LIGHTGREEN" then return "5" end
		if from == "LTGREEN" then return "5" end
		if from == "PINK" then return "6" end
		if from == "GRAY" then return "7" end
		if from == "GREY" then return "7" end
		if from == "GRXY" then return "7" end
		if from == "DARKGRAY" then return "7" end
		if from == "DARKGREY" then return "7" end
		if from == "DARKGRXY" then return "7" end
		if from == "DKGRAY" then return "7" end
		if from == "DKGREY" then return "7" end
		if from == "DKGRXY" then return "7" end
		if from == "LIGHTGRAY" then return "8" end
		if from == "LIGHTGREY" then return "8" end
		if from == "LIGHTGRXY" then return "8" end
		if from == "LTGRAY" then return "8" end
		if from == "LTGREY" then return "8" end
		if from == "LTGRXY" then return "8" end
		if from == "CYAN" then return "9" end
		if from == "LINK" then return "9" end
		if from == "PURPLE" then return "a" end
		if from == "BLUE" then return "b" end
		if from == "BROWN" then return "c" end
		if from == "GREEN" then return "d" end
		if from == "RED" then return "e" end
		if from == "BLACK" then return "f" end
		if from == "LEMMMYSSOUL" then return "f" end
	end
end

local function insert(ch)
	local a,b,c = kasm[y]:sub(1,#kasm[y]/3),kasm[y]:sub(#kasm[y]/3+1,2/3*#kasm[y]),kasm[y]:sub(2/3*#kasm[y]+1)
	if x == 1 + #kasm[y]/3 then
		x = x + 1
		kasm[y] = a..ch..b..fg:sub(#fg)..c..bg:sub(#bg)
	end
end

local function go2(xx,yy)
	for i=1,yy do
		if kasm[i] == nil then kasm[i] = "" end
	end
	y = yy
	if xx > 1 then
		x = #kasm[y]/3
		while #kasm[y]/3 < xx do
			insert("\009")
			os.sleep()
		end
	else
		x = 1
	end
end

local function parse(tag,arg,closing)
	if tag == "A" then
	
	elseif tag == "BR" then
		y = y + 1
		x = 1
		if kasm[y] == nil then kasm[y] = "" end
	elseif tag == "C" then
		if not closing then
			arg = arg:upper()
			fg = fg .. makemea("color",arg)
		else
			fg = fg:sub(1,#fg-1)
			if fg == "" then fg = "f" end
		end
	elseif tag == "SHIT" then
		go2(1,2)
	end
end

ksml = ksml:sub(ksml:find("%[KSML%]")+6)
kasm[1] = ""

while #ksml > 0 do
	next = ksml:find("%[")
	if next == 1 and ksml:sub(2,2) ~= "[" and ksml:sub(2,2) ~= "]" and ksml:find("%]") then
		local tag = ksml:sub(2,ksml:find("%]")-1)
		local closing, arg = false
		if tag:find("%:") then
			arg = tag:sub(tag:find("%:")+1)
			tag = tag:sub(1,tag:find("%:")-1)
		end
		if tag:sub(1,1) == "/" then
			closing = true
			tag = tag:sub(2)
		end
		ksml = ksml:sub(ksml:find("%]")+1)
		parse(tag,arg,closing)
	else
		insert(ksml:sub(1,1))
		ksml = ksml:sub(2)
	end
	print(ksml)
	print(kasm[1])
	print(kasm[2])
	os.sleep(1)
end
