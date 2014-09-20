require "TutorialStep1"

TutorialStep5 =  inheritsFrom(TutorialStep1)
TutorialStep5.mCCBFileName = "Step5";
TutorialStep5.mFinishPosition = Vector.new(9, 6);
TutorialStep5.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_3;

--------------------------------
function TutorialStep5:init(gameScene, field, tutorialManager)
	TutorialStep5:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
end

--------------------------------
function TutorialStep5:getNextStep()
	return "TutorialStep6";
end