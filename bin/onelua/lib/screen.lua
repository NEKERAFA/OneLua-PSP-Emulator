-- SCREEN MODULE
screen = {}

__ALEFT = 0
__ACENTER = 512
__ARIGHT = 1024
__AFULL = 1536
__SLEFT = 8192
__SRIGHT = 9216
__STHROUGH = 9728
__SSEESAW = 8704

local schannel = love.thread.getChannel("screen")

function screen.print(x, y, text)
	-- Send text to print
	schannel:push({type = "print", x = x, y = y, text = text})
end

function screen.flip()
	schannel:supply("flip")
end