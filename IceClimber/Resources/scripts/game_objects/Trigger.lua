require "BaseObject"
require "Callback"

Trigger = inheritsFrom(BaseObject)
Trigger.mEnterCallback = nil;
Trigger.mLeaveCallback = nil;
Trigger.mContainedObj = nil;

--------------------------------
function Trigger:getContainedObj()
	return self.mContainedObj;
end

--------------------------------
function Trigger:init(field, node, enterCallback, leaveCallback)
	Trigger:superClass().init(self, field, node);

	self.mEnterCallback = enterCallback;
	self.mLeaveCallback = leaveCallback;
end

---------------------------------
function Trigger:onEnter(player)
	print("Trigger:onEnter");
	if self.mEnterCallback then
		self.mEnterCallback(player, Vector.new(self.mNode:getPosition()));
	end
	self.mContainedObj = player;
end

---------------------------------
function Trigger:destroy()
	Trigger:superClass().destroy(self);

	if self.mLeaveCallback and self.mContainedObj then
		self.mLeaveCallback(self.mContainedObj);
	end
	self.mContainedObj = nil;
end

--------------------------------
function Trigger:getCollisionObjects()
	return self.mField:getPlayerObjects();
end

--------------------------------
function Trigger:tick(dt)
	Trigger:superClass().tick(self, dt);

	-- check bbox contain player or not
	if self.mNode then 
		if self.mContainedObj then
			local contained = false;
			if self.mContainedObj.mNode then
				local pointX, pointY = self.mContainedObj.mNode:getPosition();
				contained = self.mNode:boundingBox():containsPoint(CCPointMake(pointX, pointY));
			end
			if not contained then
				if self.mLeaveCallback then
					self.mLeaveCallback(self.mContainedObj);
				end
				self.mContainedObj = nil;
			end
		else
			local players = self:getCollisionObjects()
			for i, player in ipairs(players) do
				local pointX, pointY = player.mNode:getPosition();
				--print("Trigger:tick obj x ", pointX, " y ", pointY);
				--print("Trigger:tick x ", self.mNode:boundingBox().origin.x, " y ", self.mNode:boundingBox().origin.y );
				local contained = self.mNode:boundingBox():containsPoint(CCPointMake(pointX, pointY));
				--print("contained ", contained);
				if contained then
					self:onEnter(player)
				end
			end
		end
	end
end