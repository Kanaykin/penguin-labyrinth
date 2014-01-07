require "MovableObject"

PlayerOject = inheritsFrom(MovableObject)
PlayerOject.mJoystick = nil;
PlayerOject.mVelocity = 1;
PlayerOject.mReverse = Vector.new(1, 1);

DIRECTIONS = {
		Vector.new(-1, 0),
		Vector.new(1, 0),
		Vector.new(0, 1),
		Vector.new(0, -1)
	}

--------------------------------
function PlayerOject:init(field, node, needReverse)
	PlayerOject:superClass().init(self, field, node);

	if needReverse then 
		self.mReverse = Vector.new(-1, 1);
	end
end

--------------------------------
function PlayerOject:setJoystick(joystick)
	self.mJoystick = joystick;
end

--------------------------------
function PlayerOject:collisionDetect(delta, newDir)
	local currentPos = Vector.new(self.mNode:getPosition());
	print("currentPos ", currentPos.x, " ", currentPos.y);
	local destPos = currentPos + delta * self.mField:getCellSize() / 2;
	print("destPos ", destPos.x, " ", destPos.y);

	local destGrid = Vector.new(self.mField:positionToGrid(destPos));
	print("destGrid ", destGrid.x, " ", destGrid.y);

	if self.mField:isFreePoint(destGrid) then
		local centerCell = self.mField:gridPosToReal(destGrid) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		local centerSelf = self.mField:gridPosToReal(Vector.new(self.mField:positionToGrid(currentPos))) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		print("centerCell ", centerCell.x, " ", centerCell.y);
		print("centerSelf ", centerSelf.x, " ", centerSelf.y);
		local dir = centerCell - currentPos;
		if (centerCell - centerSelf):len() <= 1 then
			return true;
		end
		dir:normalize();
		newDir.x = dir.x;
		newDir.y = dir.y;
		print("newDir ", newDir.x, " ", newDir.y);
		return true;
	end
	return false;
end

--------------------------------
function PlayerOject:tick(dt)
	PlayerOject:superClass().tick(self, dt);
	if self.mJoystick then 
		local button = self.mJoystick:getButtonPressed();
		--print("button pressed ", );
		if button then
			local newGridPos = self.mGridPosition + DIRECTIONS[button];
			
			local curPosition = Vector.new(self.mNode:getPosition());
			--curPosition = curPosition + DIRECTIONS[button] * self.mVelocity;
			--local pos = self.mField:gridPosToReal(newGridPos);
			local newDir = DIRECTIONS[button]:clone() * self.mReverse;
			if self:collisionDetect(DIRECTIONS[button] * self.mReverse, newDir) then --self.mField:isFreePoint(newGridPos) then
				curPosition = curPosition + newDir * self.mVelocity;

				self.mNode:setPosition(CCPointMake(curPosition.x, curPosition.y));
				self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
			end
		end
	end
end
