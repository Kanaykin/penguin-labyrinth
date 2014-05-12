require "Inheritance"

DialogManager = inheritsFrom(nil)
DialogManager.mModalDlg = nil;

--------------------------------------
function DialogManager:isModal(dlg)
	print("DialogManager:isModal ", self.mModalDlg == dlg)
	return self.mModalDlg == dlg;
end

--------------------------------------
function DialogManager:activateModal(dlg)
	print("DialogManager:activateModal")
	self.mModalDlg = dlg;
end

--------------------------------------
function DialogManager:deactivateModal(dlg)
	print("DialogManager:deactivateModal");
	self.mModalDlg = nil;
end

--------------------------------------
function DialogManager:hasModalDlg()
	return self.mModalDlg ~= nil;
end