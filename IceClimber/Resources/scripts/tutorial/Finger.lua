require "Inheritance"
require "MovableObject"

Finger =  inheritsFrom(MovableObject)

Finger.mVelocity = 100;
Finger.mIsMoving = false;
Finger.mAnimator = nil;
Finger.mDestPos = nil;

--------------------------------
function Finger:init(gameScene, field)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("Finger", reader, false);

	field:getFieldNode():addChild(node);
	--gameScene:addChild(node);
	Finger:superClass().init(self, field, node);

	local animator = reader:getAnimationManager();
	self.mAnimator = animator;

	---------
	function callbackHideFinish()
		print("Finger callbackHideFinish");
		self.mIsMoving = false;
	end

	local callFuncHide = CCCallFunc:create(callbackHideFinish);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFuncHide, "0:HideFinish");
	---------

	---------
	function callbackShowFinish()
		print("Finger callbackShowFinish");
		self:moveTo(self.mDestPos);
	end

	local callFuncShow = CCCallFunc:create(callbackShowFinish);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFuncShow, "0:ShowFinish");
	---------

	---------
	function callbackDoubleTapFinish()
		print("Finger callbackDoubleTapFinish");
		self.mIsMoving = false;
	end

	local callFuncDoubleTap = CCCallFunc:create(callbackDoubleTapFinish);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFuncDoubleTap, "0:DoubleTapfinish");
	---------
end

--------------------------------
function Finger:playDoubleTapAnimation()
	self.mAnimator:runAnimationsForSequenceNamed("doubleTap");
	self.mIsMoving = true;
end

--------------------------------
function Finger:stop()
	self:stopMoving();
	print("Finger:stop ", self.mAnimator:getRunningSequenceName());
	if self:IsMoving() and self.mAnimator:getRunningSequenceName() ~= "Hide" then
		self.mAnimator:runAnimationsForSequenceNamed("Hide");
	end
end

--------------------------------
function Finger:IsMoving()
	return self.mIsMoving;
end

--------------------------------
function Finger:move(from, to)
	self.mIsMoving = true;
	self.mDestPos = to;

	self:setGrigPos(from);

	self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function Finger:onMoveFinished( )
	-- body
	self.mAnimator:runAnimationsForSequenceNamed("Hide");
end

--------------------------------
function Finger:setGrigPos(gridPos)
	local dest = self.mField:gridPosToReal(gridPos);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;

	self:setPosition(dest);
end

--------------------------------
function Finger:setPosition(position)
	self.mNode:setPosition(CCPointMake(position.x, position.y));
	self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
end

--------------------------------
function Finger:tick(dt)
	Finger:superClass().tick(self, dt);
end

--------------------------------
function Finger:updateOrder()
end