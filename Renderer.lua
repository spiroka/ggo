local class = require 'middleclass'

Renderer = class('Renderer');

function Renderer:initialize(level)
	self.level = level
end

function Renderer:render()
	self.level:render()
end