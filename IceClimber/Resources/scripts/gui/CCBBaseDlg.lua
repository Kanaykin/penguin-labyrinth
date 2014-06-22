require "Inheritance"

CCBBaseDialog = inheritsFrom(nil)

CCBBaseDialog.mNode = nil;
CCBBaseDialog.mUILayer = nil;
CCBBaseDialog.mReader = nil;
CCBBaseDialog.mGame = nil;
CCBBaseDialog.mTouchBBox = nil;

---------------------------------
function CCBBaseDialog:setTouchBBox(box)
	self.mTouchBBox = box;
end

---------------------------------
function CCBBaseDialog:destroy()
	print("CCBBaseDialog:destroy ", self.mGame.mDialogManager:isModal(self));
	if self.mGame.mDialogManager:isModal(self) then 
		self.mGame.mDialogManager:deactivateModal(self);
	end

	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		self.mNode = nil;
	end
end

--------------------------------
function CCBBaseDialog:show()
	self.mNode:setVisible(true);
end

--------------------------------
function CCBBaseDialog:doModal()
	self:show();
	local function onTouchHandler(action, var1, var2)
		print("!!! CCBBaseDialog onTouchHandler ", var1, ", ", var2);
		return not self.mTouchBBox:containsPoint(CCPointMake(var1, var2));
    end

	local layer = tolua.cast(self.mNode, "CCLayer");
    layer:registerScriptTouchHandler(onTouchHandler, false, -128, true);
    layer:setTouchEnabled(true);

	self.mGame.mDialogManager:activateModal(self);
end

--------------------------------
function CCBBaseDialog:init(game, uiLayer, ccbFile)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbFile, reader, false);
	uiLayer:addChild(node);

	self.mNode = node;
	self.mTouchBBox = self.mNode:boundingBox();
	self.mUILayer = uiLayer;
	self.mReader = reader;
	self.mNode:setVisible(false);
	self.mGame = game;
end
