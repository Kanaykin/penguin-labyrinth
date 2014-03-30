require "PlayerObject"
require "PlistAnimation"

FoxObject = inheritsFrom(PlayerObject)

--------------------------------
function FoxObject:init(field, node, needReverse)
	print("FoxObject:init ");
	FoxObject:superClass().init(self, field, node, needReverse);
end

--------------------------------
function FoxObject:move(dt)
	FoxObject:superClass().move(self, dt);
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
end
