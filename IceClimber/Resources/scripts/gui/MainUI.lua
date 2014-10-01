require "CCBBaseDlg"
require "SettingsDlg"
require "GuiHelper"
require "YouLooseDlg"
require "YouWinDlg"

MainUI = inheritsFrom(CCBBaseDialog)

MainUI.mJoystick = nil;
MainUI.mFightButton = nil;
MainUI.mSettingsDlg = nil;
MainUI.mYouLooseDlg = nil;
MainUI.mYouWinDlg = nil;
MainUI.mTimeLabel = nil;

MainUI.SETTINGS_MENU_TAG = 50;
MainUI.SETTINGS_MENU_ITEM_TAG = 51;

MainUI.TIMER_TAG = 30;

--------------------------------
function MainUI:getJoystick()
	return self.mJoystick;
end

--------------------------------
function MainUI:getFightButton()
	return self.mFightButton;
end

--------------------------------
function MainUI:destroy()
	print("MainUI:destroy");
	self.mSettingsDlg:destroy();
	self.mYouLooseDlg:destroy();
	self.mYouWinDlg:destroy();

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

---------------------------------
function MainUI:onStateWin()
	self.mJoystick:release();
	self.mYouWinDlg:doModal();
end

--------------------------------
function MainUI:setTouchListener(listener)
	local function onTouchHandler(action, var)
		print("MainUI:onTouchHandler ", action);
		return listener:onTouchHandler(action, var);
    end

    local layer = tolua.cast(self.mNode, "CCLayer");
    layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
    layer:setTouchEnabled(true);

end

--------------------------------
function MainUI:setTimerEnabled(val)
	self.mTimeLabel:setVisible(val);
end


--------------------------------
function MainUI:setTime(time)
	if time < 0 then
		time = 0
	end
	local second = math.floor(time);
	local minute = math.floor(second / 60)
	self.mTimeLabel:setString(tostring(minute)..":"..string.format("%02d", (second - minute * 60)));
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

	-------------------------
	self.mYouWinDlg = YouWinDlg:create();
	self.mYouWinDlg:init(self.mGame, self.mUILayer);

	-------------------------
	self.mTimeLabel = tolua.cast(self.mNode:getChildByTag(MainUI.TIMER_TAG), "CCLabelTTF");
	self.mTimeLabel:setVisible(false);
end
