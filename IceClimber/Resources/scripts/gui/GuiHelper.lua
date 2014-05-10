
function setMenuCallback(nodeBase, menuTag, menuItemTag, callback)
	local settingsButton = nodeBase:getChildByTag(menuTag);
	if settingsButton then
		local settingsItem = settingsButton:getChildByTag(menuItemTag);
		
		settingsItem = tolua.cast(settingsItem, "CCMenuItem");
		print("SettingsDlg:init ", settingsItem);
		if settingsItem then
    		settingsItem:registerScriptTapHandler(callback);
    	end
	end
end