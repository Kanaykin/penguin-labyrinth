require "CCBBaseDlg"

YouWinDlg = inheritsFrom(CCBBaseDialog)

YouWinDlg.BASE_NODE_TAG = 49;
YouWinDlg.WORK_PLACE = 72;
YouWinDlg.REPLAY_MENU_TAG = 70;
YouWinDlg.REPLAY_MENU_ITEM_TAG = 71;
YouWinDlg.CHOOSE_LEVEL_MENU_TAG = 60;
YouWinDlg.CHOOSE_LEVEL_MENU_ITEM_TAG = 61;
YouWinDlg.NEXT_LEVEL_MENU_TAG = 80;
YouWinDlg.NEXT_LEVEL_MENU_ITEM_TAG = 81;

--------------------------------
function YouWinDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "VictoryDlg");

	self:initGuiElements();
end

--------------------------------
function YouWinDlg:doModal()
	print("YouWinDlg:doModal");
	self:superClass().doModal(self);
	self.mAnimator:runAnimationsForSequenceNamed("Default Timeline");
end

--------------------------------
function YouWinDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	print("onChooseLevelPressed ");
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, YouWinDlg.CHOOSE_LEVEL_MENU_TAG, YouWinDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function YouWinDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	print("onReplayButtonPressed ");
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, YouWinDlg.REPLAY_MENU_TAG, YouWinDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function YouWinDlg:initNextLevelButton(nodeBase)
	local function onNextLevelPressed(val, val2)
    	print("onNextLevelPressed ");
    	self.mGame.mSceneMan:runNextLevelScene();
    end

    setMenuCallback(nodeBase, YouWinDlg.NEXT_LEVEL_MENU_TAG, YouWinDlg.NEXT_LEVEL_MENU_ITEM_TAG, onNextLevelPressed);
end

--------------------------------
function YouWinDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(YouWinDlg.BASE_NODE_TAG);
	print("YouLooseDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(YouWinDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:boundingBox());

	self.mAnimator = self.mReader:getAnimationManager();

	self:initReplayButton(nodeBase);
	self:initChooseLevelButton(nodeBase);
	self:initNextLevelButton(nodeBase);
end