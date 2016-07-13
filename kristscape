local version = "0.5.2"
local code_is_a_mess = "not necessarily"

local _KSML_ = loadfile("kst/ksml.lua")
local _SAND_ = loadfile("kst/sandbox.lua")
local _INQU_ = loadfile("kst/inquire.lua")

local function CALL(server)
	http.request(server, nil, headers)
end

local hardware = "Computer"

local useHTTPSproxy = _HOST:find("CCEmuRedux") ~= nil

do
	if turtle then
		hardware = "Turtle"
	end

	if pocket then
		hardware = "Pocket Computer"
	end

	if term.isColour() then
		hardware = "Advanced " .. hardware
	end

	if command then
		hardware = "Command Computer"
	end
end

local t = {}
local tabs = 0
local activetab = 1
local baredit = ""
local certificates = ""

local coloxrs = colours or colors
coloxrs.grxy = coloxrs.grey or coloxrs.gray
coloxrs.lightGrxy = coloxrs.lightGrey or coloxrs.lightGray

local w, h = term.getSize()
local xy, tc, bg = term.setCursorPos, term.setTextColor, term.setBackgroundColor

local port = window.create(term.current(), 1, 4, w, h - 4)
port.setBackgroundColour(coloxrs.white)
port.clear()

local server = {}
server.dns = "http://krist.ceriat.net/?a="
server.cert = "http://kscert.ceriat.net/"
server.cert = "http://ceriat.net/kristnet/cert"
server.proxy = "http://https.ceriat.net/?l="

local kristScapeUserAgent = "KristScape/%s (%s; %s; #%d; en-gb)"

local headers = {
	["User-Agent"] = kristScapeUserAgent:format(version, hardware, os.version(), os.getComputerID());
	--["X-Magic"] = "plugh";
}

CALL(server.cert)

