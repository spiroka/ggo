require 'Renderer'
require 'Level'
require 'InputHandler'

local level
local renderer
local input

function love.load()
	local map = 'assets.maps.level1'
	level = Level:new(map)

	love.window.setFullscreen(true)
	renderer = Renderer:new(level)

	input = InputHandler:new(level)
end

function love.draw()
	renderer:render()
end

function love.update(dt)
	level:update(dt)
	renderer:update(dt)
end

function love.mousepressed(x, y, button)
	input:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	input:mouseReleased(x, y, button)
end

function love.keypressed(key)
   input:keypressed(key)
end

function love.resize(w, h)
	if renderer ~= nil then
		renderer:resize(w, h)
	end
end