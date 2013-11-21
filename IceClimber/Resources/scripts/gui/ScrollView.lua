require "BaseScene"

ScrollView = inheritsFrom(nil)
ScrollView.mScroll = nil;

------------------------------
function ScrollView:addChild(child)
	self.mScroll:addChild(child);
end

------------------------------
function ScrollView:init(sizeScale, images)
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
		scrollviewlayer:addChild(sp1);
		local imageSize = sp1:getContentSize();
		local scale = visibleSize.height / imageSize.height;
		sp1:setPosition(textureOffset + imageSize.width / 2 * scale, visibleSize.height / 2);
		textureOffset = textureOffset + imageSize.width * scale;
		sp1:setScaleY(scale);
		sp1:setScaleX(scale);
	end

end
