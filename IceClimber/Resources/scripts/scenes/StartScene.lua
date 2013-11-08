require "BaseScene"

local LOADSCEENIMAGE = "StartScene.png"
--[[
start scene - loading screen
--]]
StartScene = inheritsFrom(BaseScene)
StartScene.mLayerMenu = nil; 

--------------------------------
function StartScene:init(sceneMan)
	self:superClass().init(self, sceneMan, LOADSCEENIMAGE);
	print("StartScene:init");

	-- create menu elements
	self:createMenuElements();
end

--------------------------------
function StartScene:createMenuElements()
	self.mLayerMenu = CCLayer:create();
	self.mSceneGame:addChild(self.mLayerMenu);

	-- play button
	local menuToolsItem = CCMenuItemImage:create("menu1.png", "menu2.png");
    menuToolsItem:setPosition(0, 0);

    local startScene = self;

    local function onPlayGamePressed()
    	print("onPlayGame");
    	startScene.mSceneManager:runNextScene();
    end

    menuToolsItem:registerScriptTapHandler(onPlayGamePressed);
    local menuTools = CCMenu:createWithItem(menuToolsItem);
    
    self.mLayerMenu:addChild(menuTools);
end

---------------------------------
function StartScene:tick(dt)
	self:superClass().tick(self, dt);
end
