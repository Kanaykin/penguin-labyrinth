require "Inheritance"

BaseObject = inheritsFrom(nil)
BaseObject.mNode = nil;
BaseObject.mField = nil;

--------------------------------
function BaseObject:destroyNode()
	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		self.mNode = nil;
	end
end

--------------------------------
function BaseObject:init(field, node)
	self.mNode = node;
	self.mField = field;
end

---------------------------------
function BaseObject:destroy()
	
end

--------------------------------
function BaseObject:tick(dt)

end