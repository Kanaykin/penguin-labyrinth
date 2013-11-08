require "BaseScene"

local LOADSCEENIMAGE = "Loading.png"
local TIME_SHOWING = 3.0
--[[
loading scene - loading screen
--]]
LoadingScene = inheritsFrom(BaseScene)
LoadingScene.mTimer = nil;

---------------------------------
function LoadingScene:destroy()
	self:superClass().destroy(self);
	self.mTimer:release();
end

--------------------------------
function LoadingScene:init(sceneMan)
	self:superClass().init(self, sceneMan, LOADSCEENIMAGE);
	print("LoadingScene:init");

	local LoadingScene = self;
	local function hideLoadingScene()
		print("hideLoadingScene");
		LoadingScene.mSceneManager:runNextScene();
	end

	self.mTimer = CCTimer:timerWithScriptHandler(hideLoadingScene, TIME_SHOWING);
	self.mTimer:retain();
end

---------------------------------
function LoadingScene:tick(dt)
	self:superClass().tick(self, dt);
	self.mTimer:update(dt);
end
