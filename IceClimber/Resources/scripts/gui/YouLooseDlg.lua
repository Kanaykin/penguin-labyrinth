require "CCBBaseDlg"

YouLooseDlg = inheritsFrom(CCBBaseDialog)

YouLooseDlg.BASE_NODE_TAG = 49;
YouLooseDlg.LAYER_TAG = 50;
YouLooseDlg.CHOOSE_LEVEL_MENU_TAG = 60;
YouLooseDlg.CHOOSE_LEVEL_MENU_ITEM_TAG = 61;
YouLooseDlg.REPLAY_MENU_TAG = 70;
YouLooseDlg.REPLAY_MENU_ITEM_TAG = 71;
YouLooseDlg.WORK_PLACE = 72;
YouLooseDlg.mAnimator = nil;

--------------------------------
function YouLooseDlg:doModal()
	self:superClass().doModal(self);
	self.mAnimator:runAnimationsForSequenceNamed("Default Timeline");
end

--------------------------------
function YouLooseDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "YouLooseDlg");

	self:initGuiElements();
end

--------------------------------
function YouLooseDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	print("onReplayButtonPressed ");
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, YouLooseDlg.REPLAY_MENU_TAG, YouLooseDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function YouLooseDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	print("onChooseLevelPressed ");
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, YouLooseDlg.CHOOSE_LEVEL_MENU_TAG, YouLooseDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function YouLooseDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(YouLooseDlg.BASE_NODE_TAG);
	print("YouLooseDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(YouLooseDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:boundingBox());

	self.mAnimator = self.mReader:getAnimationManager();

	self:initReplayButton(nodeBase);
	self:initChooseLevelButton(nodeBase);
end