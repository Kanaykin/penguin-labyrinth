require "Inheritance"
require "Vector"

FightButton = inheritsFrom(nil)

FightButton.BUTTON_TAG = 21;
FightButton.mBBox = nil;
FightButton.mButtonNode = nil;
FightButton.mPressed = false;

--------------------------------
function FightButton:onDown()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	local frame = cache:spriteFrameByName("fire_button_pressed.png");
	print("frame ", frame);
	self.mButtonNode:setDisplayFrame(frame);
	self.mPressed = true;
end

--------------------------------
function FightButton:onUp()
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	local frame = cache:spriteFrameByName("fire_button.png");
	print("frame ", frame);
	self.mButtonNode:setDisplayFrame(frame);
	self.mPressed = false;
end

--------------------------------
function FightButton:onTouchHandler(action, pos)
	print("FightButton:onTouchHandler ", action);
	if action == "began" or action == "moved" then
		if self.mBBox:containsPoint(CCPointMake(pos.x, pos.y)) then
			if not self.mPressed then
				self:onDown();
			end
		else
			if self.mPressed then
				self:onUp();
			end
		end

	elseif action == "ended" then
		if self.mPressed then
			self:onUp();
		end
	end
end

--------------------------------
function FightButton:init(guiLayer)
	local node  = guiLayer:getChildByTag(FightButton.BUTTON_TAG);
	print(" FightButton:init ", node);
	self.mButtonNode = tolua.cast(node, "CCSprite");

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
	cache:addSpriteFramesWithFile("fight_button_map.plist");

	self.mBBox = node:boundingBox();
	print("box x", self.mBBox.origin.x, " y ", self.mBBox.origin.y);
	local parent = node:getParent();
	
	local function onTouchHandler(action, var)
		self:onTouchHandler(action, Vector.new(var[1], var[2]));
    end

    local layer = tolua.cast(parent, "CCLayer");
    layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
    layer:setTouchEnabled(true);
end