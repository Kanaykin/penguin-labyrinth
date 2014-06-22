require "CCBBaseDlg"
require "SettingsDlg"
require "GuiHelper"
require "YouLooseDlg"

MainUI = inheritsFrom(CCBBaseDialog)

MainUI.mJoystick = nil;
MainUI.mFightButton = nil;
MainUI.mSettingsDlg = nil;
MainUI.mYouLooseDlg = nil;

MainUI.SETTINGS_MENU_TAG = 50;
MainUI.SETTINGS_MENU_ITEM_TAG = 51;

--------------------------------
function MainUI:destroy()
	print("MainUI:destroy");
	self.mSettingsDlg:destroy();
	self.mYouLooseDlg:destroy();

	self:superClass().destroy(self);
end

--------------------------------
function MainUI:onSettingsButtonPressed(val, val2)
	print("onSettingsButtonPressed ", val, val2);

	self.mSettingsDlg:doModal();
end

---------------------------------
function MainUI:onStateLose()
	self.mYouLooseDlg:doModal();
end

--------------------------------
function MainUI:init(game, uiLayer, ccbFile)
	self:superClass().init(self, game, uiLayer, ccbFile);

	self.mJoystick = Joystick:create();
	self.mJoystick:init(self.mNode);

	self.mFightButton = FightButton:create();
	self.mFightButton:init(self.mNode);

	local function onSettingsButtonPressed(val, val2)
    	self:onSettingsButtonPressed(val, val2);
    end
	setMenuCallback(self.mNode, MainUI.SETTINGS_MENU_TAG, MainUI.SETTINGS_MENU_ITEM_TAG, onSettingsButtonPressed);

	-------------------------
	self.mSettingsDlg = SettingsDlg:create();
	self.mSettingsDlg:init(self.mGame, self.mUILayer);

	-------------------------
	self.mYouLooseDlg = YouLooseDlg:create();
	self.mYouLooseDlg:init(self.mGame, self.mUILayer);
end
