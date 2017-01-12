local class = require 'middleclass'
local keyboard = require 'love.keyboard'

Builder = class('Builder')

Builder.Action = {
	RIGHT = 'right',
	LEFT = 'left',
	WAIT = 'wait'
}

Builder.State = {
	IDLE = 'idle',
	MOVING = 'moving'
}

Builder.WIDTH = 160
Builder.HEIGHT = 160

Builder.ACTION_LENGTH = 1
Builder.ACTION_DELAY = 0.1

Builder.NUM_ACTIONS = 3

function Builder:initialize(x, y)
	self.x = x
	self.y = y
	self.targetLocation = {}
	self.targetLocation.x = x
	self.targetLocation.y = y
	self.stateTimeRemaining = nil
	self.delayRemaining = nil
	self.currentAction = 0
	self.state = Builder.State.IDLE
	self.uiOpen = false

	self.actions = {Builder.Action.RIGHT, Builder.Action.RIGHT, Builder.Action.LEFT}
end

function Builder:executeNextAction()
	self.uiOpen = false

	if self.currentAction ~= Builder.NUM_ACTIONS then
		if self.currentAction > 0.0 then
			self:finishCurrentAction()
		end
		self.currentAction = self.currentAction + 1
		self.stateTimeRemaining = Builder.ACTION_LENGTH
		self.delayRemaining = Builder.ACTION_DELAY
	else
		self:finishCurrentAction()
		self.currentAction = 0
		self.stateTimeRemaining = nil
		self.delayRemaining = nil
		self.state = Builder.State.IDLE
		return
	end

	if self.actions[self.currentAction] == Builder.Action.RIGHT or self.actions[self.currentAction] == Builder.Action.LEFT then
		self.state = Builder.State.MOVING
		if self.actions[self.currentAction] == Builder.Action.RIGHT then
			self.targetLocation.x = self.x + Level.TILE_WIDTH
		else
			self.targetLocation.x = self.x - Level.TILE_WIDTH
		end
	end
end

function Builder:finishCurrentAction()
	if self.actions[self.currentAction] == Builder.Action.RIGHT or self.actions[self.currentAction] == Builder.Action.LEFT then
		self.x = self.targetLocation.x
		self.y = self.targetLocation.y
	end
end

function Builder:onClick()
	if self.state == Builder.State.IDLE then
		self.uiOpen = not self.uiOpen
	end
end

function Builder:update(dt)
	if keyboard.isDown('s') and self.state == Builder.State.IDLE then
		self:executeNextAction()
	end

	if keyboard.isDown('r') then
		self:initialize(640, 480)
	end

	if self.state ~= Builder.State.IDLE and self.delayRemaining <= 0.0 then
		self.stateTimeRemaining = self.stateTimeRemaining - dt
	end

	if self.state ~= Builder.State.IDLE and self.delayRemaining > 0.0 then
		self.delayRemaining = self.delayRemaining - dt
		return
	else
		if self.actions[self.currentAction] == Builder.Action.RIGHT then
			self.x = self.x + ((Level.TILE_WIDTH / Builder.ACTION_LENGTH) * dt)
		elseif self.actions[self.currentAction] == Builder.Action.LEFT then
			self.x = self.x - ((Level.TILE_WIDTH / Builder.ACTION_LENGTH) * dt)
		end
	end

	if self.state ~= Builder.State.IDLE and self.stateTimeRemaining <= 0 then
		self:executeNextAction()
	end
end