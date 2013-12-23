require "Inheritance"

BaseScene = inheritsFrom(nil)
BaseScene.mSceneGame = nil -- cocos csene

BaseScene.mBackgroundLayer = nil -- background scene layer
BaseScene.mGameObjectLayer = nil -- game object scene layer
BaseScene.mGuiLayer = nil -- gui scene layer

BaseScene.mSceneManager = nil -- parent of scene
local LAYER_ORDER = {
	BACKGROUND = 0,
	ANIMATION = 1,
	MENU = 2	
};

---------------------------------
function BaseScene:createBackgroundLayer()
	self.mBackgroundLayer = CCLayer:create();
	self.mSceneGame:addChild(self.mBackgroundLayer, LAYER_ORDER.BACKGROUND);
end

---------------------------------
function BaseScene:createGameObjectLayer()
	self.mGameObjectLayer = CCLayer:create();
	self.mSceneGame:addChild(self.mGameObjectLayer, LAYER_ORDER.ANIMATION);
end

---------------------------------
function BaseScene:createGuiLayer()
	self.mGuiLayer = CCLayer:create();
	self.mSceneGame:addChild(self.mGuiLayer, LAYER_ORDER.MENU);
end

---------------------------------
function BaseScene:destroy()
	print("BaseScene:destroy ");
	self.mSceneGame:release();
end

---------------------------------
function BaseScene:init(sceneMan, params)
	local  backgroundImageName = nil;
	if type(params) == "table" then
		backgroundImageName = params.background;
	end
	print("BaseScene:init ", backgroundImageName, self.mSceneManager);
	self.mSceneManager = sceneMan;
	self.mSceneGame = CCScene:create();
	self.mSceneGame:retain();

	self:createBackgroundLayer();
	
	if backgroundImageName ~= nil then
		local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    
		local bg = CCSprite:create(backgroundImageName);
		local imageSize = bg:getContentSize();
		bg:setPosition(visibleSize.width / 2, visibleSize.height / 2);
		bg:setScaleX(visibleSize.width / imageSize.width);
		bg:setScaleY(visibleSize.height / imageSize.height);

		if bg ~= nil then
			self.mBackgroundLayer:addChild(bg);
		end
	end

end

---------------------------------
function BaseScene:tick(dt)
end

