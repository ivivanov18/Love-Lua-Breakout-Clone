Brick = {}

function Brick:new(o)
	o = o or {}
	-- isAlive property is used to determine whether or not can be drawn
	o.isAlive = true
	setmetatable(o, self)
	self.__index = self
	return o
end

function Brick:load(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.isAlive = true
end

function Brick:draw()
	if (self.isAlive) then
		love.graphics.setColor({0,0,1})
		love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
	end
end
