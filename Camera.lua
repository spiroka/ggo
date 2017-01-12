require 'util'

local class = require 'middleclass'
local lg = require 'love.graphics'

Camera = class('Camera')

function Camera:initialize()
	self.x = 0
	self.y = 0
	self.bounds = nil
end

function Camera:set()
	lg.push()
	lg.rotate(0)
  	lg.scale(1, 1)
  	lg.translate(-self.x, -self.y)
end

function Camera:unset()
	lg.pop()
end

function Camera:setBounds(x1, y1, x2, y2)
	self.bounds = {
		x1 = x1,
		y1 = y1,
		x2 = x2,
		y2 = y2
	}
end

function Camera:setX(x)
	self.x = util.clamp(x, self.bounds.x1, self.bounds.x2)
end

function Camera:setY(y)
	self.y = util.clamp(y, self.bounds.y1, self.bounds.y2)
end

function Camera:setPosition(x, y)
	self:setX(x)
	self:setY(y)
end