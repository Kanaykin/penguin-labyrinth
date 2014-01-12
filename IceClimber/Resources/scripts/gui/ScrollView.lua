require "BaseScene"

ScrollView = inheritsFrom(nil)
ScrollView.mScroll = nil;
ScrollView.mClickableChildren = nil;
-- private members. don't use it on the outside
ScrollView.mIsMoved = false;

------------------------------
function ScrollView:addChild(child)
	self.mScroll:addChild(child);
end

------------------------------
function ScrollView:findChildByPoint(point)
	for i, childinfo in ipairs(self.mClickableChildren) do
		local child = childinfo[1];
		print("i ", i, "child ", table.getn(self.mClickableChildren));
		local xPos, yPos = child:getPosition();
		local size = child:getContentSize();
		local bbox = child:boundingBox();
		if bbox:containsPoint(point) then
			return childinfo;
		end
	end
	return nil;
end

------------------------------
function ScrollView:onTouchHandler(action, position)
	local offset = self.mScroll:getContentOffset();
    if action == "began" then
    	self.mIsMoved = false;
    elseif action == "moved" then
    	self.mIsMoved = true;
    elseif action == "ended" and not self.mIsMoved then
    	local locinfo = self:findChildByPoint(CCPointMake(position.x - offset.x, position.y - offset.y ));
    	if(locinfo ~= nil) then
    		locinfo[2][locinfo[3]](locinfo[2]);
    	end
    end
end

------------------------------
function ScrollView:setClickable(clickable)
	local scrollviewlayer = self.mScroll:getContainer();
	local scrollView = self;
	if clickable then
		--------------------
		local function onTouchHandler(action, var)
			print("onTouchHandler ", action, "x = ", var[1], " y = ", var[2]);
    		scrollView:onTouchHandler(action, CCPointMake(var[1], var[2]));
    	end

    	scrollviewlayer:registerScriptTouchHandler(onTouchHandler, true, -1, false);
	else
		scrollviewlayer:unregisterScriptTouchHandler();
	end
	scrollviewlayer:setTouchEnabled(clickable);
end

------------------------------
function ScrollView:addClickableChild(child, obj, callback)
	self.mScroll:addChild(child);
	table.insert(self.mClickableChildren, {child, obj, callback});
end

------------------------------
function ScrollView:init(sizeScale, images)
	self.mClickableChildren = {};
	local visibleSize = CCDirector:sharedDirector():getVisibleSize();
	local scrollviewlayer = CCLayer:create();
	scrollviewlayer:setContentSize(CCSizeMake(visibleSize.width * sizeScale.width, visibleSize.height * sizeScale.height));

	self.mScroll = CCScrollView:create(CCSizeMake(visibleSize.width, visibleSize.height), scrollviewlayer);
	self.mScroll:setBounceable(false);
	self.mScroll:setZoomScale(3.0, false);

	local textureOffset = 0;
	-- add images to view scroll
	for i, imageName in ipairs(images) do
		local sp1 = CCSprite:create(imageName);
		print("sp1 ", sp1, " name ", imageName);
		if not sp1 then 
			break;
		end
		scrollviewlayer:addChild(sp1);
		local imageSize = sp1:getContentSize();
		local scale = visibleSize.height / imageSize.height;
		sp1:setPosition(textureOffset + imageSize.width / 2 * scale, visibleSize.height / 2);
		textureOffset = textureOffset + imageSize.width * scale;
		sp1:setScaleY(scale);
		sp1:setScaleX(scale);
	end

end
