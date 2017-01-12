require 'Camera'
require 'Level'

local class = require 'middleclass'
local lg = require 'love.graphics'

Renderer = class('Renderer');

function Renderer:initialize(level)
	self.level = level
	self.camera = Camera:new()
end

function Renderer:render()
	self.camera:set()

	self.level:render()

	self.camera:unset()
end

function Renderer:update(dt)
	if love.keyboard.isDown('d') then
		self.camera:setX(self.camera.x + dt * 200)
	elseif love.keyboard.isDown('a') then
		self.camera:setX(self.camera.x - dt * 200)
	end
end

function Renderer:resize(w, h)
	xMax = self.level:getWidth() - lg.getWidth()
	yMax = self.level:getHeight() - lg.getHeight()
	self.camera:setBounds(0, 0, xMax, yMax)
end