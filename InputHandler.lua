require 'Builder'

local class = require 'middleclass'
local lp = require 'love.physics'

InputHandler = class('InputHandler')

function InputHandler:initialize(level)
	self.level = level
	self.pressLocation = nil
end

function InputHandler:mousePressed(x, y, button)
	if button == 1 then
		self.pressLocation = {
			x = x,
			y = y
		}
	end
end

function InputHandler:mouseReleased(x, y, button)
	if button == 1 then
		for i, builder in ipairs(self.level.builders) do
			local boundingBox = lp.newRectangleShape(Builder.WIDTH, Builder.HEIGHT)
			if boundingBox:testPoint(builder.x + (Builder.WIDTH / 2), builder.y + (Builder.HEIGHT / 2), 0, self.pressLocation.x, self.pressLocation.y) and
				boundingBox:testPoint(builder.x + (Builder.WIDTH / 2), builder.y + (Builder.HEIGHT / 2), 0, x, y) then
				builder:onClick()
			end
		end
	end
end

function InputHandler:keypressed(key)
	if key == "right" then
		self.level.builders[1].uiOpen = not self.level.builders[1].uiOpen
	elseif key == "left" then
		self.level.builders[2].uiOpen = not self.level.builders[2].uiOpen
	end
end