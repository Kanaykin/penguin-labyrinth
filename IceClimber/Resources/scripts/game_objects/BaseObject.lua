require "Inheritance"

BaseObject = inheritsFrom(nil)
BaseObject.mNode = nil;
BaseObject.mField = nil;

--------------------------------
function BaseObject:init(field, node)
	self.mNode = node;
	self.mField = field;
end

--------------------------------
function BaseObject:tick(dt)

end