require "BaseScene"
require "LoadingScene"
require "StartScene"
require "ChooseLevel"

--[[
It is class for controlling of scenes.
The game contain three base scenes: start, choosing level and level
--]]
SceneManager =  inheritsFrom(nil)
SceneManager.mScenes = {};
SceneManager.mCurrentSceneId = nil; -- current scene
SceneManager.mGame = nil;

---------------------------------
function SceneManager:addLevel(scene)
end

---------------------------------
function SceneManager:getCurrentScene()
	return self.mScenes[self.mCurrentSceneId];
end

---------------------------------
function SceneManager:runPrevScene()
	if self:getCurrentScene() ~= nil then
		self:getCurrentScene():destroy();
	end
	
	self.mCurrentSceneId = self.mCurrentSceneId - 1;
	if self.mCurrentSceneId <= 0 then
		self.mCurrentSceneId = 0;
	end

	self:getCurrentScene():init(self);
	CCDirector:sharedDirector():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:runNextScene()
	if self:getCurrentScene() ~= nil then
		self:getCurrentScene():destroy();
	end
	
	if self.mCurrentSceneId == nil then
		self.mCurrentSceneId = 0;
	else
		self.mCurrentSceneId = self.mCurrentSceneId + 1;
	end

	self:getCurrentScene():init(self);
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

	-- loading scene initialize
	self.mScenes[0] = LoadingScene:create();
	
	-- start scene initialize
	self.mScenes[1] = StartScene:create();
	
	-- choosing level scene initialize
	self.mScenes[2] = ChooseLevel:create();
	
	self:runNextScene();
end

