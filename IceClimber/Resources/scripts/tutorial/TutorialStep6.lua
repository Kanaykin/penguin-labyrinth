require "TutorialStep1"

TutorialStep6 =  inheritsFrom(TutorialStep1)
TutorialStep6.mCCBFileName = "Step6";

--------------------------------
function TutorialStep6:init(gameScene, field, tutorialManager)
	TutorialStep6:superClass().init(self, gameScene, field, tutorialManager);
end

--------------------------------
function TutorialStep6:onBeginAnimationFinished()
end

--------------------------------
function TutorialStep6:onTouchHandler()
end