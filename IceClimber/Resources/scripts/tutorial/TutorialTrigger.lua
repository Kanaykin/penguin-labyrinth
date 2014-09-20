require "Trigger"

TutorialTrigger = inheritsFrom(Trigger)

---------------------------------
function TutorialTrigger:onEnter(player)
	TutorialTrigger:superClass().onEnter(self, player);
	if self.mContainedObj then
		--self.mContainedObj:enterTrap(Vector.new(self.mNode:getPosition()), PlayerObject.PLAYER_STATE.PS_WIN_STATE);
	end
end
