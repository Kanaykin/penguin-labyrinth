require "Trigger"

FinishTrigger = inheritsFrom(Trigger)

---------------------------------
function FinishTrigger:onStateWin()
	if self.mContainedObj then
		self.mContainedObj:enterTrap(Vector.new(self.mNode:getPosition()), 1);
	end
end


