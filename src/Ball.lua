local constants = require('src/constants')

Ball = {}

function Ball:load(x, y)
	self.x = x
	self.y = y
	self.width = 8 
	self.height = 8 
	self.dx = 0
	self.dy = 0 
end

function Ball:update(dt)
	self.x = self.x + self.dx 
	self.y = self.y + self.dy 
	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
	-- the logic where the ball is hitting the below paddle ground is not necessary
	-- TODO: to be deleted
	elseif self.y + self.height >= constants.VIRTUAL_HEIGHT then
		self.y = constants.VIRTUAL_HEIGHT - self.height
		self.dy = - self.dy
	end

	if self.x <= 0 then
		self.x = 0
		self.dx = - self.dx
	elseif self.x + self.width >= constants.VIRTUAL_WIDTH then
		self.x = constants.VIRTUAL_WIDTH - self.width
		self.dx = - self.dx
	end
end

function Ball:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
