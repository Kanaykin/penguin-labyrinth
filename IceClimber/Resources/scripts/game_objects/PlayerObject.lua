require "MovableObject"
require "FightTrigger"
require "EmptyAnimation"
require "FramesAnimation"

PlayerObject = inheritsFrom(MovableObject)
PlayerObject.mJoystick = nil;
PlayerObject.mFightButton = nil;
PlayerObject.mVelocity = 40;
PlayerObject.mReverse = Vector.new(1, 1);
PlayerObject.mAnimations = nil;
PlayerObject.mFightButtonOffset = 5;
PlayerObject.mLastButtonPressed = nil;
PlayerObject.mNameTexture = "penguin";
PlayerObject.mIsFemale = false;
PlayerObject.mFightTrigger = nil;

PlayerObject.MALE_PREFIX = "penguin";
PlayerObject.FEMALE_PREFIX = "penguin_girl";
PlayerObject.OBJECT_IN_TRAP = 5;

DIRECTIONS = {
		Vector.new(-1, 0),
		Vector.new(1, 0),
		Vector.new(0, 1),
		Vector.new(0, -1)
	}
PlayerObject.mLastDir = 3;

ANIMATION_MALE = {
		{name = "_left", frames = 2, anchorFight = CCPointMake(0.5, 0.5), anchorFightFemale = CCPointMake(0.5, 0.5)},
		{name = "_right", frames = 2, anchorFight = CCPointMake(0.5, 0.5), anchorFightFemale = CCPointMake(0.5, 0.5)},
		{name = "_up", frames = 2, anchorFight = CCPointMake(0.5, 0.5), anchorFightFemale = CCPointMake(0.5, 0.5)},
		{name = "_down", frames = 2, anchorFight = CCPointMake(0.5, 0.5), anchorFightFemale = CCPointMake(0.5, 0.5)},
		{name = "_trap", frames = 2, anchorFight = CCPointMake(0.5, 0.5), anchorFightFemale = CCPointMake(0.5, 0.5)},
		{name = "_fight_left", frames = 2, anchorFight = CCPointMake(0.75, 0.5), anchorFightFemale = CCPointMake(0.25, 0.5)},
		{name = "_fight_right", frames = 2, anchorFight = CCPointMake(0.25, 0.5), anchorFightFemale = CCPointMake(0.75, 0.5)},
		{name = "_fight_up", frames = 2, anchorFight = CCPointMake(0.45, 0.25), anchorFightFemale = CCPointMake(0.45, 0.25)},
		{name = "_fight_down", frames = 2, anchorFight = CCPointMake(0.48, 0.75), anchorFightFemale = CCPointMake(0.48, 0.75)}
	}


---------------------------------
function PlayerObject:destroy()
	PlayerObject:superClass().destroy(self);

	for i, animation in pairs(self.mAnimations) do
		if animation then
			animation:destroy();
		end
	end
end

---------------------------------
function PlayerObject:enterTrap(pos)
	print("PlayerObject:enterTrap");
	self:playAnimation(nil);
	if pos then
		local posTo = Vector.new(self.mField:positionToGrid(pos));
		self:moveTo(posTo);
	else
		self:playAnimation(PlayerObject.OBJECT_IN_TRAP);
	end
end

--------------------------------
function PlayerObject:onMoveFinished( )
	PlayerObject:superClass().onMoveFinished(self);
	self:playAnimation(PlayerObject.OBJECT_IN_TRAP);
	self.mDelta = nil;
end

--------------------------------
function PlayerObject:initAnimation()
	local texture = tolua.cast(self.mNode, "CCSprite"):getTexture();

	self.mAnimations = {}
	self.mAnimations[-1] = EmptyAnimation:create();
	self.mAnimations[-1]:init(texture, self.mNode, self.mNode:getAnchorPoint());

	-- create empty animation
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
			self.mAnimations[i] = FramesAnimation:create();
			self.mAnimations[i]:init(self.mNameTexture..info.name, info.frames, self.mNode, texture,
				self.mIsFemale and ANIMATION_MALE[i].anchorFightFemale or 
				ANIMATION_MALE[i].anchorFight);
		end
	end
end

--------------------------------
function PlayerObject:playAnimation(button)
	--print("PlayerObject:playAnimation ", self.mLastButtonPressed);
	if self.mLastButtonPressed ~= button then
		self.mLastButtonPressed = button;
		print("PlayerObject:playAnimation2 ", self.mLastButtonPressed, " button ", button);
		self.mNode:stopAllActions();
		button = (button == nil) and -1 or button;
		self.mAnimations[button]:play();
	end
end

--------------------------------
function PlayerObject:init(field, node, needReverse)
	PlayerObject:superClass().init(self, field, node);

	self.mFightTrigger = FightTrigger:create();
	self.mFightTrigger:init(field);

	if needReverse then 
		self.mReverse = Vector.new(-1, 1);
		self.mNameTexture = PlayerObject.FEMALE_PREFIX;
		self.mIsFemale = true;
	end
	self:initAnimation();
	self:playAnimation(nil);
end

--------------------------------
function PlayerObject:setFightButton(fightButton)
	self.mFightButton = fightButton;
end

--------------------------------
function PlayerObject:setJoystick(joystick)
	self.mJoystick = joystick;
end

--------------------------------
function PlayerObject:collisionDetect(delta, newDir)
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
function PlayerObject:fight()
	if not self.mFightButton then
		return false;
	end
	if self.mFightButton:isPressed() then
		self:playAnimation(self.mLastDir + PlayerObject.mFightButtonOffset);

		self.mFightTrigger:setActivated(true);
		local selfPosX, selfPosY = self.mNode:getPosition();
		
		local newDir = DIRECTIONS[self.mLastDir]:clone() * self.mReverse;

		self.mFightTrigger.mNode:setPosition(CCPointMake(selfPosX + self.mField:getCellSize() * newDir.x, selfPosY + self.mField:getCellSize() * newDir.y));

		return true;
	end

	self.mFightTrigger:setActivated(false);
	
	return false;
end

--------------------------------
function PlayerObject:move(dt)
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
function PlayerObject:tick(dt)
	PlayerObject:superClass().tick(self, dt);
	
	self.mFightTrigger:tick(dt);

	if PlayerObject.OBJECT_IN_TRAP == self.mLastButtonPressed or self.mDelta then
		-- do nothing object is in trap
	elseif not self:fight() then 
		self:move(dt);
	end
end
