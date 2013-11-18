require "BaseScene"
require "ScrollView"
require "AlignmentHelper"

local LOADSCEENIMAGE = "choseLevel.png"

--[[
start scene - loading screen
]]
ChooseLevel = inheritsFrom(BaseScene)
ChooseLevel.mScrollView = nil;

--------------------------------
function ChooseLevel:createLocationImages()
end

--------------------------------
function ChooseLevel:initScene()
	self.mScrollView = ScrollView:create();
	self.mScrollView:init(CCSizeMake(3, 1), {LOADSCEENIMAGE, LOADSCEENIMAGE});
	self.mSceneGame:addChild(self.mScrollView.mScroll);

	--parallax
	local parallax = CCParallaxNode:create();
	self.mScrollView:addChild(parallax);

	local count = 5;
	local delta = 2 / (count + 1);
	local position = 0;
	for i=1,count do
		-- grass images
		local pos = Coord(position, 0, 50, 50);
		local grass = CCSprite:create("grass.png");
		parallax:addChild(grass, 1, CCPointMake(0.4, 1.0), getPosition(grass, pos));
		-- cloud images
		local posCloud = Coord(position, 0.8, 50, 50);
		local cloud = CCSprite:create("cloud1.png");
		parallax:addChild(cloud, 1, CCPointMake(0.4, 1.0), getPosition(cloud, posCloud));
		position = position + delta;
	end

	self:createLocationImages();
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

--------------------------------
function ChooseLevel:init(sceneMan)
	self:superClass().init(self, sceneMan, nil);

	-- init scene
	self:initScene();

	-- init gui
	self:initGui();
end
