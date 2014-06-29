require "MovableObject"
require "WavePathFinder"
require "SnareTrigger"
require "PlayerObject"

--local MobObjectImpl = createClass(MovableObject, SnareTrigger;

MobObject = inheritsFrom(MovableObject)

MobObject.IDLE = 1;
MobObject.MOVING = 2;

MobObject.mState = MobObject.IDLE;
MobObject.mPath = nil;
MobObject.mTrigger = nil;

--------------------------------
function MobObject:initAnimation()
	print("MobObject:initAnimation");

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
function MobObject:onPlayerEnter(player, pos)
	print("MobObject.onPlayerEnter ", player.mNode:getTag());
	self.mField:createSnareTrigger(Vector.new(player.mNode:getPosition()));
end

--------------------------------
function MobObject:onPlayerLeave(player)
	print("MobObject.onPlayerLeave");
	--player:leaveTrap(nil);
end

--------------------------------
function MobObject:init(field, node)
	print("MobObject:init(", node, ")");
	MobObject:superClass().init(self, field, node);

	self.mState = MobObject.IDLE;
	self.mTrigger = SnareTrigger:create();

	-- set size of cell
	self.mNode:setContentSize(CCSizeMake(self.mField:getCellSize(), self.mField:getCellSize()));

	self.mTrigger:init(self.mField, self.mNode, Callback.new(self, MobObject.onPlayerEnter), Callback.new(self, MobObject.onPlayerLeave));

	-- create animation
	self:initAnimation();
end

--------------------------------
function MobObject:getDestPoint()
	local freePoints = self.mField:getFreePoints();
	return freePoints[math.random(#freePoints)];
end

--------------------------------
function MobObject:moveToNextPoint( )
	if #self.mPath == 0 then
		self.mState = MobObject.IDLE;
		return;
	end
	self:moveTo(self.mPath[1]);
	table.remove(self.mPath, 1);
end

--------------------------------
function MobObject:onMoveFinished( )
	self:moveToNextPoint();
end

--------------------------------
function MobObject:tick(dt)
	MobObject:superClass().tick(self, dt);

	if self.mTrigger then
		self.mTrigger:tick(dt);
	end

	if self.mDelta then
		local val = self.mDelta:normalized();
		--print("MobObject:tick mDestGridPos ", val.x, ":", val.y);
		tolua.cast(self.mNode, "CCSprite"):setFlipX(val.x < 0);
	end

	if self.mState == MobObject.IDLE then
		-- find free point on field and move to this point
		local destPoint = self:getDestPoint();
		-- clone field
		local cloneArray = self.mField:cloneArray();
		print ("MobObject:tick destPoint ", destPoint.x, "y ", destPoint.y);
		self.mState = MobObject.MOVING;
		self.mPath = WavePathFinder.buildPath(self.mGridPosition, destPoint, cloneArray, self.mField.mSize);
		table.remove(self.mPath, 1);
		self:moveToNextPoint();
	end
end
