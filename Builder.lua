local class = require 'middleclass'

Builder = class('Builder')

Builder.Action = {
	RIGHT = 'right',
	LEFT = 'left',
	UP = 'up'
}

Builder.State = {
	IDLE = 'idle',
	MOVING = 'moving'
}

function Builder:initialize(x, y)
	self.x = x
	self.y = y
	self.stateTimeRemaining = nil
	self.currentAction = 0
	self.state = Builder.State.IDLE

	self.actions = {Builder.Action.RIGHT, Builder.Action.RIGHT, Builder.Action.LEFT}
	self:executeNextAction()
end

function Builder:executeNextAction()
	if self.currentAction ~= #self.actions then
		self.currentAction = self.currentAction + 1
	else
		self.currentAction = 0
		self.stateTimeRemaining = nil
		self.state = Builder.State.IDLE
		return
	end

	if self.actions[self.currentAction] == Builder.Action.RIGHT or self.actions[self.currentAction] == Builder.Action.LEFT then
		self.state = Builder.State.MOVING
		self.stateTimeRemaining = 5
	end
end

function Builder:update(dt)
	if self.stateTimeRemaining ~= nil then
		self.stateTimeRemaining = self.stateTimeRemaining - dt
	end

	if self.actions[self.currentAction] == Builder.Action.RIGHT then
		self.x = self.x + (10 * dt)
	elseif self.actions[self.currentAction] == Builder.Action.LEFT then
		self.x = self.x - (10 * dt)
	end

	if self.stateTimeRemaining ~= nil and self.stateTimeRemaining <= 0 then
		self:executeNextAction()
	end
end