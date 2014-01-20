require "BaseScene"
require "Joystick"
require "Field"

LevelScene = inheritsFrom(BaseScene)
LevelScene.mJoystick = nil;
LevelScene.mField = nil;

LevelScene.FIELD_NODE_TAG = 10;


---------------------------------
function LevelScene:destroy()
	print("LevelScene:destroy ");
	LevelScene:superClass().destroy(self);

	if self.mField then
		self.mField:destroy();
	end
end

--------------------------------
function LevelScene:init(sceneMan, params)
	print("LevelScene:init ");
	LevelScene:superClass().init(self, sceneMan, {});

	self:initScene();

	self:initGui();

	-- set joystick to players
	local players = self.mField:getPlayerObjects();
	for i, player in ipairs(players) do
		player:setJoystick(self.mJoystick);
	end
end

--------------------------------
function LevelScene:initScene()
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("level_1_1", reader, false);

	self.mSceneGame:addChild(node);

	-- create field
	local fieldNode = node:getChildByTag(LevelScene.FIELD_NODE_TAG);

	self.mField = Field:create();
	self.mField:init(fieldNode);
end

---------------------------------
function LevelScene:tick(dt)
	LevelScene:superClass().tick(self, dt);
	self.mField:tick(dt);
end

--------------------------------
function LevelScene:initGui()
	self:createGuiLayer();

	self.mJoystick = Joystick:create();
	self.mJoystick:init(self);
end
