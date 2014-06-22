require "PlayerObject"
require "PlistAnimation"

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
function FoxObject:initAnimation()
	local texture = tolua.cast(self.mNode, "CCSprite"):getTexture();

	self.mAnimations = {}
	self.mAnimations[-1] = PlistAnimation:create();
	self.mAnimations[-1]:init("FoxIdle1.plist", self.mNode, self.mNode:getAnchorPoint());
	self.mAnimations[-1]:play();

	--self.mAnimations[3] = PlistAnimation:create();
	--self.mAnimations[3]:init("FoxWalk1.plist", self.mNode, self.mNode:getAnchorPoint());

	-- create empty animation
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
			self.mAnimations[i] = PlistAnimation:create();
			self.mAnimations[i]:init("FoxWalk1.plist", self.mNode, self.mNode:getAnchorPoint());
			--[[self.mAnimations[i]:init(self.mNameTexture..info.name, info.frames, self.mNode, texture,
				self.mIsFemale and ANIMATION_MALE[i].anchorFightFemale or 
				ANIMATION_MALE[i].anchorFight);]]
		end
	end

	for i=6,9 do
		self.mAnimations[i] = PlistAnimation:create();
		self.mAnimations[i]:init("FoxFight.plist", self.mNode, self.mNode:getAnchorPoint());
	end

	self.mAnimations[PlayerObject.OBJECT_IN_TRAP] = PlistAnimation:create();
	self.mAnimations[PlayerObject.OBJECT_IN_TRAP]:init("FoxInTrap.plist", self.mNode, self.mNode:getAnchorPoint());
end
