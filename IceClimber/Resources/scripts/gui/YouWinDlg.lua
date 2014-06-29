require "CCBBaseDlg"

YouWinDlg = inheritsFrom(CCBBaseDialog)

YouWinDlg.BASE_NODE_TAG = 49;
YouWinDlg.WORK_PLACE = 72;

--------------------------------
function YouWinDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "VictoryDlg");

	self:initGuiElements();
end

--------------------------------
function YouWinDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(YouWinDlg.BASE_NODE_TAG);
	print("YouLooseDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(YouWinDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:boundingBox());
end