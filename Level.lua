require 'Tile'
require 'Builder'

local class = require 'middleclass'
local lg = love.graphics

Level = class('Level')

function Level:initialize(levelData)
	self.data = levelData
	self.layers = {}
	local spriteSheet = lg.newImage(self.data.tilesets[1].image)
	spriteSheet:setFilter('nearest', 'nearest')
	self.tileset = {
		image = spriteSheet,
		tiles = {}
	}
	self.world = {}
end

function Level:load()
	love.physics.setMeter(self.data.tilewidth)
	self.world = love.physics.newWorld(0, 15*self.data.tilewidth, true)
	self:loadTiles()

	self.builder = Builder:new(800, 480)
end

function Level:loadTiles()
	local tilesetData = self.data.tilesets[1]
	for i = 1, tilesetData.tilecount do
		x = tilesetData.tilewidth * (i - 1) % tilesetData.imagewidth
		y = math.floor((tilesetData.tilewidth * (i - 1)) / tilesetData.imagewidth) * tilesetData.tileheight
		self.tileset.tiles[i] = lg.newQuad(x, y, tilesetData.tilewidth, tilesetData.tileheight, tilesetData.imagewidth, tilesetData.imageheight)
	end

	for i, layer in ipairs(self.data.layers) do
		self.layers[i] = {}
		for j, v in ipairs(layer.data) do
			if v > 0 then
				x = self.data.tilewidth * (j - 1) % (self.data.width * self.data.tilewidth)
				y = math.floor((self.data.tilewidth * (j - 1)) / (self.data.width * self.data.tilewidth)) * self.data.tileheight
				x = x * 10
				y = y * 10
				tile = {}
				tile['tile'] = Tile:new(x, y)
				tile['tileImage'] = v
				table.insert(self.layers[i], tile)
				if layer.properties.solid then
					object = {}
					object.body = love.physics.newBody(self.world, x + ((self.data.tilewidth * 10) / 2), y + ((self.data.tileheight * 10) / 2))
					object.shape = love.physics.newRectangleShape(self.data.tilewidth * 10, self.data.tileheight * 10)
					object.fixture = love.physics.newFixture(object.body, object.shape)
				end
			end
		end
	end
end

function Level:render()
	for i, layer in ipairs(self.layers) do
		for j, tileData in ipairs(layer) do
			lg.draw(self.tileset.image, self.tileset.tiles[tileData.tileImage], tileData.tile.x, tileData.tile.y, 0, 10, 10)
		end
	end

	lg.rectangle('fill', self.builder.x, self.builder.y, 160, 160)
end

function Level:update(dt)
	self.world:update(dt)
	self.builder:update(dt)
end