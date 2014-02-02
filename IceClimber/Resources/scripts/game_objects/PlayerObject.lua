require "MovableObject"

PlayerOject = inheritsFrom(MovableObject)
PlayerOject.mJoystick = nil;
PlayerOject.mFightButton = nil;
PlayerOject.mVelocity = 40;
PlayerOject.mReverse = Vector.new(1, 1);
PlayerOject.mAnimations = nil;
PlayerOject.mFightAnimations = nil;
PlayerOject.mLastButtonPressed = nil;
PlayerOject.mTexture = nil;
PlayerOject.mTextureSize = nil;
PlayerOject.mNameTexture = "penguin";
PlayerOject.mIsFemale = false;

PlayerOject.MALE_PREFIX = "penguin";
PlayerOject.FEMALE_PREFIX = "penguin_girl";
PlayerOject.OBJECT_IN_TRAP = 5;

DIRECTIONS = {
		Vector.new(-1, 0),
		Vector.new(1, 0),
		Vector.new(0, 1),
		Vector.new(0, -1)
	}
PlayerOject.mLastDir = 3;

ANIMATION_MALE = {
		{name = "_left", frames = 2, anchorFight = CCPointMake(0.75, 0.5), anchorFightFemale = CCPointMake(0.25, 0.5)},
		{name = "_right", frames = 2, anchorFight = CCPointMake(0.25, 0.5), anchorFightFemale = CCPointMake(0.75, 0.5)},
		{name = "_up", frames = 2, anchorFight = CCPointMake(0.45, 0.25), anchorFightFemale = CCPointMake(0.45, 0.25)},
		{name = "_down", frames = 2, anchorFight = CCPointMake(0.48, 0.75), anchorFightFemale = CCPointMake(0.48, 0.75)},
		{name = "_trap", frames = 2, anchorFight = CCPointMake(0.45, 0.25), anchorFightFemale = CCPointMake(0.45, 0.25)}
	}

---------------------------------
function PlayerOject:destroy()
	PlayerOject:superClass().destroy(self);

	for i, animation in ipairs(self.mAnimations) do
		if animation then
			animation:release();
		end
	end

	for i, animation in ipairs(self.mFightAnimations) do
		if animation then
			animation:release();
		end
	end
end

---------------------------------
function PlayerOject:enterTrap(pos)
	print("PlayerOject:enterTrap");
	self:playAnimation(nil);
	if pos then
		local posTo = Vector.new(self.mField:positionToGrid(pos));
		self:moveTo(posTo);
	else
		self:playAnimation(PlayerOject.OBJECT_IN_TRAP);
	end
end

--------------------------------
function PlayerOject:onMoveFinished( )
	PlayerOject:superClass().onMoveFinished(self);
	self:playAnimation(PlayerOject.OBJECT_IN_TRAP);
	self.mDelta = nil;
end

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
	self.mFightAnimations = {}
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
			self.mAnimations[i] = self:createAnimation(info.name, info.frames);
			self.mAnimations[i]:retain();
			-- create fight animation
			-- #FIXME:
			if i ~= 5 then
				self.mFightAnimations[i] = self:createAnimation("_fight" .. info.name, info.frames);
				self.mFightAnimations[i]:retain();
			end
		end
	end
end

--------------------------------
function PlayerOject:playAnimation(button)
	--print("PlayerOject:playAnimation ", button);
	if self.mLastButtonPressed ~= button then
		self.mLastButtonPressed = button;
		self.mNode:stopAllActions();
		self.mNode:setAnchorPoint(CCPointMake(0.5, 0.5));
		if button == nil then
			--self.mNode:setContentSize(self.mTextureSize);
			tolua.cast(self.mNode, "CCSprite"):setTexture(self.mTexture);
			tolua.cast(self.mNode, "CCSprite"):setTextureRect(CCRectMake(0, 0, self.mTextureSize.width, self.mTextureSize.height));
		elseif self.mAnimations[self.mLastButtonPressed] then
			self.mNode:runAction(self.mAnimations[self.mLastButtonPressed]);
		end
	end
end

