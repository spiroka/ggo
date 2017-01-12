require 'Tile'
require 'Builder'
require 'UI'
require 'TiledMapLoader'

local class = require 'middleclass'
local lg = love.graphics

Level = class('Level')

Level.TILE_WIDTH = 160
Level.TILE_HEIGHT = 160

function Level:initialize(map)
	self.mapLoader = TiledMapLoader:new(map)

	love.physics.setMeter(self.mapLoader:getTileWidth())
	self.world = love.physics.newWorld(0, 15*self.mapLoader:getTileWidth(), true)
	self:loadBodies()

	self.spriteSheet = lg.newImage(self.mapLoader:getSpriteSheetImage())
	self.spriteSheet:setFilter('nearest', 'nearest')

	self.builders = {}
	table.insert(self.builders, Builder:new(640, 480))
	table.insert(self.builders, Builder:new(340, 480))
	self.ui = UI:new(self.builders)
end

function Level:loadBodies()
	for i, tile in ipairs(self.mapLoader:getTiles()) do
		if tile.solid  then
			object = {}
			object.body = love.physics.newBody(self.world, x + ((self.mapLoader:getTileWidth() * 10) / 2), y + ((self.mapLoader:getTilewHeight() * 10) / 2))
			object.shape = love.physics.newRectangleShape(self.mapLoader:getTileWidth() * 10, self.mapLoader:getTileHeight() * 10)
			object.fixture = love.physics.newFixture(object.body, object.shape)
		end
	end
end

function Level:render()
	lg.setColor(255, 255, 255)
	for i, tile in ipairs(self.mapLoader:getTiles()) do
		lg.draw(self.spriteSheet, self.mapLoader:getTileset()[tile.spriteId], tile.x, tile.y, 0, 10, 10)
	end

	for i, builder in ipairs(self.builders) do
		lg.setColor(0, 0, 0)
		lg.rectangle('fill', builder.x, builder.y, Builder.WIDTH, Builder.HEIGHT)
	end

	self.ui:render()
end

function Level:update(dt)
	self.world:update(dt)

	for i, builder in ipairs(self.builders) do
		builder:update(dt)
	end
	self.ui:update(dt)
end

function Level:getWidth()
	return self.mapLoader:getWidth() * Level.TILE_WIDTH
end

function Level:getHeight()
	return self.mapLoader:getHeight() * Level.TILE_HEIGHT
end