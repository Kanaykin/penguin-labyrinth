require "BaseScene"

local LOADSCEENIMAGE = "choseLevel.png"

--[[
start scene - loading screen
--]]
ChooseLevel = inheritsFrom(BaseScene)

--------------------------------
function ChooseLevel:init(sceneMan)
	self:superClass().init(self, sceneMan, LOADSCEENIMAGE);

	local visibleSize = CCDirector:sharedDirector():getVisibleSize();
    
    self.mLayerMenu = CCLayer:create();
	self.mSceneGame:addChild(self.mLayerMenu);

	-- play button
	local menuToolsItem = CCMenuItemImage:create("back_normal.png", "back_pressed.png");
    menuToolsItem:setPosition(- visibleSize.width / 3, - visibleSize.height / 3);

    local menuTools = CCMenu:createWithItem(menuToolsItem);
    
    self.mLayerMenu:addChild(menuTools);
end
