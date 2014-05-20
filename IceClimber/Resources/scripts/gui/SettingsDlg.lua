require "CCBBaseDlg"
require "GuiHelper"

SettingsDlg = inheritsFrom(CCBBaseDialog)

SettingsDlg.mAnimator = nil;
SettingsDlg.BASE_NODE_TAG = 49;
SettingsDlg.BACK_MENU_TAG = 50;
SettingsDlg.BACK_MENU_ITEM_TAG = 51;
SettingsDlg.CHOOSE_LEVEL_MENU_TAG = 60;
SettingsDlg.CHOOSE_LEVEL_MENU_ITEM_TAG = 61;
SettingsDlg.REPLAY_MENU_TAG = 70;
SettingsDlg.REPLAY_MENU_ITEM_TAG = 71;

--------------------------------
function SettingsDlg:doModal()
	self:superClass().doModal(self);

	self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function SettingsDlg:hidePanel()
	print("SettingsDlg:hidePanel");
	function callback()
		print("SettingsDlg:callback");
		self.mGame.mDialogManager:deactivateModal(self);
	end

	local callFunc = CCCallFunc:create(callback);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

	self.mAnimator:runAnimationsForSequenceNamed("Hide");
end

--------------------------------
function SettingsDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	print("onReplayButtonPressed ");
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, SettingsDlg.REPLAY_MENU_TAG, SettingsDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function SettingsDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	print("onChooseLevelPressed ");
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, SettingsDlg.CHOOSE_LEVEL_MENU_TAG, SettingsDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function SettingsDlg:initHideButton(nodeBase)
	local function onPanelHidePressed(val, val2)
    	print("onPanelHidePressed ");
    	self:hidePanel();
    end

    setMenuCallback(nodeBase, SettingsDlg.BACK_MENU_TAG, SettingsDlg.BACK_MENU_ITEM_TAG, onPanelHidePressed);
end

--------------------------------
function SettingsDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(SettingsDlg.BASE_NODE_TAG);
	print("SettingsDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	self:initHideButton(nodeBase);
	self:initReplayButton(nodeBase);
	self:initChooseLevelButton(nodeBase);
end

--------------------------------
function SettingsDlg:init(game, uiLayer, ccbFile)
	self:superClass().init(self, game, uiLayer, ccbFile);

	self:initGuiElements();

	self.mAnimator = self.mReader:getAnimationManager();
	--local arrayAnimator = self.mReader:getAnimationManagersForNodes();

	print("SettingsDlg:init ", self.mAnimator);
end