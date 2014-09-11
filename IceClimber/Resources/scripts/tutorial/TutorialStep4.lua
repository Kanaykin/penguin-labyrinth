require "TutorialStep1"

TutorialStep4 =  inheritsFrom(TutorialStep1)
TutorialStep4.mCCBFileName = "Step4";
TutorialStep4.mFinishPosition = Vector.new(10, 6);

--------------------------------
function TutorialStep4:init(gameScene, field, tutorialManager)
	TutorialStep4:superClass().init(self, gameScene, field, tutorialManager);
end

--------------------------------
function TutorialStep4:getNextStep()
	return "TutorialStep5";
end