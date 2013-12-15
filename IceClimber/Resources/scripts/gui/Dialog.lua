require "Inheritance"

BaseDialog = inheritsFrom(nil)

---------------------------------
function BaseDialog:show(scene)

	print("BaseDialog:show ", scene.mGuiLayer);

	local sprite = CCScale9Sprite:create("status_frame.png");
	sprite:setPreferredSize(CCSizeMake(400,320));
	sprite:setInsetLeft(15);
	sprite:setInsetRight(15);
	sprite:setInsetTop(15);
	sprite:setInsetBottom(15);

	local closeButtonItem = CCMenuItemImage:create("close_button.png", "close_button_pressed.png");
	local closeButton = CCMenu:createWithItem(closeButtonItem);

	local layer = scene.mGuiLayer;
	local function onCloseButtonPressed()
    	print("onCloseButtonPressed");
    	layer:removeChild(sprite, true);
    end

    closeButtonItem:registerScriptTapHandler(onCloseButtonPressed);

	sprite:addChild(closeButton);
	setPosition(closeButton, Coord(1.0, 1.0, 0, 0));

	scene.mGuiLayer:addChild(sprite);

	setPosition(sprite, Coord(0.5, 0.5, 0, 0));
end