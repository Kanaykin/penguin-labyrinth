require "Inheritance"

DialogManager = inheritsFrom(nil)
DialogManager.mModalDlg = nil;

--------------------------------------
function DialogManager:setModalDlg(dlg)
	self.mModalDlg = dlg;
end

--------------------------------------
function DialogManager:hasModalDlg()
	return self.mModalDlg ~= nil;
end