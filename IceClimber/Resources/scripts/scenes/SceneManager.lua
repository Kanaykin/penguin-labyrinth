require "BaseScene"
require "LoadingScene"
require "StartScene"
require "ChooseLocation"
require "ChooseLevel"
require "LevelScene"

--[[
It is class for controlling of scenes.
The game contain three base scenes: start, choosing level and level
--]]
SceneManager =  inheritsFrom(nil)
SceneManager.mScenes = {};
SceneManager.mCurrentSceneId = nil; -- current scene
SceneManager.mGame = nil;

SCENE_TYPE_ID = {
	LOADING_SCENE = 0;
	START_SCENE = 1;
	CHOOSE_LOCATION = 2;
	CHOOSE_LEVEL = 3;
	LEVEL = 4;
};

---------------------------------
function SceneManager:getCurrentScene()
	print("SceneManager:getCurrentScene ", self.mCurrentSceneId);
	return self.mScenes[self.mCurrentSceneId];
end

---------------------------------
function SceneManager:runPrevScene(params)
	self:destroyCurrentScene();
	
	self.mCurrentSceneId = self.mCurrentSceneId - 1;
	if self.mCurrentSceneId <= 0 then
		self.mCurrentSceneId = 0;
	end

	self:getCurrentScene():init(self, params);
	CCDirector:sharedDirector():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:destroyCurrentScene()
	if self:getCurrentScene() ~= nil then
		self:getCurrentScene():destroy();
		CCDirector:sharedDirector():popScene();
	end
end

---------------------------------
function SceneManager:runNextScene(params)
	self:destroyCurrentScene();

	if self.mCurrentSceneId == nil then
		self.mCurrentSceneId = 0;
	else
		self.mCurrentSceneId = self.mCurrentSceneId + 1;
	end

	print("mCurrentSceneId ", self.mCurrentSceneId);
	self:getCurrentScene():init(self, params);
	CCDirector:sharedDirector():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:replayScene()
	print("SceneManager:replayScene");
	self:runLevelScene(self:getCurrentScene():getLevel());
end

---------------------------------
function SceneManager:runLevelScene(params)
	self:destroyCurrentScene();
	self.mScenes[SCENE_TYPE_ID.LEVEL] = LevelScene:create();

	self.mCurrentSceneId = SCENE_TYPE_ID.LEVEL;
	self:getCurrentScene():init(self, params);
	CCDirector:sharedDirector():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:tick(dt)
	if self:getCurrentScene() ~= nil then
		self:getCurrentScene():tick(dt);
	end
end

---------------------------------
function SceneManager:init(game)
	self.mGame = game;

	-- add fake scene
	local fakeScene = CCScene:create();
	CCDirector:sharedDirector():pushScene(fakeScene);

	-- loading scene initialize
	self.mScenes[SCENE_TYPE_ID.LOADING_SCENE] = LoadingScene:create();
	
	-- start scene initialize
	self.mScenes[SCENE_TYPE_ID.START_SCENE] = StartScene:create();
	
	-- choice location scene initialize
	self.mScenes[SCENE_TYPE_ID.CHOOSE_LOCATION] = ChooseLocation:create();

	-- choice level scene initialize
	self.mScenes[SCENE_TYPE_ID.CHOOSE_LEVEL] = ChooseLevel:create();

	
	self:runNextScene();
end

