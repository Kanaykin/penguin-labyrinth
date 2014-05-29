require "MobObject"
require "PlistAnimation"

DogObject = inheritsFrom(MobObject)

DogObject.mAnimation = nil;

--------------------------------
function DogObject:initAnimation()
	print("HunterObject:initAnimation");

	print("Texture ", tolua.cast(self.mNode, "CCSprite"):getTexture():getName());
	self.mAnimation = PlistAnimation:create();
	self.mAnimation:init("DogWalk.plist", self.mNode, self.mNode:getAnchorPoint());
	self.mAnimation:play();

	--[[local animation = CCAnimation:create();
	print("animation ", animation);
	animation:addSpriteFrameWithFileName("spider_frame1.png"); 
	animation:addSpriteFrameWithFileName("spider_frame2.png"); 

	animation:setDelayPerUnit(1 / 2);
	animation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(animation);
	local repeatForever = CCRepeatForever:create(action);
	self.mNode:runAction(repeatForever);]]
end