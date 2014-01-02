require "SceneManager"
require "GameConfigs"
require "Location"

--[[
It is main class for game.
--]]
Game =  inheritsFrom(nil)
Game.mSceneMan = nil
Game.mGameTime = 0
Game.mLocations = {}

local SUPPORTED_RESOLUTION = {
	{ size = CCSizeMake(480, 320), scale = 1},
	{ size = CCSizeMake(960, 640), scale = 2},
	{ size = CCSizeMake(1024, 768), scale = 2},
	{ size = CCSizeMake(1024 * 2, 768 * 2), scale = 4}
}

---------------------------------
function Game:getLocations()
	return self.mLocations;
end

---------------------------------
function Game:tick(dt)
	self.mGameTime = self.mGameTime + dt;
	self.mSceneMan:tick(dt);
end

---------------------------------
function Game:createLocation()
	for i, location in ipairs(gLocations) do
		local locat = Location:create();
		locat:init(location, self);
		self.mLocations[location.id] = locat;
	end
end

---------------------------------
function Game:initResolution()
	-- compute resolution scale
	local visibleSize = CCDirector:sharedDirector():getVisibleSize();

	local scale = 1;
	for i = #SUPPORTED_RESOLUTION, 1, -1  do
		if visibleSize.width >= SUPPORTED_RESOLUTION[i].size.width and visibleSize.height >= SUPPORTED_RESOLUTION[i].size.height then
			print("resolution x ", SUPPORTED_RESOLUTION[i].size.width);
			scale = SUPPORTED_RESOLUTION[i].scale;
			break;
		end
	end

	CCBReader:setResolutionScale(scale);
end

---------------------------------
function Game:init()
	self:initResolution();

	-- create scene manager
	self.mSceneMan = SceneManager:create();
	self.mSceneMan:init(self);

	-- create locations
	self:createLocation();

	local g_game = self;
	
	function tick(dt)
		g_game:tick(dt);
	end

	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0, false)
end
