require "Inheritance"

DialogManager = inheritsFrom(nil)
DialogManager.mModalDlg = nil;

--------------------------------------
function DialogManager:activateModal(dlg)
	self.mModalDlg = dlg;
end

--------------------------------------
function DialogManager:deactivateModal(dlg)
	self.mModalDlg = nil;
end

--------------------------------------
function DialogManager:hasModalDlg()
	return self.mModalDlg ~= nil;
end