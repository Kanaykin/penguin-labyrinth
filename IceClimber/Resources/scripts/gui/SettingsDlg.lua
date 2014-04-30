require "CCBBaseDlg"

SettingsDlg = inheritsFrom(CCBBaseDialog)

SettingsDlg.mAnimator = nil;
SettingsDlg.BASE_NODE_TAG = 49;
SettingsDlg.BACK_MENU_TAG = 50;
SettingsDlg.BACK_MENU_ITEM_TAG = 51;

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
function SettingsDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(SettingsDlg.BASE_NODE_TAG);
	print("SettingsDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local settingsButton = nodeBase:getChildByTag(SettingsDlg.BACK_MENU_TAG);
	if settingsButton then
		local settingsItem = settingsButton:getChildByTag(SettingsDlg.BACK_MENU_ITEM_TAG);
		
		settingsItem = tolua.cast(settingsItem, "CCMenuItem");
		print("SettingsDlg:init ", settingsItem);
		if settingsItem then
			local function onPanelHidePressed(val, val2)
    			print("onPanelHidePressed ");
    			self:hidePanel();
    		end

    		settingsItem:registerScriptTapHandler(onPanelHidePressed);
    	end
	end
end

--------------------------------
function SettingsDlg:init(dialogManager, uiLayer, ccbFile)
	self:superClass().init(self, dialogManager, uiLayer, ccbFile);

	self:initGuiElements();

	self.mAnimator = self.mReader:getAnimationManager();
	--local arrayAnimator = self.mReader:getAnimationManagersForNodes();

	print("SettingsDlg:init ", self.mAnimator);
end