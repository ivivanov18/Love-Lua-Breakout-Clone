push = require 'lib/push'
local constants = require 'src/constants'
require 'src/Paddle'
require 'src/Ball'

gameState = "serve"

function love.load()
	-- init graphics
	love.graphics.setDefaultFilter('nearest', 'nearest')
	push:setupScreen(constants.VIRTUAL_WIDTH, constants.VIRTUAL_HEIGHT,
					 constants.WINDOW_WIDTH,constants.WINDOW_HEIGHT, {
						vsync = true,
						fullscreen = true,
						resizable = true
					}) 

	font = love.graphics.newFont('fonts/font.ttf', 20)
	love.graphics.setFont(font)

	-- init input
	love.keyboard.keyPressed = {}

	-- init player
	score = 0
	Paddle:load(210, 213, 30, 10)
	Ball:load(Paddle.x + Paddle.width / 2 - 8/ 2, Paddle.y - 8)
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
	if gameState == "serve" then
		Paddle:update(dt)
		Ball.y = Paddle.y - Ball.height
		Ball.x = Paddle.x + Paddle.width / 2 - Ball.width/2
		Ball:update(dt)
		if love.keyboard.wasPressed('space') then
			gameState = "play"
			math.randomseed(os.time())
			ballVel = math.random(120, 180)
			Ball.dx = ballVel
			Ball.dy = - ballVel
		end
	elseif gameState == "play" then
		Paddle:update(dt)
		Ball:update(dt)
	end
	love.keyboard.keyPressed = {}
end


function love.draw()
	push:apply('start')
	love.graphics.printf('Love BREAKOUT', 0, constants.VIRTUAL_HEIGHT / 2 - 6, constants.VIRTUAL_WIDTH, 'center')
	love.graphics.setBackgroundColor(115/255, 27/255, 135/255, 50/100)
	Paddle:draw()
	Ball:draw()
	displayFPS()
	push:apply('end')
end

function displayFPS()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
