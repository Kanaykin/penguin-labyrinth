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
		locat:init(location);
		self.mLocations[location.id] = locat;
	end
end


---------------------------------
function Game:init()
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
