require "BaseScene"

ChooseLevel = inheritsFrom(BaseScene)

--------------------------------
function ChooseLevel:init(sceneMan)
	print("ChooseLevel:init ");
	self:superClass().init(self, sceneMan, "Games_Duck_Hunt_Nintendo_Dendy_Nes_025749_32.jpg");

	self:initGui();

	self:initScene();
end

--------------------------------
function ChooseLevel:initScene()
	local reader = CCBReader:new();
	local node = reader:load("ChoiceLevel");
	print("ChooseLevel:initScene ", node);
end

--------------------------------
function ChooseLevel:initGui()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    
    self.mLayerMenu = CCLayer:create();
	self.mSceneGame:addChild(self.mLayerMenu);

	-- play button
	local menuToolsItem = CCMenuItemImage:create("back_normal.png", "back_pressed.png");
    menuToolsItem:setPosition(- visibleSize.width / 3, - visibleSize.height / 3);

    local choseLevel = self;

    local function onReturnPressed()
    	print("onReturnPressed");
    	choseLevel.mSceneManager:runPrevScene();
    end

    menuToolsItem:registerScriptTapHandler(onReturnPressed);

    local menuTools = CCMenu:createWithItem(menuToolsItem);
    
    self.mLayerMenu:addChild(menuTools);
end