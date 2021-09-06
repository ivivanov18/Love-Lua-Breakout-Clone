push = require 'lib/push'
local constants = require 'src/constants'
require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'

function draw_bricks()
	for row, line_of_bricks in ipairs(bricks) do
		for col, brick in ipairs(line_of_bricks) do
			brick:draw()
		end
	end
end

function generate_bricks(virtual_width, nb_rows )
	local new_bricks = {}
	-- start position to generate
	current_x = 30
	current_y = 20
	width = 30
	height = 10
	space = 1
	current_column = 1
	for current_row = 1, nb_rows do
		new_bricks[current_row] = {}
		while current_x + width + space <= virtual_width - width do
			new_bricks[current_row][current_column] = Brick:new({ x = current_x, y = current_y, width = width, height = height}) 
			current_x = current_x + width + space
			current_column = current_column + 1
		end
		current_y = current_y + height + space
		current_x = 30
		current_column = 1
	end
	return new_bricks
end

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
	Paddle:load(210, 213, 40, 10)
	Ball:load(Paddle.x + Paddle.width / 2 - 8/ 2, Paddle.y - 8)
	gameState = "serve"
	bricks1 = {
		Brick:new({x = 30, y = 20, width = 30, height = 10}),
		Brick:new({x = 61, y = 20, width = 30, height = 10}),
		Brick:new({x = 92, y = 20, width = 30, height = 10}),
	}

	bricks = generate_bricks( constants.VIRTUAL_WIDTH, 5)
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
			Ball.dx = math.random(2) == 1 and -100 or 100
			Ball.dy = math.random(-80,-100)
		end
	elseif gameState == "play" then
		Paddle:update(dt)
		Ball:update(dt)
		if Ball:collides(Paddle) then
			Ball.y = Paddle.y - Ball.height
			Ball.dy = - Ball.dy
		end
		for row, line_of_bricks in ipairs(bricks) do
			for col, brick in ipairs(line_of_bricks) do
				if (Ball:collides(brick)) then
					brick.isAlive = false
					-- TODO: add logic to manage ball bouncing when ball gets hit
				end
			end
		end
	end
	love.keyboard.keyPressed = {}
end


function love.draw()
	push:apply('start')
	love.graphics.printf('Love BREAKOUT', 0, constants.VIRTUAL_HEIGHT / 2 - 6, constants.VIRTUAL_WIDTH, 'center')
	love.graphics.setBackgroundColor(115/255, 27/255, 135/255, 50/100)
	Paddle:draw()
	Ball:draw()
	draw_bricks()
	displayFPS()
	push:apply('end')
end

function displayFPS()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
