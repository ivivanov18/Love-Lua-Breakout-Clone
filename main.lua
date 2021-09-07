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
	bricks = generate_bricks( constants.VIRTUAL_WIDTH, 1)

	-- init sounds
	sounds = {
		['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit_2.wav', 'static'),
		['brick-hit'] = love.audio.newSource('sounds/brick_hit.wav', 'static'),
		['loss'] = love.audio.newSource('sounds/loss_sound.wav', 'static'),
		['victory'] = love.audio.newSource('sounds/victory.wav', 'static')
	}
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'space' and gameState == 'victory' then
		gameState = 'serve'
		bricks = generate_bricks( constants.VIRTUAL_WIDTH, 1)
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
			love.audio.play(sounds['paddle-hit'])
		end
		for row, line_of_bricks in ipairs(bricks) do
			for col, brick in ipairs(line_of_bricks) do
				if (brick.isAlive and Ball:collides(brick)) then
					brick.isAlive = false
					love.audio.play(sounds['brick-hit'])
					-- Check from which side to change rebound velocity accordingly
					diffBottomBrickTopBall = math.abs(brick.y + brick.height - Ball.y)
					diffTopBrickBottomBall = math.abs(brick.y - (Ball.y + Ball.height))
					diffRightBrickLeftBall = math.abs(brick.x + brick.width - Ball.x)
					diffLeftBrickRightBall = math.abs(brick.x - (Ball.x + Ball.width))

					-- From bottom brick
					if (Ball.dy < 0
						and diffBottomBrickTopBall < diffTopBrickBottomBall
						and diffBottomBrickTopBall < diffLeftBrickRightBall
						and diffBottomBrickTopBall < diffRightBrickLeftBall
						) then
						Ball.dy = math.abs(Ball.dy)
					end
					-- From Top brick
					if (Ball.dy > 0
						and diffTopBrickBottomBall < diffBottomBrickTopBall
						and diffTopBrickBottomBall < diffLeftBrickRightBall
						and diffTopBrickBottomBall < diffRightBrickLeftBall
						) then
						Ball.dy = -math.abs(Ball.dy)
					end
					-- From left brick
					if (Ball.dx > 0
						and diffLeftBrickRightBall < diffTopBrickBottomBall
						and diffLeftBrickRightBall < diffBottomBrickTopBall
						and diffLeftBrickRightBall < diffRightBrickLeftBall
						) then
						Ball.dx = math.abs(Ball.dx)
					end
					-- From right of brick
					if (Ball.x < 0
						and diffRightBrickLeftBall < diffLeftBrickRightBall
						and diffRightBrickLeftBall < diffTopBrickBottomBall
						and diffRightBrickLeftBall < diffBottomBrickTopBall
						) then
						Ball.dx = - math.abs(Ball.dx)
					end

				end
			end
		end
		if (are_bricks_left(bricks) == false) then
			gameState = "victory"
			love.audio.play(sounds['victory'])
		end
	end
	love.keyboard.keyPressed = {}
end


function love.draw()
	push:apply('start')
	if (gameState == 'serve') then
		love.graphics.printf('Alex\'s Breakout', 0, constants.VIRTUAL_HEIGHT / 2 - 6, constants.VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Space to start the game', 0, constants.VIRTUAL_HEIGHT / 2 + 20, constants.VIRTUAL_WIDTH, 'center')
	end
	if (gameState == 'victory') then
		love.graphics.printf('You WIN!!!', 0, constants.VIRTUAL_HEIGHT / 2 - 6, constants.VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Space for new game', 0, constants.VIRTUAL_HEIGHT / 2 + 20, constants.VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Esc to quit', 0, constants.VIRTUAL_HEIGHT / 2 + 40, constants.VIRTUAL_WIDTH, 'center')
	end

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

function are_bricks_left(bricks)
	for i, line_of_bricks in ipairs(bricks) do
		for j, brick in ipairs(line_of_bricks) do
			if brick.isAlive == true then
				return true
			end
		end
	end
	return false
end
