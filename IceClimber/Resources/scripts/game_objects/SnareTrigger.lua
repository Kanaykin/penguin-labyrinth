require "Trigger"

SnareTrigger = inheritsFrom(Trigger)

--------------------------------
function SnareTrigger:init(field, node, enterCallback, leaveCallback)
	SnareTrigger:superClass().init(self, field, node, enterCallback, leaveCallback);

	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	local posGridX, posGridY = field:getGridPosition(self.mNode);
	print("SnareTrigger:init ", posGridY);
	parent:addChild(self.mNode, -posGridY * 2 + 1);
end

---------------------------------
function SnareTrigger:onEnter(player)
	SnareTrigger:superClass().onEnter(self, player);
	if self.mNode then
		--self.mNode:setVisible(false);
	end
end


