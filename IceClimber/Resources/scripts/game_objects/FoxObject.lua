require "PlayerObject"
require "PlistAnimation"
require "RandomAnimation"
require "DelayAnimation"

FoxObject = inheritsFrom(PlayerObject)

FoxObject.mVelocity = 25;

--------------------------------
function FoxObject:init(field, node, needReverse)
	print("FoxObject:init ");
	FoxObject:superClass().init(self, field, node, needReverse);

	self.mVelocity = self.mVelocity * field.mGame:getScale();
end

--------------------------------
function FoxObject:move(dt)
	FoxObject:superClass().move(self, dt);
end

--------------------------------
function FoxObject:tick(dt)
	FoxObject:superClass().tick(self, dt);

	if self.mNode and self.mLastButtonPressed == Joystick.BUTTONS.RIGHT or self.mLastButtonPressed ==  Joystick.BUTTONS.LEFT then
		local flip = self.mLastButtonPressed == Joystick.BUTTONS.RIGHT;
		if self.mIsFemale then
			flip = not flip;
		end
		--flip = (self.mIsFemale) and (not flip) or flip;
		tolua.cast(self.mNode, "CCSprite"):setFlipX(flip);
	end
end

--------------------------------
function FoxObject:createRepeatAnimation(nameAnimation)
	local animation = PlistAnimation:create();
	animation:init(nameAnimation, self.mNode, self.mNode:getAnchorPoint());

	local repeatAnimation = RepeatAnimation:create();
	repeatAnimation:init(animation);
	return repeatAnimation;
end

--------------------------------
function FoxObject:createIdleAnimation(nameAnimation)
	local idle = PlistAnimation:create();
	idle:init(nameAnimation, self.mNode, self.mNode:getAnchorPoint());
	local delayAnim = DelayAnimation:create();
	delayAnim:init(idle, math.random());
	self.mAnimations[-1]:addAnimation(delayAnim);
end

--------------------------------
function FoxObject:initAnimation()
	local texture = tolua.cast(self.mNode, "CCSprite"):getTexture();

	self.mAnimations = {}
	
	self.mAnimations[-1] = RandomAnimation:create();
	self.mAnimations[-1]:init();
	self:createIdleAnimation("FoxIdle1.plist");
	self:createIdleAnimation("FoxIdle2.plist");
	self:createIdleAnimation("FoxIdle3.plist");

	self.mAnimations[-1]:play();

	-- create empty animation
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
			self.mAnimations[i] = self:createRepeatAnimation("FoxWalk1.plist");
		end
	end

	for i=6,9 do
		self.mAnimations[i] = self:createRepeatAnimation("FoxFight.plist");
	end

	self.mAnimations[PlayerObject.OBJECT_IN_TRAP] = self:createRepeatAnimation("FoxInTrap.plist");

	self.mAnimations[PlayerObject.WIN_STATE] = EmptyAnimation:create();
	self.mAnimations[PlayerObject.WIN_STATE]:init(texture, self.mNode, self.mNode:getAnchorPoint());
end
