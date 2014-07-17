require "Inheritance"
require "Vector"
require "FieldNode"
require "FactoryObject"

Field = inheritsFrom(nil)
Field.mArray = nil;
Field.mSize = nil;
Field.mFieldNode = nil;
Field.mEnemyObjects = nil;
Field.mFinishTrigger = nil;
Field.mGame = nil;

Field.mPlayerObjects = nil;

-- #FIXME: 
local MAX_NUMBER = math.huge;
local MIN_NUMBER = -math.huge;

Field.mObjects = nil;
Field.mFreePoints = nil;
Field.mCellSize = nil;
Field.mState = nil;
Field.mStateListener = nil;

-- states
Field.PAUSE = 1;
Field.IN_GAME = 2;
Field.WIN = 3;
Field.LOSE = 4;

--------------------------------
function COORD(x, y, width)
	return x + 1 + y * width;
end

--------------------------------
function PRINT_FIELD(array, size)
	for j = 0, size.y do
		local raw = "";
		for i = 0, size.x do
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
function Field:setStateListener(listener)
	self.mStateListener = listener;
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
	for i, val in pairs(self.mArray) do
		--print ("i ", i, "val ", val);
		cloneArr[i] = val;
	end
	PRINT_FIELD(cloneArr, self.mSize);
	return cloneArr;
end

--------------------------------
function Field:isBrick(brick)
	return brick:getTag() == FactoryObject.BRICK_TAG;
end

---------------------------------
function Field:updateScrollPos()
	local min = math.huge;
	local max = -math.huge;
	for i, val in ipairs(self.mPlayerObjects) do
		local x, y = val.mNode:getPosition();
		min = math.min(min, y);
		max = math.max(max, y);
	end
	local visibleSize = CCDirector:sharedDirector():getVisibleSize();
	local pos = max - visibleSize.height / 2;
	pos = math.max(pos, 0);
	--print ("Field:updateScrollPos ", pos); 
	self.mFieldNode:setScrollPos(Vector.new(0, pos));
end

---------------------------------
function Field:checkFinishGame()
	if self.mState ~= Field.IN_GAME then
		return;
	end

	-- check win game
	local allObjectInTrigger = true;
	for _, trigger in ipairs(self.mFinishTrigger) do
		local obj = trigger:getContainedObj();
		if not obj then
			allObjectInTrigger = false;
		end
	end
	
	if allObjectInTrigger then
		print("Field:checkFinishGame WIN");
		self:onStateWin()
		return;
	end

	-- check game over
	local allObjectInTrap = true;
	for _, object in ipairs(self.mPlayerObjects) do
		--print("isInTrap ", object:isInTrap());
		if not object:isInTrap() then
			allObjectInTrap = false;
		end
	end

	if allObjectInTrap then
		print("Field:checkFinishGame LOSE");
		self:onStateLose();
		return;
	end
end

---------------------------------
function Field:onStateLose()
	self.mState = Field.LOSE;
	print("LOSE !!!");
	if self.mStateListener then
		self.mStateListener:onStateLose();
	end
end

---------------------------------
function Field:onStateWin()
	self.mState = Field.WIN;
	print("WIN !!!");
	if self.mStateListener then
		self.mStateListener:onStateWin();
	end

	for _, object in ipairs(self.mObjects) do
		object:onStateWin();
	end
end

---------------------------------
function Field:onStatePause()
	self.mState = Field.PAUSE;
	print("PAUSE !!!");
end

---------------------------------
function Field:onStateInGame()
	self.mState = Field.IN_GAME;
	print("IN GAME !!!");
end

---------------------------------
function Field:updateState()
	if self.mState ~= Field.PAUSE and self.mState ~= Field.IN_GAME then
		return;
	end
	--print("self.mGame.mDialogManager:hasModalDlg() ", self.mGame.mDialogManager:hasModalDlg());
	if self.mState == Field.IN_GAME and self.mGame.mDialogManager:hasModalDlg() then
		self:onStatePause();
	elseif self.mState == Field.PAUSE and not self.mGame.mDialogManager:hasModalDlg() then
		self:onStateInGame();
	end
end

---------------------------------
function Field:tick(dt)
	self:updateState();

	if self.mState ~= Field.PAUSE then
		for i, obj in ipairs(self.mObjects) do
			obj:tick(dt);
		end
		self:updateScrollPos();
		self:checkFinishGame();
	end
end

--------------------------------
function Field:fillFreePoint()
	for j = 0, self.mSize.y do
		for i = 0, self.mSize.x do
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
function Field:findArrayIndex(array, object)
	local index = nil;
	for i, val in ipairs(array) do
		if val == object then
			index = i;
			break;
		end
	end
	return index;
end

--------------------------------
function Field:removeObject(object)
	print("Field:removeObject(", object, ")");
	local index = self:findArrayIndex(self.mObjects, object);
	if index then
		table.remove(self.mObjects, index);
	end
	print("Field:removeObject ", index);
end

--------------------------------
function Field:removeEnemy(enemy)
	print("Field:removeEnemy(", enemy, ")");
	local index = self:findArrayIndex(self.mEnemyObjects, enemy);
	if index then
		table.remove(self.mEnemyObjects, index);
	end
	print("Field:removeEnemy ", index);
end

