require "BaseScene"
require "ScrollView"
require "AlignmentHelper"
require "GameConfigs"

local LOADSCEENIMAGE = "choseLevel.png"

--[[
start scene - loading screen
]]
ChooseLocation = inheritsFrom(BaseScene)
ChooseLocation.mScrollView = nil;

--------------------------------
function ChooseLocation:createLocationImages()
	local locations = self.mSceneManager.mGame:getLocations();
	for i, location in pairs(locations) do
		local locationImage = CCSprite:create(location:getImage());
		self.mScrollView:addClickableChild(locationImage, location, "onLocationPressed");
		setPosition(locationImage, location:getPosition());
		
		--------------------
		local function onLocationPressed()
    		print(" onLocationPressed", location:getImage());
    	end

    	--locationImage:registerScriptTapHandler(onLocationPressed);
		
		-- if location is locked
		if not location:isOpened() then
			local lock = CCSprite:create("lock.png");
			locationImage:addChild(lock);
			setPosition(lock, Coord(0.5, 0.5, 0, 0));
			lock:setScaleX(2);
			lock:setScaleY(2);
		end 
	end
end

--------------------------------
function ChooseLocation:initScene()
	self.mScrollView = ScrollView:create();
	self.mScrollView:init(CCSizeMake(2.5, 1), {LOADSCEENIMAGE, LOADSCEENIMAGE, LOADSCEENIMAGE, LOADSCEENIMAGE});
	self.mScrollView:setClickable(true);
	self.mSceneGame:addChild(self.mScrollView.mScroll);

	self:createLocationImages();

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

end

--------------------------------
function ChooseLocation:initGui()
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
function ChooseLocation:init(sceneMan)
	print("ChooseLocation:init ");
	self:superClass().init(self, sceneMan, nil);

	-- init scene
	self:initScene();

	-- init gui
	self:initGui();
end
