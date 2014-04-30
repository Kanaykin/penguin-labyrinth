require "Inheritance"

CCBBaseDialog = inheritsFrom(nil)

CCBBaseDialog.mNode = nil;
CCBBaseDialog.mUILayer = nil;
CCBBaseDialog.mReader = nil;
CCBBaseDialog.mDialogManager = nil;

---------------------------------
function CCBBaseDialog:destroy()
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
	self.mDialogManager:activateModal(self);
end

--------------------------------
function CCBBaseDialog:init(dialogManager, uiLayer, ccbFile)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbFile, reader, false);

	uiLayer:addChild(node);

	self.mNode = node;
	self.mUILayer = uiLayer;
	self.mReader = reader;
	self.mNode:setVisible(false);
	self.mDialogManager = dialogManager;
end
