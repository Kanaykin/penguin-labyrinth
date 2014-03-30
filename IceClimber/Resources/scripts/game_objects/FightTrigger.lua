require "Trigger"

FightTrigger = inheritsFrom(Trigger)
FightTrigger.mActivated = false;

--------------------------------
function FightTrigger:init(field)
	local node = CCNode:create();
	node:setContentSize(CCSizeMake(field:getCellSize(), field:getCellSize()));
	field:getFieldNode():addChild(node);

	-- #FIXME: anchor point for fox scene
	node:setAnchorPoint(CCPointMake(0.5, 0.5));

	print("FightTrigger node ", node);
	FightTrigger:superClass().init(self, field, node, Callback.new(field, Field.onEnemyEnterTrigger), Callback.new(field, Field.onEnemyLeaveTrigger));
end

--------------------------------
function FightTrigger:getCollisionObjects()
	print("FightTrigger:getCollisionObjects ", #self.mField:getEnemyObjects());
	return self.mField:getEnemyObjects();
end

--------------------------------
function FightTrigger:setActivated(activated)
	self.mActivated = activated;
end

--------------------------------
function FightTrigger:tick(dt)
	if self.mActivated then
		--print("FightTrigger:tick");
		FightTrigger:superClass().tick(self, dt);
	end
end