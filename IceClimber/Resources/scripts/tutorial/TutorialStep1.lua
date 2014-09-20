require "TutorialStepBase"

TutorialStep1 =  inheritsFrom(TutorialStepBase)
TutorialStep1.mPlayer = nil;
TutorialStep1.FREE_TIME = 2.0;
TutorialStep1.mCurrentFingerTime = nil;
TutorialStep1.mFinishPosition = Vector.new(10, 6);
TutorialStep1.mCCBFileName = "Step1";
TutorialStep1.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_1;
TutorialStep1.mTrigger = nil;--FactoryObject.TUTORIAL_TRIGGER_1;

---------------------------------
function TutorialStep1:destroy()
	print("TutorialStep1:destroy()");

	TutorialStep1:superClass().destroy(self);
end

--------------------------------
function TutorialStep1:getNextStep()
	return "TutorialStep2";
end

--------------------------------
function TutorialStep1:onBeginAnimationFinished()
	print("TutorialStep1:onBeginAnimationFinished");
	self.mCurrentFingerTime = TutorialStep1.FREE_TIME;
end

--------------------------------
function TutorialStep1:onTouchHandler()
	self.mCurrentFingerTime = 0;
	self.mFinger:stop();
end

--------------------------------
function TutorialStep1:init(gameScene, field, tutorialManager)
	TutorialStep1:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mPlayer = self.mField:getPlayerObjects()[2];

	self.mTrigger = self.mField:getObjetcByTag(self.mTriggerTag);
	print("TutorialStep1:init self.mTrigger ", self.mTrigger);

	self:initFinger(gameScene, field);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
end

--------------------------------
function TutorialStep1:tick(dt)
	self.mFinger:tick(dt);

	if self.mCurrentFingerTime ~= nil then
		-- check finished
		if self.mTrigger:getContainedObj() ~= nil then
			print("TutorialStep1:tick FINISH Step");
			self.mIsFinished = true;
		end

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() then
			self.mFinger:move(self:getPlayerPos(), self.mFinishPosition);
		end
	end
end
