require "CCBBaseDlg"
require "GuiHelper"

SettingsDlg = inheritsFrom(CCBBaseDialog)

SettingsDlg.mAnimator = nil;
SettingsDlg.BASE_NODE_TAG = 49;
SettingsDlg.BACK_MENU_TAG = 50;
SettingsDlg.BACK_MENU_ITEM_TAG = 51;
SettingsDlg.REPLAY_MENU_TAG = 70;
SettingsDlg.REPLAY_MENU_ITEM_TAG = 71;

--------------------------------
function SettingsDlg:doModal()
	self:superClass().doModal(self);

	self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function SettingsDlg:hidePanel()
	function callback()
		print("SettingsDlg:callback");
		self.mDialogManager:deactivateModal(self);
	end

	local callFunc = CCCallFunc:create(callback);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

	self.mAnimator:runAnimationsForSequenceNamed("Hide");
end

--------------------------------
function SettingsDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	print("onReplayButtonPressed ");
    end

    setMenuCallback(nodeBase, SettingsDlg.REPLAY_MENU_TAG, SettingsDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
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
end

--------------------------------
function SettingsDlg:init(dialogManager, uiLayer, ccbFile)
	self:superClass().init(self, dialogManager, uiLayer, ccbFile);

	self:initGuiElements();

	self.mAnimator = self.mReader:getAnimationManager();
	--local arrayAnimator = self.mReader:getAnimationManagersForNodes();

	print("SettingsDlg:init ", self.mAnimator);
end