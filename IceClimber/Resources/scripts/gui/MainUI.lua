require "CCBBaseDlg"
require "SettingsDlg"

MainUI = inheritsFrom(CCBBaseDialog)

MainUI.mJoystick = nil;
MainUI.mFightButton = nil;

MainUI.SETTINGS_MENU_TAG = 50;
MainUI.SETTINGS_MENU_ITEM_TAG = 51;


--------------------------------
function MainUI:onSettingsButtonPressed(val, val2)
	print("onSettingsButtonPressed ", val, val2);

	self.mSettingsDlg:doModal();
end

--------------------------------
function MainUI:init(dialogManager, uiLayer, ccbFile)
	self:superClass().init(self, dialogManager, uiLayer, ccbFile);

	self.mJoystick = Joystick:create();
	self.mJoystick:init(self.mNode);

	self.mFightButton = FightButton:create();
	self.mFightButton:init(self.mNode);

	local settingsButton = self.mNode:getChildByTag(MainUI.SETTINGS_MENU_TAG);
	if settingsButton then
		local settingsItem = settingsButton:getChildByTag(MainUI.SETTINGS_MENU_ITEM_TAG);
		
		settingsItem = tolua.cast(settingsItem, "CCMenuItem");
		print("MainUI:settingsItem ", settingsItem);
		if settingsItem then
			local function onSettingsButtonPressed(val, val2)
    			self:onSettingsButtonPressed(val, val2);
    		end

    		settingsItem:registerScriptTapHandler(onSettingsButtonPressed);
    	end
	end

	-------------------------
	self.mSettingsDlg = SettingsDlg:create();
	self.mSettingsDlg:init(self.mDialogManager, self.mUILayer, "SettingsDlg");
end
