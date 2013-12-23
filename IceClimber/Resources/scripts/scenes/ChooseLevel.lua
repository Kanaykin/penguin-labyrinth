require "BaseScene"

ChooseLevel = inheritsFrom(BaseScene)
local LOADSCEENIMAGE = "Games_Duck_Hunt_Nintendo_Dendy_Nes_025749_32.jpg"

--------------------------------
function ChooseLevel:init(sceneMan, params)
	print("ChooseLevel:init ");
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});

	self:initScene();

	self:initGui();
end

--------------------------------
function ChooseLevel:initScene()
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("MainScene", reader, false);

	local child = node:getChildByTag(2);
	local star = child:getChildByTag(23);
	local star2 = child:getChildByTag(22);
	local dummy = child:getChildByTag(100);
	if star ~= nil then
		--child:removeChild(star, false);
	end
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
			local animManager = tolua.cast(arrayAnimator:objectAtIndex(scene.count), "CCBAnimationManager");
			animManager:runAnimationsForSequenceNamed("StarAnim");
			if scene.count == 1 then
				animManager:moveAnimationsFromNode(star, dummy);
				animManager:moveAnimationsFromNode(star2, dummy);
				child:removeChild(star, false);
				child:removeChild(star2, false);
				--tolua.cast(arrayAnimator:objectAtIndex(scene.count - 1), "CCBAnimationManager"):runAnimationsForSequenceNamed("OneStar");
			end

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