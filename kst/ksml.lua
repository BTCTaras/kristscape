--Signed hash of the rest of the file goes here
local args = ... or {}
local debug = true
local ksml = args[1] or "<!DOCTYPE HTML><html><body><!--[KSML][TITLE]Test site[/TITLE]Welcome to my KristScape hell[LEFT:4]site![BR]It is [HL:YELLOW]good[/HL][BR][CHAR:HEART][/KSML]--><p>Welcome to my site!</p></body></html>"
local kasm = args[2] or {}
local w = args[3] or 50 --screen width
local cs = 50 --container width
local cs = 1 --container start
local title = args[4] or ""

local lines = 0
local x, y = args[3] or 1, args[4] or 1

local fg, bg = "f", "0"

local lookup = {}

lookup["colors"] = {
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
	["LIGHTRED"] = "6",
	["LTRED"] = "6",
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
	["DARKLIME"] = "d",
	["DKLIME"] = "d",
	["RED"] = "e",
	["BLACK"] = "f",
	["LEMMMYSSOUL"] = "f",
	["THEMEFG"] = "x",
	["THEMEBG"] = "y"
}

lookup["colorcodes"] = {}

lookup["characters"] = {
	["SMILEY OUTLINE"] = "\001",
	["SMILEY"] = "\002",
	["HEART"] = "\003",
	["DIAMOND"] = "\004",
	["CLUB"] = "\005",
	["SPADE"] = "\006",
	["BULLET"] = "\007",
	["LINEBREAK"] = "[BR]",
	["MALE"] = "\011",
	["FEMALE"] = "\012",
	["NOTE"] = "\014",
	["NOTES"] = "\015",
	["RIGHT POINTER"] = "\016",
	["LEFT POINTER"] = "\017",
	["UP DOWN ARROW"] = "\018",
	["PARAGRAPH"] = "\020",
	["PILCROW"] = "\020",
	["SECTION"] = "\021",
	["RECTANGLE"] = "\022",

	--Unicode
	["WHITE SMILING FACE"] = "\001",
	["BLACK SMILING FACE"] = "\002",
	["BLACK HEART SUIT"] = "\003",
	["BLACK DIAMOND SUIT"] = "\004",
	["BLACK CLUB SUIT"] = "\005",
	["BLACK SPADE SUIT"] = "\006",
	["INVERSE BULLET"] = "\008",
	["MALE SIGN"] = "\011",
	["FEMALE SIGN"] = "\012",
	["EIGTH NOTE"] = "\014",
	["BEAMED SIXTEENTH NOTES"] = "\015",
	["BLACK RIGHT-POINTING POINTER"] = "\016",
	["BLACK LEFT-POINTING POINTER"] = "\017",
	["DOUBLE EXCLAMATION POINT"] = "\019",
	["PILCROW SIGN"] = "\020",
	["SECTION SIGN"] = "\021",
	["BLACK RECTANGLE"] = "\022",
	["UP DOWN ARROW WITH BASE"] = "\023",
	["UP ARROW"] = "\024",
	["DOWN ARROW"] = "\025",
}

