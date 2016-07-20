-- BUTTONS MODULE

buttons = {
	-- Pressed buttons
	select = false,
	start = false,
	up = false,
	down = false,
	left = false,
	right = false,
	l = false,
	r = false,
	triangle = false,
	circle = false,
	cross = false,
	square = false,
	hold = false,
	play = false,
	forward = false,
	black = false,
	volup = false,
	voldown = false,
	hold = false,
	wlan = false,
	rmexists = false,
	analogx = 0,
	analogy = 0,

	-- Released buttons
	released = {
		select = false,
		start = false,
		up = false,
		down = false,
		left = false,
		right = false,
		l = false,
		r = false,
		triangle = false,
		circle = false,
		cross = false,
		square = false,
		hold = false,
		play = false,
		forward = false,
		black = false,
		volup = false,
		voldown = false,
		hold = false
	},
	
	-- Held buttons
	held = {
		select = false,
		start = false,
		up = false,
		down = false,
		left = false,
		right = false,
		l = false,
		r = false,
		triangle = false,
		circle = false,
		cross = false,
		square = false,
		hold = false,
		play = false,
		forward = false,
		black = false,
		volup = false,
		voldown = false,
		hold = false
	}
}

__SELECT   = 1
__START    = 4
__UP       = 5
__DOWN     = 7
__RIGHT    = 6
__LEFT     = 8
__L        = 9
__R        = 10
__TRIANGLE = 13
__CIRCLE   = 14
__CROSS    = 15
__SQUARE   = 16
__HOLD     = 18

local bchannel = love.thread.getChannel("buttons")

function buttons.read()
	-- Get update
	bchannel:push("update")
	-- Wait for 3 tables
	while bchannel:getCount() < 3 do end
	-- Update global tables
	while bchannel:getCount() > 0 do
		local tbuttons = bchannel:pop()
		-- Press table
		if tbuttons.type == "press" then
			tbuttons.type = nil
			-- Save all variables in table buttons
			local trel = buttons.released
			local thel = buttons.held
			local fread = buttons.read
			local finter = buttons.interval
			local fwait = buttons.waitforkey
			local fanalog = buttons.analogtodpad
			local fhome = buttons.homepopup
			local fassign = buttons.assign
			-- Set buttons press
			buttons = tbuttons
			buttons.released = trel
			buttons.held = thel
			buttons.read = fread
			buttons.interval = finter
			buttons.waitforkey = fwait
			buttons.analogtodpad = fanalog
			buttons.homepopup = fhome
			buttons.assign = fassign
		-- Released table
		elseif tbuttons.type == "released" then
			tbuttons.type = nil
			buttons.released = tbuttons
		-- Held table
		elseif tbuttons.type == "held" then
			tbuttons.type = nil
			buttons.held = tbuttons
		end
	end
end

function buttons.interval(delay, interval)
end
 
function buttons.waitforkey(key)
	-- When no key is set
	if key == nil then
		while true do
			buttons.read()
			if buttons.select       then return __SELECT
			elseif buttons.start    then return __START
			elseif buttons.up       then return __UP
			elseif buttons.down     then return __DOWN
			elseif buttons.right    then return __RIGHT
			elseif buttons.left     then return __LEFT
			elseif buttons.l        then return __L
			elseif buttons.r        then return __R
			elseif buttons.triangle then return __TRIANGLE
			elseif buttons.circle   then return __CIRCLE
			elseif buttons.cross    then return __CROSS
			elseif buttons.square   then return __SQUARE
			elseif buttons.hold     then return __HOLD     end
		end
	end
	-- Key setted
	while true do
		buttons.read()
		if buttons.select       and key == __SELECT   then break
		elseif buttons.start    and key == __START    then break
		elseif buttons.up       and key == __UP       then break
		elseif buttons.down     and key == __DOWN     then break
		elseif buttons.right    and key == __RIGHT    then break
		elseif buttons.left     and key == __LEFT     then break
		elseif buttons.l        and key == __L        then break
		elseif buttons.r        and key == __R        then break
		elseif buttons.triangle and key == __TRIANGLE then break
		elseif buttons.circle   and key == __CIRCLE   then break
		elseif buttons.cross    and key == __CROSS    then break
		elseif buttons.square   and key == __SQUARE   then break
		elseif buttons.hold     and key == __HOLD     then break end
	end
end

function buttons.analogtodpad(deadzone)
	-- Set conversion
	bchannel:push({"analtopad", deadzone})
end 
 
function buttons.homepopup(state)
	-- Set home menu
	bchannel:push({"homepopup", state})
end
 
function buttons.assign()
	return 1
end