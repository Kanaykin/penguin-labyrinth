require "MovableObject"
require "WavePathFinder"
require "SnareTrigger"
require "PlayerObject"

--local MobOjectImpl = createClass(MovableObject, SnareTrigger;

MobOject = inheritsFrom(MovableObject)

MobOject.IDLE = 1;
MobOject.MOVING = 2;

MobOject.mState = MobOject.IDLE;
MobOject.mPath = nil;
MobOject.mTrigger = nil;

--------------------------------
function MobOject:initAnimation()
	print("MobOject:initAnimation");

	local animation = CCAnimation:create();
	print("animation ", animation);
	animation:addSpriteFrameWithFileName("spider_frame1.png"); 
	animation:addSpriteFrameWithFileName("spider_frame2.png"); 

	animation:setDelayPerUnit(1 / 2);
	animation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(animation);
	local repeatForever = CCRepeatForever:create(action);
	self.mNode:runAction(repeatForever);
end

--------------------------------
function MobOject:onPlayerEnter(player, pos)
	print("MobOject.onPlayerEnter ", player.mNode:getTag());
	self.mField:createSnareTrigger(Vector.new(player.mNode:getPosition()));
	--player:enterTrap(nil);
end

--------------------------------
function MobOject:onPlayerLeave(player)
	print("MobOject.onPlayerLeave");
	--player:leaveTrap(nil);
end

--------------------------------
function MobOject:init(field, node)
	print("MobOject:init(", node, ")");
	MobOject:superClass().init(self, field, node);

	self.mState = MobOject.IDLE;
	self.mTrigger = SnareTrigger:create();

	-- set size of cell
	self.mNode:setContentSize(CCSizeMake(self.mField:getCellSize(), self.mField:getCellSize()));

	self.mTrigger:init(self.mField, self.mNode, Callback.new(self, MobOject.onPlayerEnter), Callback.new(self, MobOject.onPlayerLeave));

	-- create animation
	self:initAnimation();
end

--------------------------------
function MobOject:getDestPoint()
	local freePoints = self.mField:getFreePoints();
	return freePoints[math.random(#freePoints)];
end

--------------------------------
function MobOject:moveToNextPoint( )
	if #self.mPath == 0 then
		self.mState = MobOject.IDLE;
		return;
	end
	self:moveTo(self.mPath[1]);
	table.remove(self.mPath, 1);
end

--------------------------------
function MobOject:onMoveFinished( )
	self:moveToNextPoint();
end

--------------------------------
function MobOject:tick(dt)
	MobOject:superClass().tick(self, dt);

	if self.mTrigger then
		self.mTrigger:tick(dt);
	end

	if self.mState == MobOject.IDLE then
		-- find free point on field and move to this point
		local destPoint = self:getDestPoint();
		-- clone field
		local cloneArray = self.mField:cloneArray();
		print ("MobOject:tick destPoint ", destPoint.x, "y ", destPoint.y);
		self.mState = MobOject.MOVING;
		self.mPath = WavePathFinder.buildPath(self.mGridPosition, destPoint, cloneArray, self.mField.mSize);
		table.remove(self.mPath, 1);
		self:moveToNextPoint();
	end
end
