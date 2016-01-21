local args = ... or {}
local ksml = args[1] or "Lemmmy is shit[KSML]Jay[SHIT]OK?"
local kasm = args[2] or {}
local w = args[3]

local lines = 0
local x, y = args[3] or 1, args[4] or 1

local fg,bg = "f","0"

local colorsLookupTable = {
	["WHITE"] = "0",
	["ORANGE"] = "1",
	["MAGENTA"] = "2",
	["LIGHTBLUE"] = "3",
	["LTBLUE"] = "3",
	["YELLOW"] = "4",
	["LIME"] = "5",
	["LIGHTGREEN"] = "5",
	["LTGREEN"] = "5",
	["PINK"] = "6",
	["GRAY"] = "7",
	["GREY"] = "7",
	["GRXY"] = "7",
	["DARKGRAY"] = "7",
	["DARKGREY"] = "7",
	["DARKGRXY"] = "7",
	["DKGRAY"] = "7",
	["DKGREY"] = "7",
	["DKGRXY"] = "7",
	["LIGHTGRAY"] = "8",
	["LIGHTGREY"] = "8",
	["LIGHTGRXY"] = "8",
	["LTGRAY"] = "8",
	["LTGREY"] = "8",
	["LTGRXY"] = "8",
	["CYAN"] = "9",
	["LINK"] = "9",
	["PURPLE"] = "a",
	["BLUE"] = "b",
	["BROWN"] = "c",
	["GREEN"] = "d",
	["RED"] = "e",
	["BLACK"] = "f",
	["LEMMMYSSOUL"] = "f",
}

local function makemea (thing, from)
	if thing == "color" then
		local colorKey = colorsLookupTable[from]
		if colorKey ~= nil then
			return colorKey
		end
		return "f" -- Default color
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
	elseif tag == "BLAMETARAS" then
		print("Blame Taras!")
		os.sleep (2)
		os.shutdown ()
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
