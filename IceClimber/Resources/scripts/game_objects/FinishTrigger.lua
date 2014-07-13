require "Trigger"

FinishTrigger = inheritsFrom(Trigger)

---------------------------------
function FinishTrigger:onStateWin()
	FinishTrigger:superClass().onStateWin(self);
	if self.mContainedObj then
		self.mContainedObj:enterTrap(Vector.new(self.mNode:getPosition()), 1);
	end
end


