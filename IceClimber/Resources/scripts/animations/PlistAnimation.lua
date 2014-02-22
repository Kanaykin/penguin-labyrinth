require "EmptyAnimation"

PlistAnimation = inheritsFrom(EmptyAnimation)
PlistAnimation.mAnimation = nil;
PlistAnimation.mAction = nil;
PlistAnimation.tmp = 1;

--------------------------------
function PlistAnimation:destroy()
	PlistAnimation:superClass().destroy(self);
	self.mAction:release();
end

----------------------------
function PlistAnimation:play()
	print("PlistAnimation:play");
	PlistAnimation:superClass().play(self);

	self.mNode:runAction(self.mAction);

	if self.tmp > 100 then
		self.mNode:dfg();
	end
	self.tmp = self.tmp +1 ;
end

--------------------------------
function PlistAnimation:init(plistName, node, anchor, texture)

	PlistAnimation:superClass().init(self, texture, node, anchor);
	
	local dictionaryPrimary = CCDictionary:createWithContentsOfFile(plistName);
	local dictionary = tolua.cast(dictionaryPrimary:objectForKey('frames'), "CCDictionary");
	print("dictionary ", dictionary);

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
   	cache:addSpriteFramesWithFile(plistName);

   	self.mAnimation = CCAnimation:create();

   	local array = dictionary:allKeys();
   	for i = 1, array:count() do
   		local nameFrame = array:objectAtIndex(i - 1);
   		local nameStr = tolua.cast(nameFrame, "CCString"):getCString();
   		print("PlistAnimation nameFrame ", nameStr);
   		--self.mAnimation:addSpriteFrameWithFileName(nameStr);
   		local frame = cache:spriteFrameByName(nameStr);
   		print("PlistAnimation frame ", frame);
   		self.mAnimation:addSpriteFrame(frame);
   	end

   	self.mAnimation:setDelayPerUnit(1 / 5);
	self.mAnimation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(self.mAnimation);
	self.mAction = CCRepeatForever:create(action);

	self.mAction:retain();
--[[
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile(plistName);


	for i = 1, 11 do
		local fullName = FoxIdle00..tostring(i)..".png";
		print("PlistAnimation:createAnimation ", fullName);
		self.mAnimation:addSpriteFrameWithFileName(fullName);
	end

	self.mAnimation = CCAnimation:createWithSpriteFrames();

	self.mAnimation:setDelayPerUnit(1 / 10);
	self.mAnimation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(self.mAnimation);
	self.mAction = CCRepeatForever:create(action);

	self.mAction:retain();]]
end