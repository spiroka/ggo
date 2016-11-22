local class = require 'middleclass'

Tile = class('Tile')

function Tile:initialize(x, y)
	self.x = x
	self.y = y
end