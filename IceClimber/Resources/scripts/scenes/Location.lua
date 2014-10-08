require "Inheritance"
require "Dialog"
require "Level"

Location = inheritsFrom(nil)
Location.mVisualNode = nil; -- image
Location.mOpened = false;
Location.mData = nil; -- static data of locations
Location.mGame = nil;
Location.mLevels = {};


---------------------------------
function Location:onLocationPressed()
	print("onLocationPressed opened ", self.mOpened);
	if not self.mOpened then
		local dlg = BaseDialog:create();
		dlg:show(self.mGame.mSceneMan:getCurrentScene());
	else
		print("show levels");
		self.mGame.mSceneMan:runNextScene({location = self});
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
function Location:getLevels()
	return self.mLevels;
end

---------------------------------
function Location:getPosition()
	return self.mData.position;
end

---------------------------------
function Location:getId()
	return self.mData.id;
end

---------------------------------
function Location:initLevels(locationData)
	if type(locationData.levels) == "table" then
		for i, levelData in ipairs(locationData.levels) do
			local level = Level:create();
			level:init(levelData, self, i);
			table.insert(self.mLevels, level);
		end
	end
end

---------------------------------
function Location:init(locationData, game)
	self.mData = locationData;
	self.mGame = game;
	-- check preferences
	if(locationData.opened ~= nil ) then
		self.mOpened = locationData.opened; 
	end

	self:initLevels(locationData);
end
