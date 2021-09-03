push = require 'lib/push'
local constants = require 'src/constants'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	push:setupScreen(constants.VIRTUAL_WIDTH, constants.VIRTUAL_HEIGHT,
					 constants.WINDOW_WIDTH,constants.WINDOW_HEIGHT, {
						vsync = true,
						fullscreen = false,
						resizable = true
					})
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
end


function love.draw()
	push:apply('start')
	love.graphics.printf('Love BREAKOUT', 0, constants.VIRTUAL_HEIGHT / 2 - 6, constants.VIRTUAL_WIDTH, 'center')
	push:apply('end')
end
