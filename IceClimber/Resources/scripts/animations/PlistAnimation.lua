require "EmptyAnimation"

PlistAnimation = inheritsFrom(EmptyAnimation)
PlistAnimation.mAnimation = nil;
PlistAnimation.mAction = nil;

--------------------------------
function PlistAnimation:getAction()
	return self.mAction;
end

--------------------------------
function PlistAnimation:setAction(action)
	self.mAction:release();
	self.mAction = action;
	self.mAction:retain();
end

--------------------------------
function PlistAnimation:destroy()
	PlistAnimation:superClass().destroy(self);
	self.mAction:release();
end

----------------------------
function PlistAnimation:play()
--	print("PlistAnimation:play");
	PlistAnimation:superClass().play(self);

	self.mNode:stopAction(self.mAction);
	print("PlistAnimation:play mNode ", self.mNode);
	print("PlistAnimation:play mAction ", self.mAction);
	self.mNode:runAction(self.mAction);
end

---------------------------------
function PlistAnimation:isDone()
	--print("PlistAnimation:isDone ", CCDirector:sharedDirector():getActionManager():numberOfRunningActionsInTarget(self.mAction:getTarget()));
	return self.mAction and self.mAction:isDone() or 
		CCDirector:sharedDirector():getActionManager():numberOfRunningActionsInTarget(self.mAction:getTarget()) == 0;
end

--------------------------------
function PlistAnimation:tick(dt)
	--print("animation is done :", self.mAction:isDone());
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

   	local arrayFrames = {};
   	local array = dictionary:allKeys();
   	for i = 1, array:count() do
   		local nameFrame = array:objectAtIndex(i - 1);
   		local nameStr = tolua.cast(nameFrame, "CCString"):getCString();
   		print("PlistAnimation nameFrame ", nameStr);
   		--self.mAnimation:addSpriteFrameWithFileName(nameStr);
   		--local frame = cache:spriteFrameByName(nameStr);
   		--print("PlistAnimation frame ", frame);
   		table.insert(arrayFrames, nameStr);
   		--self.mAnimation:addSpriteFrame(frame);
   	end

   	table.sort( arrayFrames, function(x, y) 
   		return y < x;
   	end );

   	for i, val in ipairs(arrayFrames) do
   		local frame = cache:spriteFrameByName(val);
   		print("PlistAnimation frame ", frame);
   		self.mAnimation:addSpriteFrame(frame);
   	end

   	self.mAnimation:setDelayPerUnit(1 / 10);
	self.mAnimation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(self.mAnimation);
	self.mAction = action;--CCActionInterval:create(action, 1);

	self.mAction:retain();
end