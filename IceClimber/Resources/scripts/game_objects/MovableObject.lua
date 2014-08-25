require "BaseObject"

MovableObject = inheritsFrom(BaseObject)
MovableObject.mVelocity = 30;
MovableObject.mGridPosition = nil;
MovableObject.mMoveTime = nil;
MovableObject.mDelta = nil;
MovableObject.mDestGridPos = nil;
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
--	print("posDest.x ", posDest.x, "posDest.y ", posDest.y);
	local dest = self.mField:gridPosToReal(posDest);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;
	local src = Vector.new(self.mNode:getPosition()); --self.mField:gridPosToReal(self.mGridPosition);
	local delta = dest - src;
	self.mMoveTime = delta:len() / self.mVelocity;
	self.mDelta = delta;
--	print("delta.x ", delta.x, " delta.y ", delta.y);
--	print("moveTime ", self.mMoveTime);
	local x, y = self.mNode:getPosition();
	self.mSrcPos = Vector.new(x, y);
	self.mDestGridPos = posDest;
end

--------------------------------
function MovableObject:updateOrder()
	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	parent:addChild(self.mNode, -self.mGridPosition.y * 2);
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
		--print("tick val ", val);
		local cur = self.mSrcPos + self.mDelta - val;
		--print("tick cur.x ", cur.x, " y ", cur.y);
		self.mNode:setPosition(CCPointMake(cur.x, cur.y));
		self.mMoveTime = self.mMoveTime - dt;
		--print("tick mMoveTime ", self.mMoveTime);
		--print(" ", self.mMoveTime);
		if self.mMoveTime <= 0 then
			local dest = self.mField:gridPosToReal(self.mDestGridPos);
			dest.x= dest.x + self.mField.mCellSize / 2;
			dest.y= dest.y + self.mField.mCellSize / 2;
			self.mNode:setPosition(CCPointMake(dest.x, dest.y));

			self.mGridPosition = self.mDestGridPos;--Vector.new(self.mField:getGridPosition(self.mNode));
--			print("grid pos ", self.mGridPosition.x, " y ", self.mGridPosition.y);
			self.mDelta = nil;
			self:onMoveFinished();
			self:updateOrder();
		end
	end
end
