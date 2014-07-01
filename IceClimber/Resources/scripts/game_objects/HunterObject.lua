require "MobObject"
require "PlistAnimation"

HunterObject = inheritsFrom(MobObject)

HunterObject.mAnimation = nil;

--------------------------------
function HunterObject:initAnimation()
	print("HunterObject:initAnimation");

	print("Texture ", tolua.cast(self.mNode, "CCSprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("MarioWalk.plist", self.mNode, self.mNode:getAnchorPoint());

	self.mAnimation = RepeatAnimation:create();
	self.mAnimation:init(animation);
	self.mAnimation:play();
end