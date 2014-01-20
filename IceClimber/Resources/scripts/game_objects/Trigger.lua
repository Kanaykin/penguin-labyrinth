require "BaseObject"
require "Callback"

Trigger = inheritsFrom(BaseObject)
Trigger.mEnterCallback = nil;
Trigger.mLeaveCallback = nil;
Trigger.mContainedObj = nil;

--------------------------------
function Trigger:init(field, node, enterCallback, leaveCallback)
	Trigger:superClass().init(self, field, node);

	self.mEnterCallback = enterCallback;
	self.mLeaveCallback = leaveCallback;
end

---------------------------------
function Trigger:onEnter(player)
	if self.mEnterCallback then
		self.mEnterCallback(player, Vector.new(self.mNode:getPosition()));
		self.mContainedObj = player;
	end
end

---------------------------------
function Trigger:destroy()
	Trigger:superClass().destroy(self);

	if self.mLeaveCallback then
		self.mLeaveCallback(player);
		self.mContainedObj = nil;
	end
end

--------------------------------
function Trigger:tick(dt)
	Trigger:superClass().tick(self, dt);

	-- check bbox contain player or not
	if self.mNode then 
		if self.mContainedObj then
			local pointX, pointY = self.mContainedObj.mNode:getPosition();
			local contained = self.mNode:boundingBox():containsPoint(CCPointMake(pointX, pointY));
			if not contained and self.mLeaveCallback then
				self.mLeaveCallback(player);
				self.mContainedObj = nil;
			end
		else
			local players = self.mField:getPlayerObjects();
			for i, player in ipairs(players) do
				local pointX, pointY = player.mNode:getPosition();
				local contained = self.mNode:boundingBox():containsPoint(CCPointMake(pointX, pointY));
				if contained and self.mEnterCallback then
					self:onEnter(player)
				end
			end
		end
	end
end