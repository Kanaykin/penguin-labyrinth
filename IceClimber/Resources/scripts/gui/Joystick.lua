require "Inheritance"
require "Vector"

Joystick = inheritsFrom(nil)

Joystick.BUTTONS = {
	LEFT = 1,
	RIGHT = 2,
	TOP = 3,
	BOTTOM = 4,
	NONE = nil	
};

Joystick.BACKGROUND_TAG = 10;
Joystick.JOYSTICK_TAG = 15;
Joystick.BUTTON_TAG = 20;

Joystick.mCenter = nil;
Joystick.mRadius = nil;
Joystick.mDestPosition = nil;
Joystick.mButton = nil;
Joystick.mButtonPressed = Joystick.BUTTONS.NONE;
Joystick.mBBox = nil;

--------------------------------
function Joystick:getButtonPressed( )
	return self.mButtonPressed;
end

--------------------------------
function Joystick:findButtonPressed(res)
	if math.abs(res.x) > math.abs(res.y) then
		if res.x > 0 then
			self.mButtonPressed = Joystick.BUTTONS.RIGHT;
		else
			self.mButtonPressed = Joystick.BUTTONS.LEFT;
		end
	else
		if res.y > 0 then
			self.mButtonPressed = Joystick.BUTTONS.TOP;
		else
			self.mButtonPressed = Joystick.BUTTONS.BOTTOM;
		end
	end
end

--------------------------------
function Joystick:onTouchHandler(action, position)
	-- check out of bound
	if not self.mBBox:containsPoint(CCPointMake(position.x, position.y)) then
		action = "cancelled"
	end

	if action == "began" or action == "moved" then
		local res = (position - self.mCenter):normalize() * self.mRadius;
		-- compute position of button
		if (position - self.mCenter):len() > self.mRadius then
			self.mDestPosition = res + self.mCenter;
		else
			self.mDestPosition = position;
		end
		self:findButtonPressed(res);
	else
		self.mDestPosition = self.mCenter;
		self.mButtonPressed = Joystick.BUTTONS.NONE;
	end
	self.mButton:setPosition(self.mDestPosition.x, self.mDestPosition.y);
end

--------------------------------
function Joystick:init(guiLayer)
	--local ccpproxy = CCBProxy:create();
	--local reader = ccpproxy:createCCBReader();
	--local node = ccpproxy:readCCBFromFile("joystick", reader, false);
	local node  = guiLayer:getChildByTag(Joystick.JOYSTICK_TAG);
	print(" Joystick:init ", node);

	--scene.mGuiLayer:addChild(node);
	self.mBBox = node:boundingBox();
	
	-- set touch enabled for joystick 
	local function onTouchHandler(action, var)
		self:onTouchHandler(action, Vector.new(var[1], var[2]));
    end

    local layer = tolua.cast(node, "CCLayer");
    layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
    layer:setTouchEnabled(true);

    -- init joystick size
    local back = node:getChildByTag(Joystick.BACKGROUND_TAG);
    local backSize = back:getContentSize();
    print("backSize width ", backSize.width, " height ", backSize.height);
    local backPosX, backPosY = back:getPosition();
    local anchor = back:getAnchorPoint();
    
    self.mRadius = backSize.width / 2;
    self.mCenter = Vector.new(backPosX - backSize.width * anchor.x + self.mRadius, backPosY - backSize.height * anchor.y + self.mRadius);
    print("mCenter x ", self.mCenter.x, " y ", self.mCenter.y);

    -- get button of joystick
    self.mButton = node:getChildByTag(Joystick.BUTTON_TAG);
    local buttonSize = self.mButton:getContentSize();
    self.mRadius = self.mRadius - buttonSize.width / 2;
end
