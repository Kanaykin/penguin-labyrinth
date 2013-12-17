require "BaseScene"

ChooseLevel = inheritsFrom(BaseScene)

--------------------------------
function ChooseLevel:init(sceneMan)
	print("ChooseLevel:init ");
	self:superClass().init(self, sceneMan, "Games_Duck_Hunt_Nintendo_Dendy_Nes_025749_32.jpg");

	self:initScene();

	self:initGui();
end

--------------------------------
function ChooseLevel:initScene()
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("MainScene", reader, false);

	local child = node:getChildByTag(2);
	--tolua.cast(child:getUserData(), "CCBAnimationManager"):runAnimationsForSequenceNamed("StarAnim");

	local animator = reader:getAnimationManager();
	local arrayAnimator = reader:getAnimationManagersForNodes();
	arrayAnimator:retain();

	print("array ", arrayAnimator:count());

	for i = 1,6 do
		local nameFrame = "0:frame"..i;

		self.count = 0;
		local scene = self;
		--------------------------------------
		local function temp()
			print("temp ", arrayAnimator)
			tolua.cast(arrayAnimator:objectAtIndex(scene.count), "CCBAnimationManager"):runAnimationsForSequenceNamed("StarAnim");

			scene.count = scene.count + 1;
		end
		--------------------------------------

		local callFunc = CCCallFunc:create(temp);
		animator:setCallFuncForLuaCallbackNamed(callFunc, nameFrame);
	end

	--------------------------------------
	local function finish()
		print("finish ")
	end
	--------------------------------------
	local callFinishFunc = CCCallFunc:create(finish);
	animator:setCallFuncForLuaCallbackNamed(callFinishFunc, "0:finish");

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