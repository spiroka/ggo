require 'Renderer'
require 'Level'

local level
local renderer

function love.load()
	local levelData = require 'assets.maps.level1'
	level = Level:new(levelData)
	level:load()
	renderer = Renderer:new(level)
	love.window.setMode(1600, 800)
end

function love.draw()
	renderer:render()
end

function love.update(dt)
	level:update(dt)
end