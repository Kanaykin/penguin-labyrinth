require "SceneManager"
require "GameConfigs"
require "Location"

--[[
It is main class for game.
--]]
Game =  inheritsFrom(nil)
Game.mSceneMan = nil
Game.mGameTime = 0
Game.mScale = 1
Game.mLocations = {}

local SUPPORTED_RESOLUTION = {
	{ size = CCSizeMake(480, 320), scale = 1, searchPath = "resources-iphone"},
	{ size = CCSizeMake(700, 350), scale = 2, searchPath = "resources-iphonehd"}, -- for android 480x800
	{ size = CCSizeMake(960, 640), scale = 2, searchPath = "resources-iphonehd"},
	{ size = CCSizeMake(1024, 768), scale = 2, searchPath = "resources-iphonehd"},
	{ size = CCSizeMake(1024 * 2, 768 * 2), scale = 2, searchPath = "resources-iphonehd"}
}

local RESOURCE_DIRECTORIES = {
	"Published-iOS", "Maps"
}

local DESIGN_RESOLUTION_SIZE = CCSizeMake(480, 320);

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

	local resolutionInfo = nil;
	for i = #SUPPORTED_RESOLUTION, 1, -1  do
		if visibleSize.width >= SUPPORTED_RESOLUTION[i].size.width and visibleSize.height >= SUPPORTED_RESOLUTION[i].size.height then
			print("resolution x ", SUPPORTED_RESOLUTION[i].size.width);
			resolutionInfo = SUPPORTED_RESOLUTION[i];
			break;
		end
	end

	if resolutionInfo then 
		--CCDirector:sharedDirector():getOpenGLView():setDesignResolutionSize(resolutionInfo.size.width, resolutionInfo.size.height, 1);
		local scale = math.min(visibleSize.width / DESIGN_RESOLUTION_SIZE.width, visibleSize.height / DESIGN_RESOLUTION_SIZE.height);
		print("SCALE ", scale);
		self.mScale = scale;
		CCBReader:setResolutionScale(scale);
		CCDirector:sharedDirector():setContentScaleFactor( (1 / scale) * resolutionInfo.scale);
		local fileUtils = CCFileUtils:sharedFileUtils();
		-- add resource directories
		for i, val in ipairs(RESOURCE_DIRECTORIES) do
			fileUtils:addSearchPath(val);
			fileUtils:addSearchPath(val.."/"..resolutionInfo.searchPath);
		end
	end
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
