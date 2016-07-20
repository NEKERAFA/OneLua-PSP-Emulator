--[[
	* onelua-thread.lua
	* Created by NEKERAFA on thu 12 jul 2016 15:28
	* 
	* OneLua 4R1 Laucher
]]

-- Arguments
local arg = {...}

local onelua = {}

-- Functions
-- Adhoc
dofile("bin/onelua/lib/adhoc.lua")
-- Battery
dofile("bin/onelua/lib/batt.lua")
-- Buttons
dofile("bin/onelua/lib/buttons.lua")
-- Screen
dofile("bin/onelua/lib/screen.lua")

function onelua.isAbsolute(path)
	if path:sub(1,1) == "/" then
		return true
	elseif path:find("[%a%d]+:/") then
		return true
	end
	
	return false
end

function onelua.getRoot(path)
	return path:match("[%a%d]+:/")
end

onelua.gamePath = "media/"..arg[1]:match("(.-)([^//]-([^%.]+))$")

-- File to emulated
onelua.dofile = dofile
function dofile(filename)
	if onelua.isAbsolute(filename) then
		filename = "media/"..filename:gsub(":", "")
	else
		filename = onelua.gamePath:gsub(":", "")..filename
	end
	
	print("> dofile in "..filename)
	onelua.dofile(filename)
end

dofile(arg[1])

error("Finish execution")