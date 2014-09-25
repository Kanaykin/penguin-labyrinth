require "TutorialStepBase"

TutorialStep3 =  inheritsFrom(TutorialStepBase)
TutorialStep3.mCCBFileName = "Step3";
TutorialStep3.mSecondPlayer = nil;
TutorialStep3.mCurrentFingerTime = nil;
TutorialStep3.FREE_TIME = 2.0;

--------------------------------
function TutorialStep3:init(gameScene, field, tutorialManager)
	TutorialStep3:superClass().init(self, gameScene, field, tutorialManager, "Step3");

	self.mPlayer = self.mField:getPlayerObjects()[2];
	self.mSecondPlayer = self.mField:getPlayerObjects()[1];

	self:initFinger(gameScene, field);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end

--------------------------------
function TutorialStep3:onTouchHandler()
	self.mCurrentFingerTime = 0;
	--self.mFinger:stop();
end

--------------------------------
function TutorialStep3:onBeginAnimationFinished()
	print("TutorialStep3:onBeginAnimationFinished");
	self.mCurrentFingerTime = TutorialStep3.FREE_TIME;
end

--------------------------------
function TutorialStep3:getNextStep()
	return "TutorialStep4";
end

--------------------------------
function TutorialStep3:tick(dt)

	if self.mCurrentFingerTime ~= nil then

		if not self.mSecondPlayer:isInTrap() then
			print("TutorialStep3:tick FINISH Step");
			self.mIsFinished = true;
		end

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() then
			self.mFinger:setPosition(self:getPlayerPos());
			self.mFinger:playDoubleTapAnimation();
		end

	end
end