local class = require 'middleclass'

Tile = class('Tile')

function Tile:initialize(x, y, spriteId)
	self.x = x
	self.y = y
	self.spriteId = spriteId
	self.solid = false
end