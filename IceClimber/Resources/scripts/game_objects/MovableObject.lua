require "BaseObject"

MovableObject = inheritsFrom(BaseObject)
MovableObject.mVelocity = 15;
MovableObject.mGridPosition = nil;
MovableObject.mMoveTime = nil;
MovableObject.mDelta = nil;
MovableObject.mDestGridPos = nil;
MovableObject.mSrcPos = nil;
MovableObject.mPrevOrderPos = nil;

--------------------------------
function MovableObject:init(field, node)
	MovableObject:superClass().init(self, field, node);

	self.mGridPosition = Vector.new(field:getGridPosition(node));
	print("mGridPosition ", self.mGridPosition.x, ", ", self.mGridPosition.y);
end

--------------------------------
function MovableObject:stopMoving()
	if self.mDelta then
		self.mDelta = nil;
		self:onMoveFinished();
	end
end

--------------------------------
function MovableObject:moveTo(posDest)
	-- compute real position
	print("[MovableObject:moveTo] posDest.x ", posDest.x, "posDest.y ", posDest.y);
	local dest = self.mField:gridPosToReal(posDest);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;
	local src = Vector.new(self.mNode:getPosition()); --self.mField:gridPosToReal(self.mGridPosition);
	print("[MovableObject:moveTo] src.x ", src.x, " src.y ", src.y);
	print("[MovableObject:moveTo] dest.x ", dest.x, " dest.y ", dest.y);
	local delta = dest - src;
	self.mMoveTime = delta:len() / self.mVelocity;
	self.mDelta = delta;
	print("[MovableObject:moveTo] delta.x ", delta.x, " delta.y ", delta.y);
	print("[MovableObject:moveTo] moveTime ", self.mMoveTime);
	local x, y = self.mNode:getPosition();
	self.mSrcPos = Vector.new(x, y);
	self.mDestGridPos = posDest;
end

--------------------------------
function MovableObject:updateOrder()
	local newOrderPos = -self.mGridPosition.y * 2;
	if self.mPrevOrderPos ~= newOrderPos then
		self.mPrevOrderPos = newOrderPos;
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, false);
		parent:addChild(self.mNode, self.mPrevOrderPos);
	end
end

--------------------------------
function MovableObject:onMoveFinished( )
	-- body
end

--------------------------------
function MovableObject:IsMoving()
	return self.mDelta ~= nil;
end

--------------------------------
function MovableObject:tick(dt)
	MovableObject:superClass().tick(self, dt);
	if self.mDelta then
		local val = self.mDelta:normalized() * self.mVelocity * self.mMoveTime;
		print("[MovableObject:moveTo] tick val ", val);
		local cur = self.mSrcPos + self.mDelta - val;
		print("[MovableObject:moveTo] tick cur.x ", cur.x, " y ", cur.y);
		self.mNode:setPosition(CCPointMake(cur.x, cur.y));
		self.mMoveTime = self.mMoveTime - dt;
		print("[MovableObject:moveTo] tick mMoveTime ", self.mMoveTime);
		self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
		self:updateOrder();
		if self.mMoveTime <= 0 then
			local dest = self.mField:gridPosToReal(self.mDestGridPos);
			dest.x= dest.x + self.mField.mCellSize / 2;
			dest.y= dest.y + self.mField.mCellSize / 2;
			self.mNode:setPosition(CCPointMake(dest.x, dest.y));

			self.mGridPosition = self.mDestGridPos;--Vector.new(self.mField:getGridPosition(self.mNode));
			print("[MovableObject:moveTo] grid pos ", self.mGridPosition.x, " y ", self.mGridPosition.y);
			self.mDelta = nil;
			self:onMoveFinished();
			--self:updateOrder();
		end
	end
end
