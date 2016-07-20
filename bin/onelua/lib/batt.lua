-- BATTERY MODULE

batt = {}

function batt.exists()
	return love.system.getPowerInfo() == "battery"
end
 
function batt.charging()
	return love.system.getPowerInfo() == "charging"
end
 
function batt.lifepercent()
	state, perc = love.system.getPowerInfo()
	return perc
end
 
function batt.lifetimemin()
 	state, perc, seconds = love.system.getPowerInfo()
	return math.floor(seconds/60)
end
 
function batt.lifetime()
	state, perc, seconds = love.system.getPowerInfo()
	if seconds == nil then return "-" end
	return string:format("%d:%d", seconds/60/60, math.ceil(seconds/60)-seconds/60)
end
 
function batt.temp() return "-" end
 
function batt.volt() return "-" end
 
function batt.remaincap() return "-" end
 
function batt.fullcap() return "-" end
 
function batt.low()
 	state, perc = love.system.getPowerInfo()
	if perc == nil then return false end
	return perc == 15
end
 
function batt.serial() return "-" end
 
function batt.mode () return "NORMAL" end
 
function batt.tonormal() return 0 end
 
function batt.topandora() return 0 end
 
function batt.toautoboot() return 0 end
 
function batt.backupbat(path) return 0 end
 
function batt.restorebat(path) return 0 end