require "Inheritance"

BaseScene = inheritsFrom(nil)
BaseScene.mSceneGame = nil -- cocos csene
BaseScene.mSceneLayer = nil -- cocos scene layer
BaseScene.mSceneManager = nil -- parent of scene

---------------------------------
function BaseScene:destroy()
	print("BaseScene:destroy ");
	self.mSceneGame:release();
end

---------------------------------
function BaseScene:init(sceneMan, backgroundImageName)
	print("BaseScene:init ", backgroundImageName, self.mSceneManager);
	self.mSceneManager = sceneMan;
	self.mSceneGame = CCScene:create();
	self.mSceneGame:retain();

	self.mSceneLayer = CCLayer:create();
	self.mSceneGame:addChild(self.mSceneLayer);

	if backgroundImageName ~= nil then
		local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    
		local bg = CCSprite:create(backgroundImageName);
		local imageSize = bg:getContentSize();
		bg:setPosition(visibleSize.width / 2, visibleSize.height / 2);
		bg:setScaleX(visibleSize.width / imageSize.width);
		bg:setScaleY(visibleSize.height / imageSize.height);

		if bg ~= nil then
			self.mSceneLayer:addChild(bg);
		end
	end

end

---------------------------------
function BaseScene:tick(dt)
end

