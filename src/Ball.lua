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
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
		love.audio.play(sounds['wall-hit'])
	-- the logic where the ball is hitting the below paddle ground is not necessary
	-- TODO: to be deleted
	elseif self.y + self.height >= constants.VIRTUAL_HEIGHT then
		self.y = constants.VIRTUAL_HEIGHT - self.height
		self.dy = - self.dy
	end

	if self.x <= 0 then
		self.x = 0
		self.dx = - self.dx
		love.audio.play(sounds['wall-hit'])
	elseif self.x + self.width >= constants.VIRTUAL_WIDTH then
		self.x = constants.VIRTUAL_WIDTH - self.width
		self.dx = - self.dx
		love.audio.play(sounds['wall-hit'])
	end
end

function Ball:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

-- [[
-- Function that returns whether ball collides with rectangle like object
-- who has x, y, width and height 
-- ]]
function Ball:collides(rectangle)
	if self.x > rectangle.x + rectangle.width or rectangle.x > self.x + self.width then
		return false
	end

	if self.y > rectangle.y + rectangle.height or rectangle.y > self.y + self.height then
		return false
	end
	return true
end
