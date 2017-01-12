require 'Builder'

local class = require 'middleclass'
local lg = require 'love.graphics'

UI = class('UI')

function UI:initialize(builders)
	self.builders = builders
end

function UI:showBuilderUI(builder)
	for i, action in ipairs(builder.actions) do
		if action == Builder.Action.LEFT then
			lg.setColor(0, 0, 255)
		else
			lg.setColor(255, 0, 0)
		end

		lg.rectangle('fill', builder.x + ((i-1) * 100), builder.y + 20, 80, 80)
	end
end

function UI:update(dt)
	
end

function UI:render()
	for i, builder in ipairs(self.builders) do
		if builder.uiOpen then
			self:showBuilderUI(builder)
		end
	end
end