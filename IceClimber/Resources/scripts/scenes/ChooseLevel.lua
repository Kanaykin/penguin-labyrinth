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
	print("child ", child);

	local animator = reader:getAnimationManager();
	for i = 1,4 do
		local nameFrame = "0:frame"..i;
		local function temp(val1)
			print("print ", val1);
		end
		local callFunc = CCCallFunc:create(temp);
		animator:setCallFuncForLuaCallbackNamed(callFunc, nameFrame);
	end
	if animator ~= nil then
		--animator:runAnimationsForSequenceNamed("Default Timeline");
	end 
	child:stopAllActions();
	print("ChooseLevel:initScene ", node:getUserObject());
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