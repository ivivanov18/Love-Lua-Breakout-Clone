push = require 'lib/push'
local constants = require 'src/constants'
require 'src/Paddle'

function love.load()
	print(love.getVersion())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	push:setupScreen(constants.VIRTUAL_WIDTH, constants.VIRTUAL_HEIGHT,
					 constants.WINDOW_WIDTH,constants.WINDOW_HEIGHT, {
						vsync = true,
						fullscreen = true,
						resizable = true
					}) 

	Paddle:load(210, 213, 30, 10)
	love.keyboard.keyPressed = {}
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keyPressed[key] then
		return true
	else
		return false
	end
end

function love.resize(w,h)
	push:resize(w,h)
end

function love.update(dt)
	Paddle:update(dt)
	love.keyboard.keyPressed = {}
end


function love.draw()
	push:apply('start')
--	love.graphics.printf('Love BREAKOUT', 0, constants.VIRTUAL_HEIGHT / 2 - 6, constants.VIRTUAL_WIDTH, 'center')
	love.graphics.setBackgroundColor(115/255, 27/255, 135/255, 50/100)
	Paddle:draw()
	push:apply('end')
end
