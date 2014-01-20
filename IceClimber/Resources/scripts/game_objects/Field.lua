require "Inheritance"
require "Vector"
require "MobObject"
require "PlayerObject"
require "SnareTrigger"

Field = inheritsFrom(nil)
Field.mArray = nil;
Field.mSize = nil;

Field.BRICK_TAG = -1;
Field.DECOR_TAG = 0;
Field.MOB_TAG = 100;
Field.PLAYER_TAG = 101;
Field.PLAYER2_TAG = 102;
Field.LOVE_CAGE_TAG = 103;
Field.WEB_TAG = 104;


Field.mPlayerObjects = nil;

-- #FIXME: 
local MAX_NUMBER = math.huge;
local MIN_NUMBER = -math.huge;

Field.mObjects = nil;
Field.mFreePoints = nil;
Field.mCellSize = nil;

--------------------------------
function COORD(x, y, width)
	return x + (y - 1) * width;
end

--------------------------------
function PRINT_FIELD(array, size)
	for j = 1, size.y + 1 do
		local raw = "";
		for i = 1, size.x + 1 do
			--print("COORD ", COORD(i, j, size.x))
			raw = raw .. tostring(array[COORD(i, j, size.x)]) .. " ";
		end
		print(raw);
	end
end


---------------------------------
function Field:destroy()
	for i, obj in ipairs(self.mObjects) do
		obj:destroy();
	end
end

--------------------------------
function Field:getCellSize()
	return self.mCellSize;
end

--------------------------------
function Field:getFreePoints()
	return self.mFreePoints;
end

--------------------------------
function Field:printField()
	PRINT_FIELD(self.mArray, self.mSize);
end

--------------------------------
function Field:cloneArray()
	PRINT_FIELD(self.mArray, self.mSize);
	local cloneArr = {};
	for i, val in ipairs(self.mArray) do
		--print ("i ", i, "val ", val);
		cloneArr[i] = val;
	end
	PRINT_FIELD(cloneArr, self.mSize);
	return cloneArr;
end

--------------------------------
function Field:isBrick(brick)
	return brick:getTag() == Field.BRICK_TAG;
end

---------------------------------
function Field:tick(dt)
	for i, obj in ipairs(self.mObjects) do
		obj:tick(dt);
	end
end

--------------------------------
function Field:fillFreePoint()
	for j = 1, self.mSize.y + 1 do
		for i = 1, self.mSize.x + 1 do
			if self.mArray[COORD(i, j, self.mSize.x)] == 0 then 
				table.insert(self.mFreePoints, Vector.new(i, j));
			end
		end
	end
end

--------------------------------
function Field:gridPosToReal(posDest)
	local x = (posDest.x - 1) * self.mCellSize + self.mLeftBottom.x;
	local y = (posDest.y - 1) * self.mCellSize + self.mLeftBottom.y;
	return Vector.new(x, y);
end

--------------------------------
function Field:getPlayerObjects()
	return self.mPlayerObjects;
end

--------------------------------
function Field:isFreePoint( point )
	return self.mArray[COORD(point.x, point.y, self.mSize.x)] == 0;
end

--------------------------------
function Field:positionToGrid(position)
	local leftBottom = Vector.new(position.x - self.mLeftBottom.x, position.y - self.mLeftBottom.y);
	return math.floor(leftBottom.x / self.mCellSize) + 1, math.floor(leftBottom.y / self.mCellSize) + 1;
end

--------------------------------
function Field:getGridPosition(node)
	local posX, posY = node:getPosition();
	local anchor = node:getAnchorPoint();
	local nodeSize = node:getContentSize();
	
	local leftBottom = Vector.new(posX - anchor.x * nodeSize.width, posY - anchor.y * nodeSize.height);
	return self:positionToGrid(leftBottom);
end

--------------------------------
function Field:onPlayerLeaveWeb(player)
	print("onPlayerLeaveWeb ");
end

--------------------------------
function Field:onPlayerEnterWeb(player, pos)
	print("onPlayerEnterWeb ");
	-- if player is primary then game over
	player:enterTrap(pos);
end

--------------------------------
function Field:init(fieldNode)
	self.mObjects = {}
	self.mFreePoints = {};
	self.mPlayerObjects = {};

	--self.mCellSize = 22 * CCBReader:getResolutionScale();

	local children = fieldNode:getChildren();
	local count = children:count();
	print("count ", count);
	if count == 0 then
		return;
	end
	
	-- compute size of brick
	local firstBrick = nil;
	local sizeBrick = nil;
	local minValue = Vector.new(MAX_NUMBER, MAX_NUMBER);
	local maxValue = Vector.new(MIN_NUMBER, MIN_NUMBER);
	for i = 1, count do
		local brick = tolua.cast(children:objectAtIndex(i - 1), "CCNode");
		
		if not firstBrick and self:isBrick(brick) then 
			firstBrick = brick;
			sizeBrick = firstBrick:getContentSize();
			self.mCellSize = sizeBrick.width;
		end

		local posX, posY = brick:getPosition();
		local anchor = brick:getAnchorPoint();
		local brickSize = brick:getContentSize();
		
		local leftButtom = Vector.new(posX - anchor.x * brickSize.width, posY - anchor.y * brickSize.height);
		
		minValue.x = math.min(minValue.x, leftButtom.x);
		minValue.y = math.min(minValue.y, leftButtom.y);
		maxValue.x = math.max(maxValue.x, leftButtom.x);
		maxValue.y = math.max(maxValue.y, leftButtom.y);
	end

	maxValue.x = (maxValue.x - minValue.x) / sizeBrick.width;
	maxValue.y = (maxValue.y - minValue.y) / sizeBrick.width;

	print("maxValue x ", maxValue.x, " y ", maxValue.y);
	self.mArray = {};
	self.mSize = maxValue;
	self.mLeftBottom = minValue;
	-- fill zero 
	for i = 1, maxValue.x + 1 do
		for j = 1, maxValue.y + 1 do
			self.mArray[COORD(i, j, maxValue.x)] = 0;
		end
	end

	for i = 1, count do
		local brick = tolua.cast(children:objectAtIndex(i - 1), "CCNode");
		
		if self:isBrick(brick) then
			local x, y = self:getGridPosition(brick);
			self.mArray[COORD(x, y, self.mSize.x)] = 1;
		elseif brick:getTag() == Field.MOB_TAG then
			print("it is mob");
			local mob = MobOject:create();
			mob:init(self, brick);
			table.insert(self.mObjects, mob);
		elseif brick:getTag() == Field.PLAYER_TAG or brick:getTag() == Field.PLAYER2_TAG then
			print("it is player");
			local player = PlayerOject:create();
			player:init(self, brick, brick:getTag() == Field.PLAYER2_TAG);
			table.insert(self.mObjects, player);
			table.insert(self.mPlayerObjects, player);
		elseif brick:getTag() == Field.WEB_TAG then
			print("it is web");
			local web = SnareTrigger:create();
			web:init(self, brick, Callback.new(self, Field.onPlayerEnterWeb), Callback.new(self, Field.onPlayerLeaveWeb));
			table.insert(self.mObjects, web);
		end
	end

	-- fill free point it is point where objects can move
	self:fillFreePoint();
	self:printField();
end