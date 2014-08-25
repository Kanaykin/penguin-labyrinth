require "Inheritance"

BaseObject = inheritsFrom(nil)
BaseObject.mNode = nil;
BaseObject.mField = nil;

--------------------------------
function BaseObject:destroyNode()
	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		self.mNode:release();
		self.mNode = nil;
	end
end

---------------------------------
function BaseObject:onStateWin()
end

---------------------------------
function BaseObject:getScreenPos()
	local point = self.mNode:convertToWorldSpace(CCPointMake(0, 0)); --self.mField:fieldToScreen(Vector.new(self.mNode:getPosition()));
	return Vector.new(point.x, point.y);
end

---------------------------------
function BaseObject:getBoundingBox()
	return self.mNode:boundingBox();
end

--------------------------------
function BaseObject:init(field, node)
	self.mNode = node;
	self.mNode:retain();
	self.mField = field;
end

---------------------------------
function BaseObject:destroy()
	self:destroyNode();
end

--------------------------------
function BaseObject:tick(dt)

end