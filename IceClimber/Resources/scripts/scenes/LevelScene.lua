require "BaseScene"
require "Joystick"

LevelScene = inheritsFrom(BaseScene)
LevelScene.mJoystick = nil;

--------------------------------
function LevelScene:init(sceneMan, params)
	print("LevelScene:init ");
	self:superClass().init(self, sceneMan, {});

	self:initScene();

	self:initGui();
end

--------------------------------
function LevelScene:initScene()
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("level_1_1", reader, false);

	self.mSceneGame:addChild(node);
end

--------------------------------
function LevelScene:initGui()
	self:createGuiLayer();
	
	self.mJoystick = Joystick:create();
	self.mJoystick:init(self);
end
