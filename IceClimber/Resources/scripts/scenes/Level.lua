require "Inheritance"

Level = inheritsFrom(nil)
Level.mOpened = false;
Level.MENU_TAG = 100;
Level.MENU_ITEM_TAG = 101;
Level.DUMMY_TAG = 20;
Level.FIRST_STAR_TAG = 21;
Level.mLocation = nil;

-----------------------------------
function Level:getCountStar()
	return 0;
end

-----------------------------------
function Level:isOpened()
	return self.mOpened;
end

-----------------------------------
function Level:runStartAnimation(animManager, node)
	print ("Level:runStartAnimation ", self:isOpened())
	if self:isOpened() then
		animManager:runAnimationsForSequenceNamed("StarAnim");
		-- delete unused stars
		local countStar = self:getCountStar();
		local dummy = node:getChildByTag(Level.DUMMY_TAG);
		for i = countStar, 2 do
			local star = node:getChildByTag(Level.FIRST_STAR_TAG + i);
			animManager:moveAnimationsFromNode(star, dummy);
			node:removeChild(star, false);
		end
	else
		animManager:runAnimationsForSequenceNamed("Lock");
	end
end

-----------------------------------
function Level:onLevelIconPressed()
	print("onLevelIconPressed !!!");
	if self:isOpened() then
		self.mLocation.mGame.mSceneMan:runLevelScene({});
	end
end

-----------------------------------
function Level:initButton(node)
	local function onLevelIconPressed()
		self:onLevelIconPressed();
	end

	local menu = node:getChildByTag(Level.MENU_TAG);
	if menu then
		local menuItem = menu:getChildByTag(Level.MENU_ITEM_TAG);
		tolua.cast(menuItem, "CCMenuItem"):registerScriptTapHandler(onLevelIconPressed);
	end
end

-----------------------------------
function Level:initVisual(primaryAnimator, animManager, nameFrame, node)

	local loc_self = self;
	function callback()
		loc_self:runStartAnimation(animManager, node);
	end

	local callFunc = CCCallFunc:create(callback);
	primaryAnimator:setCallFuncForLuaCallbackNamed(callFunc, nameFrame);

	self:initButton(node);
end

---------------------------------
function Level:init(levelData, location)
	self.mLocation = location;
	if(levelData.opened ~= nil ) then
		self.mOpened = levelData.opened; 
	end
end