local class = require 'middleclass'
local lg = require 'love.graphics'

TiledMapLoader = class('TiledMapLoader')

function TiledMapLoader:initialize(pathToMap)
	self.mapData = require(pathToMap)
	self.tileset = {}
	self.tiles = {}

	self:loadTiles()
end

function TiledMapLoader:loadTiles()
	local tilesetData = self.mapData.tilesets[1]

	for i = 1, tilesetData.tilecount do
		x = tilesetData.tilewidth * (i - 1) % tilesetData.imagewidth
		y = math.floor((tilesetData.tilewidth * (i - 1)) / tilesetData.imagewidth) * tilesetData.tileheight
		self.tileset[i] = lg.newQuad(x, y, tilesetData.tilewidth, tilesetData.tileheight, tilesetData.imagewidth, tilesetData.imageheight)
	end

	for i, layer in ipairs(self.mapData.layers) do
		for j, v in ipairs(layer.data) do
			if v > 0 then
				x = self.mapData.tilewidth * (j - 1) % (self.mapData.width * self.mapData.tilewidth)
				y = math.floor((self.mapData.tilewidth * (j - 1)) / (self.mapData.width * self.mapData.tilewidth)) * self.mapData.tileheight
				x = x * 10
				y = y * 10
				local tile = Tile:new(x, y, v)
				tile.solid = layer.properties.solid
				table.insert(self.tiles, Tile:new(x, y, v))
			end
		end
	end
end

function TiledMapLoader:getTileset()
	return self.tileset
end

function TiledMapLoader:getTiles()
	return self.tiles
end

function TiledMapLoader:getWidth()
	return self.mapData.width
end

function TiledMapLoader:getHeight()
	return self.mapData.height
end

function TiledMapLoader:getTileWidth()
	return self.mapData.tilewidth
end

function TiledMapLoader:getTileHeight()
	return self.mapData.tileheight
end

function TiledMapLoader:getSpriteSheetImage()
	return self.mapData.tilesets[1].image
end