--------------------------------
function Field:onEnemyEnterTrigger(enemy)
	print("Field:onEnemyEnterTrigger ", enemy);
	
	self:removeObject(enemy);
	self:removeEnemy(enemy)
	enemy:destroy();
end

--------------------------------
function Field:onEnemyLeaveTrigger(enemy)
end

--------------------------------
function Field:getEnemyObjects()
	return self.mEnemyObjects;
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
	local anchor = CCPointMake(0, 0);--node:getAnchorPoint();
	local nodeSize = node:getContentSize();
	
	local leftBottom = Vector.new(posX - anchor.x * nodeSize.width, posY - anchor.y * nodeSize.height);
	return self:positionToGrid(leftBottom);
end

--------------------------------
function Field:onPlayerLeaveWeb(player)
	print("onPlayerLeaveWeb ");
	player:leaveTrap(nil);
end

--------------------------------
function Field:onPlayerEnterWeb(player, pos)
	print("onPlayerEnterWeb ");
	-- if player is primary then game over
	player:enterTrap(pos);
end

--------------------------------
function Field:onPlayerEnterMob(player, pos)
	print("onPlayerEnterMob ");
	-- if player is primary then game over
	player:enterTrap(nil);
end

--------------------------------
function Field:getFieldNode()
	return self.mFieldNode;
end

--------------------------------
function Field:createSnareTrigger(pos)
	print("Field:createSnareTrigger x= ", pos.x, " y= ", pos.y);
	local node = CCNode:create();
	node:setContentSize(CCSizeMake(self:getCellSize(), self:getCellSize()));
	self:getFieldNode():addChild(node);

	-- #FIXME: anchor point for fox scene
	node:setAnchorPoint(CCPointMake(0.5, 0.5));
	node:setPosition(CCPointMake(pos.x, pos.y));

	local web = SnareTrigger:create();
	web:init(self, node, Callback.new(self, Field.onPlayerEnterMob), Callback.new(self, Field.onPlayerLeaveWeb));
	table.insert(self.mObjects, web);
	table.insert(self.mEnemyObjects, web);
end

--------------------------------
function Field:addArrayBorder()
	print("Field:addArrayBorder ", self.mSize.x);

	for j = 0, self.mSize.y do
		self.mArray[COORD(0, j, self.mSize.x)] = 1;
		self.mArray[COORD(self.mSize.x, j, self.mSize.x)] = 1;
	end

	for i = 0, self.mSize.x do
		self.mArray[COORD(i, 0, self.mSize.x)] = 1;
		self.mArray[COORD(i, self.mSize.y, self.mSize.x)] = 1;
	end
end

--------------------------------
function Field:addBrick(brick)
	local x, y = self:getGridPosition(brick);
	self.mArray[COORD(x, y, self.mSize.x)] = 1;
end

--------------------------------
function Field:addMob(mob)
	self:addObject(mob);
	table.insert(self.mEnemyObjects, mob);
end

--------------------------------
function Field:addFinish(finish)
	self:addObject(finish);
	table.insert(self.mFinishTrigger, finish);
end

--------------------------------
function Field:addPlayer(player)
	self:addObject(player);
	table.insert(self.mPlayerObjects, player);
end

--------------------------------
function Field:addObject(object)
	table.insert(self.mObjects, object);
end

--------------------------------
function Field:init(fieldNode, layer, fieldData, game)

	self.mState = Field.IN_GAME;

	local objectType = _G[fieldData.playerType];
	local mobType = _G[fieldData.mobType];
	print(" Game ", game);
	self.mCellSize = fieldData.cellSize * game:getScale();
	self.mGame = game;

	self.mObjects = {}
	self.mFreePoints = {};
	self.mPlayerObjects = {};
	self.mEnemyObjects = {};
	self.mFinishTrigger = {};
	self.mLeftBottom = Vector.new(0, 0);
	self.mFieldNode = FieldNode:create();
	self.mFieldNode:init(fieldNode, layer, self);

	if not self.mFieldNode then
		return;
	end

	local children = self.mFieldNode:getChildren();
	local count = children:count();
	print("count ", count);
	if count == 0 then
		return;
	end
	
	-- compute size of brick
	local minValue = Vector.new(MAX_NUMBER, MAX_NUMBER);
	local maxValue = Vector.new(MIN_NUMBER, MIN_NUMBER);

	local contentSize = self.mFieldNode:getContentSize();
	print("newMaxValue x ", contentSize.width / self.mCellSize, " y ", contentSize.height / self.mCellSize);

	maxValue.x = contentSize.width / self.mCellSize + 1;--(maxValue.x - minValue.x) / self.mCellSize;
	maxValue.y = contentSize.height / self.mCellSize + 1;--(maxValue.y - minValue.y) / self.mCellSize;

	print("maxValue x ", maxValue.x, " y ", maxValue.y);
	self.mArray = {};
	self.mSize = maxValue;
	-- fill zero 
	for i = 0, maxValue.x do
		for j = 0, maxValue.y do
			self.mArray[COORD(i, j, maxValue.x)] = 0;
		end
	end

	for i = 1, count do
		local brick = tolua.cast(children:objectAtIndex(i - 1), "CCNode");

		local object = FactoryObject:createObject(self, brick);
		print("create object ", object);
	end

	self:addArrayBorder();

	-- fill free point it is point where objects can move
	self:fillFreePoint();
	self:printField();
end