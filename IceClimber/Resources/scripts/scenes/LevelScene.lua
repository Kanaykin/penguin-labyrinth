require "BaseScene"
require "Joystick"
require "Field"
require "FightButton"
require "MainUI"

LevelScene = inheritsFrom(BaseScene)
LevelScene.mField = nil;
LevelScene.mData = nil;

LevelScene.FIELD_NODE_TAG = 10;
LevelScene.mMainUI = nil;

local LOADSCEENIMAGE = "choseLevel.png"


---------------------------------
function LevelScene:destroy()
	print("LevelScene:destroy ");
	LevelScene:superClass().destroy(self);

	if self.mMainUI then
		self.mMainUI:destroy();
	end

	if self.mField then
		self.mField:destroy();
	end

end

--------------------------------
function LevelScene:init(sceneMan, params)
	print("LevelScene:init ");
	LevelScene:superClass().init(self, sceneMan, params);
	self.mData = params;

	self:initScene();

	self:initGui();

	-- set joystick to players
	local players = self.mField:getPlayerObjects();
	if players then
		for i, player in ipairs(players) do
			player:setJoystick(self.mMainUI.mJoystick);
			player:setFightButton(self.mMainUI.mFightButton);
		end
	end
end

--------------------------------
function LevelScene:initScene()

	if self.mData.tileMap then
		local tileMap = CCTMXTiledMap:create(self.mData.tileMap);
		print(" LevelScene:initScene tileMap ", tileMap);
		self.mSceneGame:addChild(tileMap);
	end

	if type(self.mData.ccbFile) == "string" then
		local ccpproxy = CCBProxy:create();
		local reader = ccpproxy:createCCBReader();
		
		local node = ccpproxy:readCCBFromFile(self.mData.ccbFile, reader, false);

		self.mSceneGame:addChild(node);

		-- create field
		local fieldNode = node:getChildByTag(LevelScene.FIELD_NODE_TAG);

		self.mField = Field:create();
		self.mField:init({ fieldNode }, node, self.mData, self.mSceneManager.mGame);
	elseif type(self.mData.ccbFile) == "table" then
		local layers = {};
		local nodes = {};
		for i, fileName in ipairs(self.mData.ccbFile) do
			local ccpproxy = CCBProxy:create();
			local reader = ccpproxy:createCCBReader();
			local node = ccpproxy:readCCBFromFile(fileName, reader, false);
			table.insert(layers, node);
			local fieldNode = node:getChildByTag(LevelScene.FIELD_NODE_TAG);
			table.insert(nodes, fieldNode);
			local layerSize = node:getContentSize();
			local fieldSize = fieldNode:getContentSize();
			node:setContentSize(CCSizeMake(layerSize.width, fieldSize.height));
		end
		self.mScrollView = ScrollView:create();
		self.mScrollView:initLayers(layers);
		self.mScrollView:setTouchEnabled(false);
		
		self.mSceneGame:addChild(self.mScrollView.mScroll);
		self.mField = Field:create();
		self.mField:init(nodes, self.mScrollView.mScroll, self.mData, self.mSceneManager.mGame);
	end
end

---------------------------------
function LevelScene:tick(dt)
	LevelScene:superClass().tick(self, dt);
	self.mField:tick(dt);
end

--------------------------------
function LevelScene:initGui()
	self:createGuiLayer();

	self.mMainUI = MainUI:create();
	self.mMainUI:init(self.mSceneManager.mGame.mDialogManager, self.mGuiLayer, "Level_UI_layer");
	self.mMainUI:show();
end
