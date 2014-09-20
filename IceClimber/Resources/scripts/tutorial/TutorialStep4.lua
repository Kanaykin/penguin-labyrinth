require "TutorialStep1"

TutorialStep4 =  inheritsFrom(TutorialStep1)
TutorialStep4.mCCBFileName = "Step4";
TutorialStep4.mFinishPosition = Vector.new(10, 6);
TutorialStep4.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_1;

--------------------------------
function TutorialStep4:init(gameScene, field, tutorialManager)
	TutorialStep4:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
end

--------------------------------
function TutorialStep4:getNextStep()
	return "TutorialStep5";
end