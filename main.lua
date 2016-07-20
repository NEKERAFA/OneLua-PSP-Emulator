--[[
	* main.lua
	* Created by NEKERAFA on thu 12 jul 2016 15:28
	* 
	* Main menu and onelua script laucher
]]

-- Material library
local material, draggable
local w, h, ps
local close = false
local settings = false

-- Objects
local AppBar
local Minimize
local Close
local Settings
local CardList

local Collisions = {
	circle = function (x,y,c,f,e)
		local f = f or function () end
		local e = e or function () end

		if (x - c.x)^2 + (y - c.y)^2 < c.r ^ 2 then
			f(x,y,c)
		else
			e(x,y,c)
		end
	end,

	box = function (x,y,b,f,e)
		local f = f or function () end
		local e = e or function () end

		if 	x > b.x and
			y > b.y and
			x < b.x + b.w and
			y < b.y + b.h then

			f(x,y,b,t)
		else
			e(x,y,b,t)
		end
	end,
	
	inoutbox = function(x,y,ib,ob,f,e)
		local f = f or function () end
		local e = e or function () end
		
		if x > ib.x and
		   y > ib.y and
		   x < ib.y + ib.w and
		   y < ib.y + ib.h and
		   not (x > ob.x and
		   y > ob.y and
		   x < ob.y + ob.w and
		   y < ob.y + ob.h) then
			f(x,y,ib,ob)
		else
			e(x,y,ib,ob)
		end
	end
}

function love.load(arg)
	-- Libraries
	material = require("lib/material-love")
	draggable = require("lib/draggable")
	-- Programs
	dofile("bin/onelua/onelua-main.lua")

	w, h = love.graphics.getDimensions()
	ps = love.window.getPixelScale()

	-- Background
	love.graphics.setBackgroundColor(material.colors.background("light"))
	
	-- AppBar
	AppBar = {x = 0, y = 0, w = w, h = 48 * ps}
	-- Close button
	Close = material.ripple.circle(AppBar.w-24*ps, AppBar.h/2, 16*ps)
	-- Minimize button
	Minimize = material.ripple.circle(AppBar.w-56*ps, AppBar.h/2, 16*ps)
	-- Settings button
	Settings = material.ripple.circle(AppBar.w-88*ps, AppBar.h/2, 16*ps)
	
	local AppList1 = love.filesystem.getDirectoryItems("media/ms0/PSP/GAME/")
	local AppList2 = love.filesystem.getDirectoryItems("media/ef0/PSP/GAME/")
	
	-- List with OneLua App Cards
	CardList = {x = 10, y = AppBar.h+10, miny = AppBar.h+10, w = w-20, h = 64, space = 10, v = 0, cards = {}}
	-- Load cards from ms0
	for pos, file in pairs(AppList1) do
		elem = "media/ms0/PSP/GAME/"..file
		
		if love.filesystem.isDirectory(elem) and love.filesystem.exists(elem.."/script.lua") then
			print("App found: "..elem)
			table.insert(CardList.cards, {title = file, path = "ms0:/PSP/GAME/"..file.."/script.lua"})
		end
	end
	-- Load cards from ef0
	for pos, file in pairs(AppList2) do
		elem = "media/ef0/PSP/GAME/"..file
		
		if love.filesystem.isDirectory(elem) and love.filesystem.exists(elem.."/script.lua") then
			print("App found: "..elem)
			table.insert(CardList.cards, {title = file, path = "ef0:/PSP/GAME/"..file.."/script.lua"})
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if scancode == "escape" then
		love.event.quit(0)
	end
end