--------------------------------
function PlayerOject:playFightAnimation(button)
	--print("PlayerOject:playAnimation ", button);
	if self.mLastButtonPressed ~= button then
		self.mLastButtonPressed = button;
		self.mNode:stopAllActions();
		self.mNode:setAnchorPoint(CCPointMake(0.45, 0.25));
		if button == nil then
			--self.mNode:setContentSize(self.mTextureSize);
			tolua.cast(self.mNode, "CCSprite"):setTexture(self.mTexture);
			tolua.cast(self.mNode, "CCSprite"):setTextureRect(CCRectMake(0, 0, self.mTextureSize.width, self.mTextureSize.height));
		elseif self.mFightAnimations[self.mLastButtonPressed] then
			if self.mIsFemale then
				self.mNode:setAnchorPoint(ANIMATION_MALE[self.mLastButtonPressed].anchorFightFemale);
			else
				self.mNode:setAnchorPoint(ANIMATION_MALE[self.mLastButtonPressed].anchorFight);
			end
			self.mNode:runAction(self.mFightAnimations[self.mLastButtonPressed]);
		end
	end
end

--------------------------------
function PlayerOject:init(field, node, needReverse)
	PlayerOject:superClass().init(self, field, node);

	if needReverse then 
		self.mReverse = Vector.new(-1, 1);
		self.mNameTexture = PlayerOject.FEMALE_PREFIX;
		self.mIsFemale = true;
	end
	self.mTexture = tolua.cast(self.mNode, "CCSprite"):getTexture();
	self.mTextureSize = self.mNode:getContentSize();
	self:initAnimation();
end

--------------------------------
function PlayerOject:setFightButton(fightButton)
	self.mFightButton = fightButton;
end

--------------------------------
function PlayerOject:setJoystick(joystick)
	self.mJoystick = joystick;
end

--------------------------------
function PlayerOject:collisionDetect(delta, newDir)
	local currentPos = Vector.new(self.mNode:getPosition());
	--print("currentPos ", currentPos.x, " ", currentPos.y);
	local destPos = currentPos + delta * self.mField:getCellSize() / 2;
	--print("destPos ", destPos.x, " ", destPos.y);

	local destGrid = Vector.new(self.mField:positionToGrid(destPos));
	--print("destGrid ", destGrid.x, " ", destGrid.y);

	if self.mField:isFreePoint(destGrid) then
		local centerCell = self.mField:gridPosToReal(destGrid) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		local centerSelf = self.mField:gridPosToReal(Vector.new(self.mField:positionToGrid(currentPos))) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		--print("centerCell ", centerCell.x, " ", centerCell.y);
		--print("centerSelf ", centerSelf.x, " ", centerSelf.y);
		local dir = centerCell - currentPos;
		if (centerCell - centerSelf):len() <= 1 then
			return true;
		end
		dir:normalize();
		newDir.x = dir.x;
		newDir.y = dir.y;
		--print("newDir ", newDir.x, " ", newDir.y);
		return true;
	end
	return false;
end

--------------------------------
function PlayerOject:fight()
	if not self.mFightButton then
		return false;
	end
	if self.mFightButton:isPressed() then
		self:playFightAnimation(self.mLastDir);
		return true;
	end
	
	return false;
end

--------------------------------
function PlayerOject:move(dt)
	if not self.mJoystick then
		return;
	end
	
	local button = self.mJoystick:getButtonPressed();
	self:playAnimation(button);
	--print("button pressed ", );
	if button then
		self.mLastDir = button;
		local newGridPos = self.mGridPosition + DIRECTIONS[button];
		
		local curPosition = Vector.new(self.mNode:getPosition());
		--curPosition = curPosition + DIRECTIONS[button] * self.mVelocity;
		--local pos = self.mField:gridPosToReal(newGridPos);
		local newDir = DIRECTIONS[button]:clone() * self.mReverse;
		self.mLastButton = button;
		if self:collisionDetect(DIRECTIONS[button] * self.mReverse, newDir) then --self.mField:isFreePoint(newGridPos) then
			curPosition = curPosition + newDir * self.mVelocity * dt;

			self.mNode:setPosition(CCPointMake(curPosition.x, curPosition.y));
			self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
		end
	end
end

--------------------------------
function PlayerOject:tick(dt)
	PlayerOject:superClass().tick(self, dt);
	if PlayerOject.OBJECT_IN_TRAP == self.mLastButtonPressed or self.mDelta then
		-- do nothing object is in trap
	elseif not self:fight() then 
		self:move(dt);
	end
end
