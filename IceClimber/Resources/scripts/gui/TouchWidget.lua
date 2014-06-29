require "Inheritance"
require "Vector"

TouchWidget = inheritsFrom(nil)
TouchWidget.mTouchId = nil;
TouchWidget.mBBox = nil;

----------------------------------------
function TouchWidget:convertToPoints(var)
	local array_points = {};
	
	for i = 1, #var, 3 do
		print("onTouchHandler [", var[i + 2], "]=", var[i], ", ", var[i + 1]);
		array_points[var[i + 2]] = Vector.new(var[i], var[i + 1]);
	end

	return array_points;
end

----------------------------------------
function TouchWidget:onTouchBegan(point)
	print("TouchWidget:onTouchBegan ");
end

----------------------------------------
function TouchWidget:onTouchMoved(point)
	print("TouchWidget:onTouchMoved ");
end

----------------------------------------
function TouchWidget:onTouchEnded(point)
	print("TouchWidget:onTouchEnded ");
end

--------------------------------
function findContainPoint(box, arrayPoints)
	for i, point in pairs(arrayPoints) do
		if box:containsPoint(CCPointMake(point.x, point.y)) then
			return i;
		end
	end
	return nil;
end

----------------------------------------
function TouchWidget:release()
	self.mTouchId = nil;
	self:onTouchEnded({0,0});
end

----------------------------------------
function TouchWidget:onTouchHandler(action, var)
	local arrayPoints = self:convertToPoints(var);

	print("TouchWidget.mTouchId ", self.mTouchId);

	if self.mTouchId ~= nil and not arrayPoints[self.mTouchId] then
		return;
	end

	local oldTouchId = self.mTouchId;

	if action == "began" then
		if self.mTouchId == nil then
			local indx = findContainPoint(self.mBBox, arrayPoints);
			self.mTouchId = indx;
		end
	elseif action == "moved" then
		if self.mTouchId == nil then
			local indx = findContainPoint(self.mBBox, arrayPoints);
			self.mTouchId = indx;
		else
			if not self.mBBox:containsPoint(CCPointMake(arrayPoints[self.mTouchId].x, arrayPoints[self.mTouchId].y)) then
				self.mTouchId = nil;
			end
		end
	else
		self.mTouchId = nil;
	end

	if not oldTouchId and self.mTouchId then 
		self:onTouchBegan(arrayPoints[self.mTouchId]);
	elseif oldTouchId and self.mTouchId then
		self:onTouchMoved(arrayPoints[self.mTouchId]);
	elseif oldTouchId and not self.mTouchId then
		self:onTouchEnded(arrayPoints[self.mTouchId]);
	end

end

--------------------------------
function TouchWidget:init(bbox)
	self.mBBox = bbox;
end