require "Inheritance"
require "Dialog"

Location = inheritsFrom(nil)
Location.mVisualNode = nil; -- image
Location.mOpened = false;
Location.mData = nil; -- static data of locations
Location.mGame = nil; 

---------------------------------
function Location:onLocationPressed()
	print("onLocationPressed opened ", self.mOpened);
	if not self.mOpened then
		local dlg = BaseDialog:create();
		dlg:show(self.mGame.mSceneMan:getCurrentScene());
	else
		print("show levels");
		self.mGame.mSceneMan:runNextScene();
	end
end

---------------------------------
function Location:isOpened()
	return self.mOpened;
end

---------------------------------
function Location:getImage()
	return self.mData.image;
end

---------------------------------
function Location:getPosition()
	return self.mData.position;
end

---------------------------------
function Location:init(locationData, game)
	self.mData = locationData;
	self.mGame = game;
	-- check preferences
	if(locationData.opened ~= nil ) then
		self.mOpened = locationData.opened; 
	end
end
