require "PlayerObject"
require "PlistAnimation"
require "RandomAnimation"
require "DelayAnimation"

FoxObject = inheritsFrom(PlayerObject)

FoxObject.mVelocity = 25;
FoxObject.mAnimationNode = nil;
FoxObject.mEffectNode = nil;
FoxObject.mEffectAnimations = nil;

FoxObject.OBJECT_NODE_TAG = 5;
FoxObject.EFFECT_NODE_TAG = 6;

--------------------------------
function FoxObject:init(field, node, needReverse)
	self.mAnimationNode  = node:getChildByTag(FoxObject.OBJECT_NODE_TAG);
	self.mEffectNode = node:getChildByTag(FoxObject.EFFECT_NODE_TAG);
	self.mEffectNode:setVisible(false);

	print("FoxObject:init node_obj ", self.mAnimationNode);
	
	FoxObject:superClass().init(self, field, node, needReverse);

	self.mVelocity = self.mVelocity * field.mGame:getScale();

	self.mLastDir = 2;
	if not self.mIsFemale then
		tolua.cast(self.mAnimationNode, "CCSprite"):setFlipX(true);
	end
end

--------------------------------
function FoxObject:move(dt)
	FoxObject:superClass().move(self, dt);
end

--------------------------------
function FoxObject:setFightActivated(activated)
	print("FoxObject:setFightActivated ", activated);
	FoxObject:superClass().setFightActivated(self, activated);
	self.mEffectNode:setVisible(activated);

	local flip = self:updateFlipNode(self.mEffectNode);

	if flip then
		local anchor = self.mEffectNode:getPositionX();
		print("FoxObject:setFightActivated getPositionX ", anchor);
		self.mEffectNode:setPositionX(-anchor);
	end

	if activated then
		self.mEffectAnimations[1]:play();
		self.mEffectAnimations[1]:setStopAfterDone(false);
	else
		--self.mEffectNode:stopAllActions();
		--self.mEffectAnimations[1]:stop();
	end
end

--------------------------------
function FoxObject:weakfight()
	local result = FoxObject:superClass().weakfight(self);
	self.mEffectAnimations[1]:setStopAfterDone(true);
	return result;
end

--------------------------------
function FoxObject:fight()
	local result = FoxObject:superClass().fight(self);
	--self.mEffectAnimations[1]:play();
	if self.mEffectAnimations[1] then
		self.mEffectAnimations[1]:setStopAfterDone(false);
	end
	return result;
end

--------------------------------
function FoxObject:updateFlipNode(node)
	local flip = false;
	if node and self.mLastDir == Joystick.BUTTONS.RIGHT or self.mLastDir ==  Joystick.BUTTONS.LEFT then
		flip = self.mLastDir == Joystick.BUTTONS.RIGHT;
		if self.mIsFemale then
			flip = not flip;
		end
		--flip = (self.mIsFemale) and (not flip) or flip;
		tolua.cast(node, "CCSprite"):setFlipX(flip);
	end
	return flip; 
end

--------------------------------
function FoxObject:tick(dt)
	FoxObject:superClass().tick(self, dt);

	self:updateFlipNode(self.mAnimationNode);

	self.mEffectAnimations[1]:tick();
end

--------------------------------
function FoxObject:createRepeatAnimation(node, nameAnimation, soft)
	local animation = PlistAnimation:create();
	animation:init(nameAnimation, node, node:getAnchorPoint());

	local repeatAnimation = RepeatAnimation:create();
	repeatAnimation:init(animation, soft);
	return repeatAnimation;
end

--------------------------------
function PlayerObject:getAnimationNode()
	return self.mAnimationNode;
end

--------------------------------
function FoxObject:createIdleAnimation(nameAnimation)
	local idle = PlistAnimation:create();
	idle:init(nameAnimation, self.mAnimationNode, self.mAnimationNode:getAnchorPoint());
	local delayAnim = DelayAnimation:create();
	delayAnim:init(idle, math.random());
	self.mAnimations[-1]:addAnimation(delayAnim);
end

--------------------------------
function FoxObject:initEffectAnimations()
	self.mEffectAnimations = {};
	self.mEffectAnimations[1] = self:createRepeatAnimation(self.mEffectNode, "WaveHor.plist", true);
end

--------------------------------
function FoxObject:initAnimation()
	local texture = tolua.cast(self.mAnimationNode, "CCSprite"):getTexture();

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
			self.mAnimations[i] = self:createRepeatAnimation(self.mAnimationNode, "FoxWalk1.plist");
		end
	end

	for i=6,9 do
		self.mAnimations[i] = self:createRepeatAnimation(self.mAnimationNode, "FoxFight.plist", true);
	end

	self.mAnimations[PlayerObject.OBJECT_IN_TRAP] = self:createRepeatAnimation(self.mAnimationNode, "FoxInTrap.plist");

	self.mAnimations[PlayerObject.WIN_STATE] = EmptyAnimation:create();
	self.mAnimations[PlayerObject.WIN_STATE]:init(texture, self.mNode, self.mNode:getAnchorPoint());

	self:initEffectAnimations();
end
