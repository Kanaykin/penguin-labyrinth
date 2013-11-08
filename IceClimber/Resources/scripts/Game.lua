require "SceneManager"

--[[
It is main class for game.
--]]
Game =  inheritsFrom(nil)
Game.mSceneMan = nil
Game.mGameTime = 0

---------------------------------
function Game:tick(dt)
	self.mGameTime = self.mGameTime + dt;
	self.mSceneMan:tick(dt);
end

---------------------------------
function Game:init()
		-- create scene manager
	self.mSceneMan = SceneManager:create();
	self.mSceneMan:init();

	local g_game = self;
	
	function tick(dt)
		g_game:tick(dt);
	end

	CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0, false)
end
