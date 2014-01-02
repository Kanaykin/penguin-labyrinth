require "BaseScene"

ChooseLevel = inheritsFrom(BaseScene)
ChooseLevel.mCurLocation = nil;
local LOADSCEENIMAGE = "Games_Duck_Hunt_Nintendo_Dendy_Nes_025749_32.jpg"

--------------------------------
function ChooseLevel:init(sceneMan, params)
	print("ChooseLevel:init ", params.location);
	self.mCurLocation = params.location;
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});

	self:initScene();

	self:initGui();
end

--------------------------------
function ChooseLevel:initScene()
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("MainScene", reader, false);

	local animator = reader:getAnimationManager();
	local arrayAnimator = reader:getAnimationManagersForNodes();
	
	local minCount = (arrayAnimator:count() < #self.mCurLocation.mLevels) and arrayAnimator:count() or #self.mCurLocation.mLevels;
	print("minCount ", minCount);

	for i = 1, minCount do
		local nameFrame = "0:frame"..i;

		local animManager = tolua.cast(arrayAnimator:objectAtIndex(i - 1), "CCBAnimationManager");
		local child = node:getChildByTag(i);
		self.mCurLocation.mLevels[i]:initVisual(animator, animManager, nameFrame, child);
	end

	animator:runAnimationsForSequenceNamed("Default Timeline");

	self.mSceneGame:addChild(node);
end

--------------------------------
function ChooseLevel:initGui()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    
    self:createGuiLayer();

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
    
    self.mGuiLayer:addChild(menuTools);
end