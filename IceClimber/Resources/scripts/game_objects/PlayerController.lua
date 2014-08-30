require "Inheritance"
require "TouchWidget"

PlayerController = inheritsFrom(TouchWidget)

PlayerController.mPlayerObjects = nil

PlayerController.mClickSize = 80;
PlayerController.mField = nil
PlayerController.mObjectCaptured = nil
PlayerController.mDeltaCapturedPos = nil

PlayerController.mPrevObjectPosition = nil

PlayerController.mDestPos = nil

PlayerController.mJoystick = nil

PlayerController.mFightButton = nil

---------------------------------
function PlayerController:destroy()
end

--------------------------------
function PlayerController:init(bbox, players, field, joystick, fightButton)
	self:superClass().init(self, bbox);
	self.mPlayerObjects = players;
	self.mField = field;
	self.mJoystick = joystick;
	self.mFightButton = fightButton;
end

----------------------------------------
function PlayerController:touchObject(object, point)
	local pos = object:getScreenPos();
	
	local scale = self.mField.mGame:getScale();

	local width = PlayerController.mClickSize * scale;
	local box = CCRectMake(pos.x - width / 2, pos.y - width / 2, width, width);
	return box:containsPoint(CCPointMake(point.x, point.y));
end

----------------------------------------
function PlayerController:onDoubleTouch(point)
	print("PlayerController:onDoubleTouch ");
	self.mFightButton:setPressed(true);
end

----------------------------------------
function PlayerController:onTouchBegan(point)
	print("PlayerController:onTouchBegan (", point.x, " ,", point.y, ")");

	self:resetData();
	self.mObjectCaptured = nil;
	for _, object in ipairs(self.mPlayerObjects) do
		--local box = object:getBoundingBox();
		--print("PlayerController:onTouchBegan  x ", box.origin.x, " y ", box.origin.y);
		--print("PlayerController:onTouchBegan  size ", box.size.width, " y ", box.size.height);
		local pos = object:getScreenPos();
		print("PlayerController:onTouchBegan  x ", pos.x, " y ", pos.y);
		if self:touchObject(object, point) then
			print("self:touchObject ");
			self.mObjectCaptured = object;
			self.mDeltaCapturedPos = Vector.new(point.x, point.y) - Vector.new(object.mNode:getPosition());
		end
	end
end

----------------------------------------
function PlayerController:getJoystickButton(direction)
	local horProj = direction:projectOn(Vector.new(1, 0));
	local horProjLen = horProj:len();
	print("PlayerController:getJoystickButton horProj ", horProjLen);
	local verProj = direction:projectOn(Vector.new(0, 1));
	local verProjLen = verProj:len();
	print("PlayerController:getJoystickButton verProj ", verProjLen);

	if horProjLen == 0 and verProjLen == 0 then
		return nil;
	end

	if horProjLen > verProjLen then
		return horProj.x > 0 and Joystick.BUTTONS.LEFT or Joystick.BUTTONS.RIGHT;
	else
		return verProj.y > 0 and Joystick.BUTTONS.BOTTOM or Joystick.BUTTONS.TOP;
	end
end

----------------------------------------
function PlayerController:onTouchMoved(point)
	--print("PlayerController:onTouchMoved x ", point.x, " y ", point.y);
	local gridPos = Vector.new(self.mField:positionToGrid(Vector.new(point.x, point.y)));
	--print("PlayerController:onTouchMoved gridPos x ", gridPos.x, " y ", gridPos.y);

	if self.mObjectCaptured ~= nil then
		self.mDestPos = gridPos:clone();
		local dest = self.mField:gridPosToReal(gridPos);
		self.mDestPos.x = dest.x + self.mField.mCellSize / 2;
		self.mDestPos.y = dest.y + self.mField.mCellSize / 2;

		local newObjPos = Vector.new(self.mObjectCaptured.mNode:getPosition()) + self.mDeltaCapturedPos;
		local objGridPos = Vector.new(self.mField:positionToGrid(newObjPos));
		local button = self:getJoystickButton((objGridPos - gridPos) * self.mObjectCaptured:getReverse());
		print("PlayerController:onTouchMoved objGridPos ", objGridPos.y);
		print("PlayerController:onTouchMoved gridPos ", gridPos.y);
		self.mJoystick:setButtonPressed(button);
	end
end

---------------------------------
function PlayerController:resetData()
	print("PlayerController:resetData");
	self.mDestPos = nil;
	self.mJoystick:setButtonPressed(nil);
	self.mPrevObjectPosition = nil;
end

---------------------------------
function PlayerController:positionChanged()
	--print("PlayerController:positionChanged ", self.mPrevObjectPosition);
	if self.mPrevObjectPosition == nil then
		return true;
	end

	local result = false;
	local index = 1;
	for _, object in ipairs(self.mPlayerObjects) do
		local pos = Vector.new(object.mNode:getPosition());
		
		if object == self.mObjectCaptured and (pos - self.mPrevObjectPosition[index]):len() > 0 then
			result = true;
		end
		self.mPrevObjectPosition[index] = pos;
		index = index + 1;
	end
	return result;
end

---------------------------------
function PlayerController:tick(dt)
	self:superClass().tick(self, dt);

	self.mFightButton:setPressed(false);

	if self.mDestPos ~= nil then
		-- get directional of moving
		local newObjPos = Vector.new(self.mObjectCaptured.mNode:getPosition()) + self.mDeltaCapturedPos;
		print("PlayerController:onTouchMoved newObjPos x ", newObjPos.x, " y ", newObjPos.y);
		print("PlayerController:onTouchMoved mDestPos x ", self.mDestPos.x, " y ", self.mDestPos.y);
		
		local objGridPos = Vector.new(self.mField:positionToGrid(newObjPos));
		local destGridPos = Vector.new(self.mField:positionToGrid(self.mDestPos));
		--print("PlayerController:onTouchMoved objGridPos x ", objGridPos.x, " y ", objGridPos.y);
		--local button = self:getJoystickButton((objGridPos - destGridPos) * self.mObjectCaptured:getReverse());
		
		--self.mJoystick:setButtonPressed(button);

		local button = self:getJoystickButton((newObjPos - self.mDestPos) * self.mObjectCaptured:getReverse());
		print("PlayerController:onTouchMoved button ", button);
		print("PlayerController:onTouchMoved mJoystick ", self.mJoystick:getButtonPressed());

		if button ~= self.mJoystick:getButtonPressed() or not self:positionChanged() then
			self:resetData();
		end
	end
end

----------------------------------------
function PlayerController:onTouchEnded(point)
	print("PlayerController:onTouchEnded ");
	--self.mObjectCaptured = nil
	--self.mJoystick:setButtonPressed(nil);
	self.mPrevObjectPosition = {}

	for _, object in ipairs(self.mPlayerObjects) do
		local pos = Vector.new(object.mNode:getPosition());
		print("PlayerController:onTouchEnded  x ", pos.x, " y ", pos.y);
		self.mPrevObjectPosition[#self.mPrevObjectPosition + 1] = pos;
	end
end
