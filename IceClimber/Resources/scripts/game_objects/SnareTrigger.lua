require "Trigger"

SnareTrigger = inheritsFrom(Trigger)

---------------------------------
function SnareTrigger:onEnter(player)
	SnareTrigger:superClass().onEnter(self, player);
	if self.mNode then
		--self.mNode:setVisible(false);
	end
end


