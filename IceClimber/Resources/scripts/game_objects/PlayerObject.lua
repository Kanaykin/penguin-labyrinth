require "MovableObject"

PlayerOject = inheritsFrom(MovableObject)
PlayerOject.mJoystick = nil;
PlayerOject.mVelocity = 1;
PlayerOject.mReverse = Vector.new(1, 1);
PlayerOject.mAnimations = nil;
PlayerOject.mLastButtonPressed = nil;
PlayerOject.mTexture = nil;
PlayerOject.mNameTexture = "penguin";

PlayerOject.MALE_PREFIX = "penguin";
PlayerOject.FEMALE_PREFIX = "penguin_girl";

DIRECTIONS = {
		Vector.new(-1, 0),
		Vector.new(1, 0),
		Vector.new(0, 1),
		Vector.new(0, -1)
	}

ANIMATION_MALE = {
		{name = "_left", frames = 2},
		{name = "_right", frames = 2},
		{name = "_up", frames = 2},
		{name = "_down", frames = 2},
		{name = nil, frames = 2}
	}

--------------------------------
function PlayerOject:createAnimation(name, frames)
	local animation = CCAnimation:create();

	for i = 1,frames do
		local fullName = self.mNameTexture..name..tostring(i)..".png";
		print("PlayerOject:createAnimation ", fullName);
		animation:addSpriteFrameWithFileName(fullName);
	end
	animation:setDelayPerUnit(1 / 10);
	animation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(animation);
	local repeatForever = CCRepeatForever:create(action);
	return repeatForever;
end

--------------------------------
function PlayerOject:initAnimation()
	self.mAnimations = {}
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
			self.mAnimations[i] = self:createAnimation(info.name, info.frames);
			self.mAnimations[i]:retain();
		end
	end
end

--------------------------------
function PlayerOject:playAnimation(button)
	--print("PlayerOject:playAnimation ", button);
	if self.mLastButtonPressed ~= button then
		self.mLastButtonPressed = button;
		self.mNode:stopAllActions();
		if button == nil then
			tolua.cast(self.mNode, "CCSprite"):setTexture(self.mTexture);
		elseif self.mAnimations[self.mLastButtonPressed] then
			self.mNode:runAction(self.mAnimations[self.mLastButtonPressed]);
		end
	end
end

--------------------------------
function PlayerOject:init(field, node, needReverse)
	PlayerOject:superClass().init(self, field, node);

	if needReverse then 
		self.mReverse = Vector.new(-1, 1);
		self.mNameTexture = PlayerOject.FEMALE_PREFIX;
	end
	self.mTexture = tolua.cast(self.mNode, "CCSprite"):getTexture();
	self:initAnimation();
end

--------------------------------
function PlayerOject:setJoystick(joystick)
	self.mJoystick = joystick;
end

--------------------------------
function PlayerOject:collisionDetect(delta, newDir)
	local currentPos = Vector.new(self.mNode:getPosition());
	print("currentPos ", currentPos.x, " ", currentPos.y);
	local destPos = currentPos + delta * self.mField:getCellSize() / 2;
	print("destPos ", destPos.x, " ", destPos.y);

	local destGrid = Vector.new(self.mField:positionToGrid(destPos));
	print("destGrid ", destGrid.x, " ", destGrid.y);

	if self.mField:isFreePoint(destGrid) then
		local centerCell = self.mField:gridPosToReal(destGrid) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		local centerSelf = self.mField:gridPosToReal(Vector.new(self.mField:positionToGrid(currentPos))) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		print("centerCell ", centerCell.x, " ", centerCell.y);
		print("centerSelf ", centerSelf.x, " ", centerSelf.y);
		local dir = centerCell - currentPos;
		if (centerCell - centerSelf):len() <= 1 then
			return true;
		end
		dir:normalize();
		newDir.x = dir.x;
		newDir.y = dir.y;
		print("newDir ", newDir.x, " ", newDir.y);
		return true;
	end
	return false;
end

--------------------------------
function PlayerOject:tick(dt)
	PlayerOject:superClass().tick(self, dt);
	if self.mJoystick then 
		local button = self.mJoystick:getButtonPressed();
		self:playAnimation(button);
		--print("button pressed ", );
		if button then
			local newGridPos = self.mGridPosition + DIRECTIONS[button];
			
			local curPosition = Vector.new(self.mNode:getPosition());
			--curPosition = curPosition + DIRECTIONS[button] * self.mVelocity;
			--local pos = self.mField:gridPosToReal(newGridPos);
			local newDir = DIRECTIONS[button]:clone() * self.mReverse;
			if self:collisionDetect(DIRECTIONS[button] * self.mReverse, newDir) then --self.mField:isFreePoint(newGridPos) then
				curPosition = curPosition + newDir * self.mVelocity;

				self.mNode:setPosition(CCPointMake(curPosition.x, curPosition.y));
				self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
			end
		end
	end
end
