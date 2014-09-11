require "TutorialStep1"

TutorialStep2 =  inheritsFrom(TutorialStep1)
TutorialStep2.mCCBFileName = "Step2";
TutorialStep2.mFinishPosition = Vector.new(7, 6);

--------------------------------
function TutorialStep2:init(gameScene, field, tutorialManager)
	TutorialStep2:superClass().init(self, gameScene, field, tutorialManager);
end

--------------------------------
function TutorialStep2:getNextStep()
	return "TutorialStep3";
end