function love.update(dt)
	-- Update thread info
	if onelua.isExecuting() then
		onelua.update(dt)
	-- Update Menú info
	else
		-- Update buttons
		Close:update(dt)
		Minimize:update(dt)
		Settings:update(dt)
		-- Update card list
		if #CardList.cards > 6 then
			CardList.y = math.max(math.min(CardList.y + CardList.v * dt, CardList.miny), h-(#CardList.cards*(CardList.h+CardList.space)))
			CardList.v = CardList.v - CardList.v*math.min(dt*5, 1)
		end
	end
end

function love.draw()
	-- Draw emulator
	if onelua.isExecuting() then
		onelua.draw_screen()
		love.graphics.print(string.format("%i FPS, %.2f KB", love.timer.getFPS(), collectgarbage("count")), 10, 10)
	-- Draw app
	else
		-- Apps
		for pos, app in pairs(CardList.cards) do
			love.graphics.setColor(255, 255, 255, 255)
			card = {x = CardList.x*ps, y = CardList.y*ps+(pos-1)*(CardList.h+CardList.space)*ps, w = CardList.w*ps, h = CardList.h*ps}
			card.p = material.roundrect(card.x, card.y, card.w, card.h, 2, 2) 
			material.shadow.draw(card.x, card.y, card.w, card.h, false, false, 3)
			love.graphics.polygon("fill", unpack(card.p))
			love.graphics.polygon("line", unpack(card.p))
			love.graphics.setColor(material.colors.mono("black", "subhead"))
			love.graphics.setFont(material.roboto("title"))
			love.graphics.printf(app.title, card.x+16*ps, card.y+10*ps, card.w-32*ps)
			love.graphics.setColor(material.colors.mono("black", "secondary-text"))
			love.graphics.setFont(material.roboto("subhead"))
			love.graphics.printf(app.path, card.x+16*ps, card.y+card.h-24*ps, card.w-32*ps)
		end

		-- Title
		material.shadow.draw(AppBar.x, AppBar.y, AppBar.w, AppBar.h, false, false, 2)
		love.graphics.setColor(material.colors("light-green"))
		love.graphics.rectangle("fill", AppBar.x, AppBar.y, AppBar.w, AppBar.h)
		love.graphics.rectangle("line", AppBar.x, AppBar.y, AppBar.w, AppBar.h)
		love.graphics.setColor(material.colors.mono("white", "title"))
		love.graphics.setFont(material.roboto("title"))
		love.graphics.printf("OneLua PSP Emulator", AppBar.x, AppBar.y+14*ps, AppBar.w, "center")
		Close:draw()
		material.icons.draw("close", Close.circle.x, Close.circle.y)
		Settings:draw()
		material.icons.draw("dots-vertical", Settings.circle.x, Settings.circle.y)
		Minimize:draw()
		material.icons.draw("minus", Minimize.circle.x, Minimize.circle.y)

		-- Window border
		love.graphics.setColor(material.colors.background("dark"))
		love.graphics.rectangle("line", 0, 0, 960, 540)
	end
end

function love.mousepressed(x, y, button, istouch)
	-- Control app
	if not onelua.isExecuting() then
		-- Close
		Collisions.circle(x, y, Close.circle, function()
			Close:start(x, y, material.colors("light-green", "200"))
			if button == 1 then close = true end
		end)
		-- Minimize
		Collisions.circle(x, y, Minimize.circle, function()
			Minimize:start(x, y, material.colors("light-green", "200"))
			if button == 1 then love.window.minimize() end
		end)
		-- Settings
		Collisions.circle(x, y, Settings.circle, function()
			Settings:start(x, y, material.colors("light-green", "200"))
			if button == 1 then settings = true end
		end)

		for pos, app in pairs(CardList.cards) do
			card = {x = CardList.x, y = CardList.y+(pos-1)*(CardList.h+CardList.space), w = CardList.w, h = CardList.h}
			Collisions.inoutbox(x, y, card, AppBar, function()
				if button == 1 then
					print("Starting "..app.title)
					onelua.run(app.path)
					--love.event.quit(0)
				end
			end)
		end

		-- Move
		--[[Collisions.box(x, y, AppBar, function()
			if button == 1 then draggable.start() end
		end)]]
	end
end

function love.mousereleased(x, y, button, istouch)
	-- Control app
	if not onelua.isExecuting() then
		Close:fade()
		Minimize:fade()
		Settings:fade()
		-- draggable.stop()
		if close then love.event.quit(0) end
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
	-- draggable.move(dx, dy)
end

function love.wheelmoved(dx, dy)
	-- Change velocity
	if not onelua.isExecuting() and #CardList.cards > 6 then
		CardList.v = CardList.v + dy*150
	end
end