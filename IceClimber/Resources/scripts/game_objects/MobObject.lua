require "MovableObject"
require "WavePathFinder"

MobOject = inheritsFrom(MovableObject)

MobOject.IDLE = 1;
MobOject.MOVING = 2;

MobOject.mState = MobOject.IDLE;
MobOject.mPath = nil;

--------------------------------
function MobOject:init(field, node)
	print("MobOject:init(", node, ")");
	MobOject:superClass().init(self, field, node);

	self.mState = MobOject.IDLE;
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

	if self.mState == MobOject.IDLE then
		-- find free point on field and move to this point
		local destPoint = self:getDestPoint();
		-- clone field
		local cloneArray = self.mField:cloneArray();
		print ("destPoint ", destPoint.x, "y ", destPoint.y);
		self.mState = MobOject.MOVING;
		self.mPath = WavePathFinder.buildPath(self.mGridPosition, destPoint, cloneArray, self.mField.mSize);
		table.remove(self.mPath, 1);
		self:moveToNextPoint();
	end
end
