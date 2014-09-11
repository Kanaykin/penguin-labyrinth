require "Inheritance"
require "TutorialStep1"
require "TutorialStep2"
require "TutorialStep3"
require "TutorialStep4"
require "TutorialStep5"
require "TutorialStep6"

TutorialManager =  inheritsFrom(nil)
TutorialManager.mCurrentStep = nil;
TutorialManager.mField = nil;
TutorialManager.mGameScene = nil;

--------------------------------
function TutorialManager:init(gameScene, field)
	print("TutorialManager:init()");
	self.mField = field;
	self.mGameScene = gameScene;

	self.mCurrentStep = TutorialStep1:create();
	self.mCurrentStep:init(gameScene, self.mField, self);
end

--------------------------------
function TutorialManager:tick(dt)
	self.mCurrentStep:tick(dt);

	if self.mCurrentStep:finished() then
		local nextStepNext = self.mCurrentStep:getNextStep();
		self.mCurrentStep:destroy();
		self.mCurrentStep = _G[nextStepNext]:create();
		print("TutorialManager:tick nextStepNext ", nextStepNext);
		self.mCurrentStep:init(self.mGameScene, self.mField, self);
	end
end

