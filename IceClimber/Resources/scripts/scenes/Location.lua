require "Inheritance"

Location = inheritsFrom(nil)
Location.mVisualNode = nil; -- image
Location.mOpened = false;
Location.mData = nil; -- static data of locations

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
function Location:init(locationData)
	self.mData = locationData;
	-- check preferences
	if(locationData.opened ~= nil ) then
		self.mOpened = locationData.opened; 
	end
end
