require "Inheritance"
require "Vector"

Joystick = inheritsFrom(nil)

Joystick.BACKGROUND_TAG = 10;
Joystick.BUTTON_TAG = 20;

Joystick.mCenter = nil;
Joystick.mRadius = nil;
Joystick.mDestPosition = nil;
Joystick.mButton = nil;

--------------------------------
function Joystick:onTouchHandler(action, position)
	if action == "began" or action == "moved" then
		local res = (position - self.mCenter):normalize() * self.mRadius;
		print("res x ", res.x, " y ", res.y);
		-- compute position of button
		if (position - self.mCenter):len() > self.mRadius then
			self.mDestPosition = res + self.mCenter;
		else
			self.mDestPosition = position;
		end
	else
		self.mDestPosition = self.mCenter;
	end
	self.mButton:setPosition(self.mDestPosition.x, self.mDestPosition.y);
end

--------------------------------
function Joystick:init(scene)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("joystick", reader, false);

	scene.mGuiLayer:addChild(node);

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
