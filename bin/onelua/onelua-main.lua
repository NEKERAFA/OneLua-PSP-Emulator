--[[
	* onelua.lua
	* Created by NEKERAFA on thu 12 jul 2016 15:28
	* 
	* OneLua 4R1 translator for Löve 0.10.1
]]

-- Module for translator
onelua = {}

-- Table with all data for translator
local translator = {
	-- Global channel
	gchannel = love.thread.getChannel("global"),
	-- Thread
	thread = love.thread.newThread("bin/onelua/onelua-thread.lua"),
	-- Thread started
	start = false,
	-- Screen buffer
	screenchannel = love.thread.getChannel("screen"),
	imagebuffer = {},
	screenonbuffer = {},
	screenoffbuffer = {},
	-- Default font
	sfont = love.graphics.newFont("res/fonts/sce-font.ttf", 40),
	tfont = love.graphics.newFont("res/fonts/terminus.ttf", 20),
	-- Controls buffer
	controlschannel = love.thread.getChannel("buttons"),
	controlspress = {
		-- Pressed buttons
		type = "press",
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
		wlan = true,
		rmexists = false,
		analogx = 0,
		analogy = 0
	},
	controlsreleased = {
		-- Released buttons
		type = "released",
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
	controlsheld = {
		-- Held buttons
		type = "held",
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
	controlsbufferupdate = true,
}

-- Run a script in OneLua
function onelua.run(path)
	if not translator.start then
		print("Starting emulator")
		love.graphics.setBackgroundColor(0,0,0,255)
		love.graphics.setFont(translator.sfont)
		-- Start thread for emulate
		translator.thread:start(path)
		translator.start = true
	end
end

-- If the thread is executing
function onelua.isExecuting()
	return translator.start
end

-- Send controls to translator
function onelua.send_controls()
	if translator.controlschannel:getCount() > 0 then
		msg = translator.controlschannel:pop()

		if type(msg) == "string" then
			-- Sending buffers
			if msg == "update" then
				translator.controlschannel:push(translator.controlspress)
				translator.controlschannel:push(translator.controlsreleased)
				translator.controlschannel:push(translator.controlsheld)
				translator.controlsbufferupdate = true
			end
		elseif type(msg) == "table" then
		else
			error("Missing message", 2)
		end
	end
end

function onelua.update_controls()
	if translator.controlsbufferupdate then
-- ****** Update button UP ******
		if love.keyboard.isScancodeDown("w") or love.keyboard.isScancodeDown("up") then
			if not translator.controlsheld.up and not translator.controlspress.up then
				translator.controlspress.up = true
			else
				translator.controlspress.up = false
			end
			translator.controlsheld.up = true
		else
			if translator.controlsheld.up and not translator.controlsreleased.up then
				translator.controlsreleased.up = true
			else
				translator.controlsreleased.up = false
			end
			translator.controlsheld.up = false
		end
-- ****** Update button DOWN ******
		if love.keyboard.isScancodeDown("s") or love.keyboard.isScancodeDown("down") then
			if not translator.controlsheld.down and not translator.controlspress.down then
				translator.controlspress.down = true
			else
				translator.controlspress.down = false
			end
			translator.controlsheld.down = true
		else
			if translator.controlsheld.down and not translator.controlsreleased.down then
				translator.controlsreleased.down = true
			else
				translator.controlsreleased.down = false
			end
			translator.controlsheld.down = false
		end
-- ****** Update button LEFT ******
		if love.keyboard.isScancodeDown("a") or love.keyboard.isScancodeDown("left") then
			if not translator.controlsheld.left and not translator.controlspress.left then
				translator.controlspress.left = true
			else
				translator.controlspress.left = false
			end
			translator.controlsheld.left = true
		else
			if translator.controlsheld.left and not translator.controlsreleased.left then
				translator.controlsreleased.left = true
			else
				translator.controlsreleased.left = false
			end
			translator.controlsheld.left = false
		end
-- ****** Update button RIGHT ******
		if love.keyboard.isScancodeDown("d") or love.keyboard.isScancodeDown("right") then
			if not translator.controlsheld.right and not translator.controlspress.right then
				translator.controlspress.right = true
			else
				translator.controlspress.right = false
			end
			translator.controlsheld.right = true
		else
			if translator.controlsheld.right and not translator.controlsreleased.right then
				translator.controlsreleased.right = true
			else
				translator.controlsreleased.right = false
			end
			translator.controlsheld.right = false
		end
-- ****** Update button TRIANGLE ******
		if love.keyboard.isScancodeDown("i") then
			if not translator.controlsheld.triangle and not translator.controlspress.triangle then
				translator.controlspress.triangle = true
			else
				translator.controlspress.triangle = false
			end
			translator.controlsheld.triangle = true
		else
			if translator.controlsheld.triangle and not translator.controlsreleased.triangle then
				translator.controlsreleased.triangle = true
			else
				translator.controlsreleased.triangle = false
			end
			translator.controlsheld.triangle = false
		end
-- ****** Update button CROSS ******
		if love.keyboard.isScancodeDown("k") then
			if not translator.controlsheld.cross and not translator.controlspress.cross then
				translator.controlspress.cross = true
			else
				translator.controlspress.cross = false
			end
			translator.controlsheld.cross = true
		else
			if translator.controlsheld.cross and not translator.controlsreleased.cross then
				translator.controlsreleased.cross = true
			else
				translator.controlsreleased.cross = false
			end
			translator.controlsheld.cross = false
		end
-- ****** Update button SQUARE ******
		if love.keyboard.isScancodeDown("j") then
			if not translator.controlsheld.square and not translator.controlspress.square then
				translator.controlspress.square = true
			else
				translator.controlspress.square = false
			end
			translator.controlsheld.square = true
		else
			if translator.controlsheld.square and not translator.controlsreleased.square then
				translator.controlsreleased.square = true
			else
				translator.controlsreleased.square = false
			end
			translator.controlsheld.square = false
		end
-- ****** Update button CIRCLE ******
		if love.keyboard.isScancodeDown("l") then
			if not translator.controlsheld.circle and not translator.controlspress.circle then
				translator.controlspress.circle = true
			else
				translator.controlspress.circle = false
			end
			translator.controlsheld.circle = true
		else
			if translator.controlsheld.circle and not translator.controlsreleased.circle then
				translator.controlsreleased.circle = true
			else
				translator.controlsreleased.circle = false
			end
			translator.controlsheld.circle = false
		end
-- ****** Update button R ******
		if love.keyboard.isScancodeDown("q") then
			if not translator.controlsheld.r and not translator.controlspress.r then
				translator.controlspress.r = true
			else
				translator.controlspress.r = false
			end
			translator.controlsheld.r = true
		else
			if translator.controlsheld.r and not translator.controlsreleased.r then
				translator.controlsreleased.r = true
			else
				translator.controlsreleased.r = false
			end
			translator.controlsheld.r = false
		end
-- ****** Update button L ******
		if love.keyboard.isScancodeDown("o") then
			if not translator.controlsheld.l and not translator.controlspress.l then
				translator.controlspress.l = true
			else
				translator.controlspress.l = false
			end
			translator.controlsheld.l = true
		else
			if translator.controlsheld.l and not translator.controlsreleased.l then
				translator.controlsreleased.l = true
			else
				translator.controlsreleased.l = false
			end
			translator.controlsheld.l = false
		end
-- ****** Update button SELECT ******
		if love.keyboard.isScancodeDown("z") then
			if not translator.controlsheld.select and not translator.controlspress.select then
				translator.controlspress.select = true
			else
				translator.controlspress.select = false
			end
			translator.controlsheld.select = true
		else
			if translator.controlsheld.select and not translator.controlsreleased.select then
				translator.controlsreleased.select = true
			else
				translator.controlsreleased.select = false
			end
			translator.controlsheld.select = false
		end
-- ****** Update button START ******
		if love.keyboard.isScancodeDown("x") then
			if not translator.controlsheld.start and not translator.controlspress.start then
				translator.controlspress.start = true
			else
				translator.controlspress.start = false
			end
			translator.controlsheld.start = true
		else
			if translator.controlsheld.start and not translator.controlsreleased.start then
				translator.controlsreleased.start = true
			else
				translator.controlsreleased.start = false
			end
			translator.controlsheld.start = false
		end

		-- Buffer updated, wait for send
		translator.controlsbufferupdate = false
	end
end

-- Receive all elements to print in the screen
function onelua.receive_buffer_screen()
	if translator.screenchannel:getCount() > 0 then
		msg = translator.screenchannel:pop()
		
		if type(msg) == "string" then
			if msg == "flip" then
				translator.screenonbuffer = nil
				translator.screenonbuffer = translator.screenoffbuffer
				translator.screenoffbuffer = {}
			end
		elseif type(msg) == "table" then
			table.insert(translator.screenoffbuffer, msg)
		end
	end
end

-- Print all objects in the buffer
function onelua.draw_screen()
	for pos, obj in ipairs(translator.screenonbuffer) do
		if obj.type == "print" then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.print(obj.text, obj.x*2, obj.y*2, 0, 0.7, 0.7, 0, 0)
		end
	end
end

-- Updating resources
function onelua.update(dt)
	if translator.start and not translator.thread:isRunning() then
		error("Error to translate code: "..translator.thread:getError(), 2)
	end
	
	onelua.send_controls()
	onelua.update_controls()
	onelua.receive_buffer_screen()
end