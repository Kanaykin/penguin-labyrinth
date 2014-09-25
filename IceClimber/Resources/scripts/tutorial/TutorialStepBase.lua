require "Inheritance"
require "Finger"

TutorialStepBase =  inheritsFrom(nil)
TutorialStepBase.mFinger = nil
TutorialStepBase.mField = nil;
TutorialStepBase.mTutorialManager = nil
TutorialStepBase.mIsFinished = false
TutorialStepBase.mNode = nil;

---------------------------------
function TutorialStepBase:destroy()
	if self.mFinger then
		self.mFinger:destroy();
		self.mFinger = nil;
	end

	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		--self.mNode:release();
		self.mNode = nil;
	end
end

--------------------------------
function TutorialStepBase:onBeginAnimationFinished()
	print("TutorialStepBase:onBeginAnimationFinished");
end

--------------------------------
function TutorialStepBase:initBeginAnimation(animator)
	function callback()
		self:onBeginAnimationFinished();
	end

	local callFunc = CCCallFunc:create(callback);
	animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

	animator:runAnimationsForSequenceNamed("animation");
end

--------------------------------
function TutorialStepBase:onTouchHandler()
end

---------------------------------
function TutorialStepBase:initFromCCB(ccbfile, gameScene)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbfile, reader, false);
	self.mNode = node;

	local animator = reader:getAnimationManager();
	self:initBeginAnimation(animator);

	gameScene:addChild(node);

	local layer = tolua.cast(node, "CCLayer");
	print("TutorialStepBase:init layer ", layer);

	local function onTouchHandler(action, var)
		print("onTouchHandler ");
		self:onTouchHandler();
	end

	layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
	layer:setTouchEnabled(true);

end

--------------------------------
function TutorialStepBase:getPlayerPos()
	local playerGridPosition = Vector.new(self.mField:getGridPosition(self.mPlayer.mNode));
	--[[print("playerGridPosition ", playerGridPosition.x);
	local dest = self.mField:gridPosToReal(playerGridPosition);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;

	return dest;]]
	return Vector.new(self.mPlayer.mNode:getPosition());
end

--------------------------------
function TutorialStepBase:getPlayerGridPos()
	local playerGridPosition = Vector.new(self.mField:getGridPosition(self.mPlayer.mNode));
	return playerGridPosition;
end

--------------------------------
function TutorialStepBase:tick(dt)
end

--------------------------------
function TutorialStepBase:initFinger(gameScene, field)
	self.mFinger = Finger:create();
	self.mFinger:init(gameScene, field);
end

--------------------------------
function TutorialStepBase:finished()
	return self.mIsFinished;
end

--------------------------------
function TutorialStepBase:init(gameScene, field, tutorialManager, ccbfile)
	self.mField = field;

	self.mTutorialManager = tutorialManager;
	print("TutorialStepBase:init ", self.mTutorialManager );

	self:initFromCCB(ccbfile, gameScene);
end