for i = 1, 255 do -- What' ya gonna do bout unicode?
	local s = tostring (i)
	-- Pad s from the left to 3 chars (load is supplied by bios.lua and loadstring is removed in lua 5.2)
	local v = load ("return '\\" .. string.rep ("0", 3 - #s) .. s .. "'")()
	lookup.characters [s] = v
end

for k, v in pairs (lookup.colors) do -- So we can use [C:f]
	lookup.colorcodes [tostring (v)] = tostring (k)
end


local function makemea(thing,from)
	if thing == "color" then
		local colorKey = lookup.colors[from]
		if colorKey ~= nil then return colorKey end

		colorKey = lookup.colorcodes[from:lower ()]
		if colorKey ~= nil then return colorKey end

		return "f" -- Default color
	end
end

local function insert(ch)
	local a, b, c = kasm[y]:sub(1, #kasm[y]/3), kasm[y]:sub(#kasm[y]/3+1, 2/3*#kasm[y]), kasm[y]:sub(2/3*#kasm[y]+1)
	if x == 1 + #kasm[y]/3 then
		x = x + 1
		kasm[y] = a .. ch .. b .. fg:sub(#fg) .. c .. bg:sub(#bg)
	else
		local a1, a2, b1, b2, c1, c2 = a:sub(1, x-1), a:sub(x+1), b:sub(1, x-1), b:sub(x+1), c:sub(1, x-1), c:sub(x+1)
		x = x + 1
		kasm[y] = a1 .. ch .. a2 .. b1 .. fg:sub(#fg) .. b2 .. c1 .. bg:sub(#bg) .. c2
	end
	if x > w then go2(cs,y+1) end
end

function go2(xx,yy)
	for i=1,yy do
		if kasm[i] == nil then kasm[i] = "" end
	end
	y = yy
	if xx > #kasm[y]/3 then
		x = #kasm[y]/3 + 1
		while #kasm[y]/3 < xx-1 do
			insert("\009")
			os.sleep()
		end
	elseif x > 1 then
		x = xx
	else
		x = 1
	end
	if x < 1 then x = 1 end
end

local function parse(tag, arg, closing)
	if tag == "A" then
	elseif tag == "BR" then
		go2(cs, y+1)
	elseif tag == "C" then
		if not closing then
			arg = arg:upper()
			fg = fg .. makemea("color",arg)
		else
			fg = fg:sub(1,#fg-1)
			if fg == "" then fg = "f" end
		end
	elseif tag == "CLEARTITLE" then
		title = ""
	elseif tag == "HL" then
		if not closing then
			arg = arg:upper()
			bg = bg .. makemea("color",arg)
		else
			bg = bg:sub(1,#bg-1)
			if bg == "" then bg = "0" end
		end
	elseif tag == "CHAR" then
		ksml = lookup.characters[arg:upper()] .. ksml
	elseif tag == "CR" then
		x = 1
	elseif tag == "DOWN" then
		go2(x,y-tonumber(arg or 1))
	elseif tag == "END" then
		ksml = ""
	elseif tag == "ID" then
		ksml = os.getComputerID()..ksml
	elseif tag == "KSML" and closing then
		ksml = ""
	elseif tag == "LEFT" then
		go2(x-tonumber(arg or 1),y)
	elseif tag == "LF" then
		go2(x,y+1)
	elseif tag == "REP" and arg and not closing then
		arg = tonumber(arg or 1)
		local krep = ksml
		if ksml:upper():find("%[%/REP%]") then
			krep = ksml:sub(1,ksml:upper():find("%[%/REP%]")-1)
		end
		for i=1,arg-1 do
			ksml = krep..ksml
		end
	elseif tag == "RIGHT" or tag == "SKIP" then
		go2(x+tonumber(arg or 1),y)
	elseif tag == "TOP" then
		go2(x,1)
	elseif tag == "TITLE" and not closing then
		local nt = ksml
		if ksml:upper():find("%[%/TITLE%]") then
			nt = ksml:sub(1,ksml:upper():find("%[%/TITLE%]")-1)
			ksml = ksml:sub(ksml:upper():find("%[%/TITLE%]"),#ksml)
		else
			ksml = ""
		end
		title = title .. nt
	elseif tag == "UP" then
		go2(x,y+tonumber(arg or 1))
	elseif tag == "X" then
		go2(tonumber(arg),y)
	end
end

ksml = ksml:sub(ksml:find("%[KSML%]")+6)
kasm[1] = ""

while #ksml > 0 do
	next = ksml:find("%[")

	if next == 1 and ksml:sub(2,2) ~= "[" and ksml:sub(2,2) ~= "]" and ksml:find("%]") then
		local tag = ksml:sub(2, ksml:find("%]")-1)
		local closing, arg = false, nil
		if tag:find("%:") then
			arg = tag:sub(tag:find("%:")+1)
			tag = tag:sub(1, tag:find("%:")-1)
		end
		if tag:sub(1,1) == "/" then
			closing = true
			tag = tag:sub(2)
		end
		ksml = ksml:sub(ksml:find("%]")+1)
		parse(tag, arg, closing)
	else
		insert(ksml:sub(1,1))
		ksml = ksml:sub(2)
	end

	if debug then
		term.setTextColor(colors.lightGray)
		term.write(ksml)
		print()
		term.setTextColor(colors.white)
		for i=1,#kasm do print(kasm[i]) end
		os.sleep(1)
	end
end

if not debug and not args[1] then
	for i=1,#kasm do print(kasm[i]) end
end

go2 = nil