local function drawtabs()
	local tw = math.min(14, math.floor((w - math.min(9, tabs) - 4) / math.min(9, tabs)))
	xy(2,1)
	bg(coloxrs.black)
	term.clearLine()

	for i = 1, tabs do
		xy((tw+1)*(i-1)+2,1)

		if i == activetab then
			bg(coloxrs.lightGrxy)
			tc(coloxrs.grxy)
		else
			bg(coloxrs.grxy)
			tc(coloxrs.lightGrxy)
		end

		local tt = t[i].title:sub(1, tw - 3)
		term.write(" " .. tt .. string.rep(" ", tw - 3 - #tt))
		tc(coloxrs.red)
		term.write(" \215")
	end

	if tabs < 10 then
		xy(2 + (tw + 1) * tabs, 1)
		bg(coloxrs.grxy)
		tc(coloxrs.lightGrxy)
		return term.write(" + ")
	end
end

local function setstatus(status)
	bg(coloxrs.lightGrxy)
	tc(coloxrs.black)
	xy(1,h)
	return term.write(tostring(status) .. string.rep(" ", 25 - #tostring(status)))
end

local function seturl(url, v)
	bg(coloxrs.white)
	tc(coloxrs.black)
	xy(3,2)
	term.write(string.rep(" ",w-4))
	xy(3,2)
	local entered = true

	if type(v) ~= "string" then
		term.write(url)
	elseif v == "#SEL" then
		bg(coloxrs.cyan)
		tc(coloxrs.white)
		term.write(url:sub(-w + 5))
		bg(coloxrs.white)
		tc(coloxrs.red)
		term.write("_")
		entered = false
	elseif v:sub(1,1) == "#" then
		tc(coloxrs.red)
		term.write("_")
		entered = false
	else
		tc(coloxrs.red)
		term.write(v:sub(-w + 5) .. "_")
		entered = false
	end

	bg(coloxrs.white)

	if url:find(".kst") and entered then
		if certificates:find(url:sub(8, url:find(".kst") - 1)..";") then
			tc(coloxrs.green)
			xy(10,2)
			term.write(url:sub(8, url:find(".kst") + 3))
		end
	end
end

local function fullrender(n)
	local buffer, title, status, back = _KSML_(t[n].ksml,nil,nil,version,_SAND_,_INQU_)

	if #title > 0 then
		t[n].title = title
	elseif t[n].name == "" then
		t[n].title = "New Tab"
	else
		t[n].title = t[n].name..".kst"
	end

	if status > 255 then
		t[n].status = "Done (Compatibility mode)"
		status = status - 256
	end

	port.setBackgroundColor(2^tonumber(back,16))
	port.clear()

	for i=1,#buffer do
		if i == 1 and #buffer[i] % 3 == 1 then
			port.setBackgroundColor(2 ^ tonumber(buffer[i]:sub(#buffer[i] - 1), 16))
			--port.clear()
			buffer[i] = buffer[i]:sub(1, #buffer[i] - 1)
		end

		if #buffer[i] % 3 ~= 0 then
			break
		end

		local a = buffer[i]:sub(1, #buffer[i] / 3)
		local b = buffer[i]:sub(#buffer[i] / 3 + 1, 2 / 3 * #buffer[i])
		local c = buffer[i]:sub(2 / 3 * #buffer[i] + 1)

		port.setCursorPos(1,i)
		port.blit(a,b,c)
	end
	drawtabs()
	setstatus(t[n].status)
end

local function log(file,text)
	--[ [
	local LOG = fs.open("kst/logs/"..file..".log","a")
	LOG.writeLine(text)
	LOG.close()
	--]]
end

local function fixurl(url, thing)
	local name = nil

	if url:sub(1,7) ~= "http://" then
		url = "http://" .. url
	end

	if url:sub(1,7) == "http://" then
		if not url:sub(8):find(".kst") then
			url = url:gsub(".dia",".kst",1)
			url = url:gsub(".tar",".kst",1)
			url = url:gsub(".qst",".kst",1)
			url = url:gsub(".lra",".kst",1)
		end

		if not url:sub(8):find("/") then
			url = url .. "/"
		end

		name = url:lower():sub(8,url:sub(8):find("/")+6)
	end

	if thing == "url" then
		return url
	end

	if thing == "name" then
		return name:gsub(".kst","")
	end
end

local function class()
	local c = {}
	c.__index = c

	mt = {
		__call = function (cls, ...)
			local obj = {}
			setmetatable (obj, c)

			if cls.init then
				cls.init (obj, ...)
			end

			return obj
		end,
	}

	setmetatable (c, mt)
	return c
end

local tabClass = class()

function tabClass:init()
	self:reset()
end

function tabClass:reset()
	self.title = "New Tab"
	self.url = ""
	self.http = ""
	self.name = ""
	self.ksml = ""
	self.status = ""
	self.certified = false
	self.buffer = {}
	self.momentum = 100000
end

function tabClass:load (url)
	if url then
		self.url = fixurl(baredit,"url")
		self.name = fixurl(baredit,"name")
		self.title = fixurl(baredit,"name") .. ".kst"
		seturl(t[activetab].url,t[activetab].certified)
		drawtabs()
		log("history",self.url)
	end

	CALL(server["dns"] .. self.name .. "#at" .. tostring(activetab - 1))
	setstatus("Polling DNS...")
end
--[[
function tabClass.__tostring (obj) -- example
	return self.url .. " " .. self.name .. " " .. self.title
end]]--

local tab = {}

function tab.open(url)
	tabs = tabs + 1
	t[tabs]:reset()
	tab.switch(tabs)
	if url then
		t[tabs].url = url
		seturl(url)
	end
	drawtabs()
end

function tab.switch(n)
	activetab = n
	seturl(t[n].url,t[n].certified)
	drawtabs()
	fullrender(n)
end

function tab.close(n)
	local oldT = t[n]

	tabs = tabs - 1

	if tabs == 0 then
		running = false
	else
		if activetab == n then
			tab.switch(math.min(n, tabs))
		elseif activetab > n then
			tab.switch(activetab - 1)
		end
	end

	drawtabs()
end

for i=1,10 do
	t[i] = tabClass()
end

local function drawhud()
	xy(3,2)
	bg(coloxrs.lightGrxy)
	term.clearLine()
	bg(coloxrs.white)
	term.write(string.rep(" ",w-4))
	bg(coloxrs.lightGrxy)
	tc(coloxrs.white)
	term.write("  \171")
	xy(3,3)
	bg(coloxrs.lightGrxy)
	term.clearLine()
	xy(26,h)
	term.clearLine()
	tc(coloxrs.grxy)
	term.write("| ")
	bg(coloxrs.lightBlue)
	tc(coloxrs.blue)
	term.write(" \17 ")
	xy(32,h)
	term.write(" \16 ")
	xy(36,h)
	term.write(" r ")
	xy(40,h)
	term.write(" h ")
	xy(44,h)
	term.write(" Menu ")
end

local function ustat(tab)
	if activetab == tab then
		setstatus(t[tab].status)
	end
end

drawtabs()
drawhud()
xy(4,4)

local loading = false
local running = true

tab.open("")

while tabs > 0 do
	local ev, p1, p2, p3, p4 = os.pullEvent()

	if ev == "http_success" then
		log("http", p2.getResponseCode() .. " " .. p1)

		if p1:sub(1, #server.dns) == server.dns then
			local targettab = tonumber(p1:sub(#p1, #p1)) + 1
			local response = p2.readAll()

			if response:sub(1,1) == "$" then
				t[targettab].status = "Forwarding..."
				CALL(server.dns .. response:sub(2):gsub(".kst", "") .. "#at" .. tostring(targettab - 1))
				t[targettab].url = fixurl(response:sub(2), "url")
				t[targettab].name = response:sub(2):gsub(".kst", "")
				seturl(fixurl(response:sub(2), "url"))
				ustat(targettab)
			elseif #response > 0 then
				local prot = "http://"
				t[targettab].status = "Downloading page..."
				if response:sub(1,25) == "dl.dropboxusercontent.com" then
					if useHTTPSproxy then
						t[targettab].status = "Downloading by proxy..."
						prot = server.proxy
					else
						prot = "https://"
					end
				end
				CALL(prot .. response)
				t[targettab].http = fixurl(response, "url")
				ustat(targettab)
			else
				t[targettab].status = "No site found"
				ustat(targettab)
			end
		elseif p1:sub(1, #server.cert) == server.cert then
			certificates = p2.readAll()
			for i=1,10 do
				if certificates:find(t[i].name..";") then
					t[i].certified = true
				else
					t[i].certified = false
				end
			end
		else
			for i=1,10 do
				if t[i].http == p1 then
					t[i].ksml = p2.readAll()
					if certificates:find(t[i].name..";") then
						t[i].certified = true
					else
						t[i].certified = false
					end
					seturl(t[i].url,t[i].certified)

					if activetab == i then
						t[i].status = "Done"
						setstatus(t[i].status)
						fullrender(i)
					end

					break
				end
			end
		end
		p2:close()
	elseif ev == "http_failure" then
		if p1 == server.cert then
			--CALL(server.cert)
		else
			for i=1,10 do
				if t[i].http == p1 then
					if activetab == i then
						t[i].status = "Error"
						setstatus(t[i].status)
						fullrender(i)
					end

					break
				end
			end
		end
		log("http", "?" .. " " .. p1)
		-- rip ceriat 2007-2016
	elseif ev == "mouse_click" then
		baredit = ""
		seturl(t[activetab].url, t[activetab].certified)

		if p3 == 1 then -- Tabs
			local tw = math.min(14, math.floor((w - math.min(9, tabs) - 4) / math.min(9, tabs)))
			p2 = p2 - 1

			if math.ceil(p2 / (tw + 1)) ~= p2 / (tw + 1) then
				if tabs < 10 and math.ceil(p2 / (tw + 1)) == tabs + 1 and p2 % (tw + 1) <= 3 then
					tab.open()
				else
					if tw == p2 % (tw + 1) then
						tab.close(math.ceil(p2 / (tw + 1)))
					elseif math.ceil(p2/(tw+1)) <= tabs then
						tab.switch(math.ceil(p2 / (tw + 1)))
					end
				end
			end
		elseif p3 == 2 and p2 > 2 and p2 < w - 2 then -- Address bar
			if baredit == "" then
				baredit = "#SEL"
				seturl(t[activetab].url,baredit)
			end
		elseif p3 == h then -- Status bar

		elseif p2 == w then -- Scroll bar

		end
	elseif ev == "char" then
		if #baredit > 0 then
			if baredit:sub(1,1) == "#" and p1 ~= "#" then
				baredit = p1
			else
				baredit = baredit .. p1
			end
			seturl(t[activetab].url,baredit)
		end
	elseif ev == "key" then
		if #baredit > 0 then
			if p1 == keys.right then
				baredit = t[activetab].url
			elseif baredit == "#SEL" then
				if p1 == keys.enter then
					baredit = t[activetab].url
				else
					baredit = "#NUL "
				end
			end

			if p1 == keys.backspace then
				baredit = baredit:sub(1, #baredit - 1)

				if #baredit == 0 then
					baredit = "#NUL"
				end
			end

			if p1 == keys.enter then
				t[activetab]:load (baredit)
				baredit = ""
			else
				seturl(t[activetab].url,baredit)
			end
		end
	end
end

bg(coloxrs.black)
term.clear()
xy(1,1)
