require "Trigger"

FinishTrigger = inheritsFrom(Trigger)

---------------------------------
function FinishTrigger:onStateWin()
	FinishTrigger:superClass().onStateWin(self);
	if self.mContainedObj then
		self.mContainedObj:enterTrap(Vector.new(self.mNode:getPosition()), PlayerObject.PLAYER_STATE.PS_WIN_STATE);
	end
end


