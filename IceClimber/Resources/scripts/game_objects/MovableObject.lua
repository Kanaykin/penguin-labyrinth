require "BaseObject"

MovableObject = inheritsFrom(BaseObject)
MovableObject.mVelocity = 30;
MovableObject.mGridPosition = nil;
MovableObject.mMoveTime = nil;
MovableObject.mDelta = nil;
MovableObject.mSrcPos = nil;

--------------------------------
function MovableObject:init(field, node)
	MovableObject:superClass().init(self, field, node);

	self.mGridPosition = Vector.new(field:getGridPosition(node));
	print("mGridPosition ", self.mGridPosition.x, ", ", self.mGridPosition.y);
end

--------------------------------
function MovableObject:moveTo(posDest)
	-- compute real position
	print("posDest.x ", posDest.x, "posDest.y ", posDest.y);
	local dest = self.mField:gridPosToReal(posDest);
	local src = self.mField:gridPosToReal(self.mGridPosition);
	local delta = dest - src;
	self.mMoveTime = delta:len() / self.mVelocity;
	self.mDelta = delta;
	print("delta.x ", delta.x, " delta.y ", delta.y);
	print("moveTime ", self.mMoveTime);
	local x, y = self.mNode:getPosition();
	self.mSrcPos = Vector.new(x, y);
end

--------------------------------
function MovableObject:onMoveFinished( )
	-- body
end

--------------------------------
function MovableObject:tick(dt)
	MovableObject:superClass().tick(self, dt);
	if self.mDelta then
		local val = self.mDelta:normalized() * self.mVelocity * self.mMoveTime;
		local cur = self.mSrcPos + self.mDelta - val;
		self.mNode:setPosition(CCPointMake(cur.x, cur.y));
		self.mMoveTime = self.mMoveTime - dt;
		--print(" ", self.mMoveTime);
		if self.mMoveTime <= 0 then
			local cur = self.mSrcPos + self.mDelta;
			self.mNode:setPosition(CCPointMake(cur.x, cur.y));
			self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
			self.mDelta = nil;
			self:onMoveFinished();
		end
	end
end
