require "TutorialStep1"

TutorialStep5 =  inheritsFrom(TutorialStep1)
TutorialStep5.mCCBFileName = "Step5";
TutorialStep5.mFinishPosition = Vector.new(9, 6);

--------------------------------
function TutorialStep5:init(gameScene, field, tutorialManager)
	TutorialStep5:superClass().init(self, gameScene, field, tutorialManager);
end

--------------------------------
function TutorialStep5:getNextStep()
	return "TutorialStep6";
end