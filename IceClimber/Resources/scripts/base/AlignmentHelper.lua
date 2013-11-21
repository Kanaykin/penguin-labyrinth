-- helper functions for computing of position on screen

--[[ it is relative coordinate system
coordinate consists of two relative coordinate x, y and two absolute x, y
]]

----------------------------------
function Coord(inRelX, inRelY, inAbsX, inAbsY)
	return {relX = inRelX, relY = inRelY, absX = inAbsX, absY = inAbsY};
end

----------------------------------
function getPosition(object, pos)
	local parentPos = nil;
	local parentSize = nil;
	local parent = object:getParent();
	if(parent == nil) then
		parentSize = CCDirector:sharedDirector():getVisibleSize();
		parentPos = CCPointMake(0, 0);
	else
		parentSize = parent:getContentSize();
		local xPos, yPos = parent:getPosition();
		parentPos = CCPointMake(xPos, yPos);
	end
	local objSize = object:getContentSize();
	-- compute pos
	local X = parentSize.width * pos.relX + pos.absX;-- + objSize.width / 2.0;
	local Y = parentSize.height * pos.relY + pos.absY;

	return CCPointMake(X, Y);
end

----------------------------------
function setPosition(object, pos)
	object:setPosition(getPosition(object, pos));
end

----------------------------------
function setSize(object, size)
end
