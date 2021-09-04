local constants = require('src/constants')

Paddle = {}

function Paddle:load(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dx = 0
end


function Paddle:update(dt)
	if love.keyboard.isDown('left') then
		self.dx = - constants.PADDLE_SPEED
		self.x = math.max(0, self.x + self.dx * dt)
	elseif love.keyboard.isDown('right') then
		self.dx =  constants.PADDLE_SPEED
		self.x = math.min(constants.VIRTUAL_WIDTH - self.width, self.x + self.dx * dt) 
	end
end

function Paddle:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
