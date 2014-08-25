require "BaseScene"

FieldNode = inheritsFrom(BaseScene)
FieldNode.mNodes = nil;
FieldNode.mSize = nil;
FieldNode.mChildren = nil;
FieldNode.mLayer = nil;

--------------------------------
function FieldNode:addChild(node)
	self.mLayer:addChild(node);
end

--------------------------------
function FieldNode:getContentSize()
	return self.mSize;
end

--------------------------------
function FieldNode:getChildren()
	return self.mChildren;
end

--------------------------------
function FieldNode:getScrollPos()
	if self.mScrollView.getContentOffset then
		local point = self.mScrollView:getContentOffset();
		return Vector.new(point.x, point.y);
	end
end

--------------------------------
function FieldNode:setScrollPos(pos)
	--print("FieldNode:setScrollPos ");
	if self.mScrollView.setContentOffset then
		self.mScrollView:setContentOffset(CCPointMake(0, -pos.y));
	end
end

--------------------------------
function FieldNode:init(nodes, layer, field)
	self.mNodes = nodes;
	self.mChildren = CCArray:create();
	self.mScrollView = layer;

	local height = 0;
	local width = 0;
	for i, node in ipairs(nodes) do
		local children = node:getChildren();
		local count = children:count();
		for i = 1, count do
			local child = tolua.cast(children:objectAtIndex(i - 1), "CCNode");
			local x, y = child:getPosition();
			y = y + height;
			child:setPosition(x, y);
			self.mChildren:addObject(child);
		end

		local layerSize = node:getContentSize();
		
		height = height + layerSize.height;
		width = math.max(width, layerSize.width);

		--[[if children then
			self.mChildren:addObjectsFromArray(children);
		end]]
	end

	self.mSize = CCSizeMake(width, height);
	local newLayer = CCLayer:create();
	newLayer:setContentSize(self.mSize);
	self.mLayer = newLayer;

	layer:addChild(newLayer);
	if #nodes ~= 0 then
		local posX, posY = nodes[1]:getPosition();
		local anchor = nodes[1]:getAnchorPoint();
		local size = nodes[1]:getContentSize();
		posX, posY = posX - anchor.x * size.width, posY - anchor.y * size.height;
		print(" !!!!! ", size.width, size.height);
		newLayer:setPosition(posX, posY);
		--newLayer:setAnchorPoint(nodes[1]:getAnchorPoint());
	end

	-- move to new layers
	local count = self.mChildren:count();
	for i = 1, count do
		local child = tolua.cast(self.mChildren:objectAtIndex(i - 1), "CCNode");
		child:getParent():removeChild(child, false);
		local posGridX, posGridY = field:getGridPosition(child);
		print("posGridY ", posGridY);
		newLayer:addChild(child, -posGridY * 2);
		
		--child:setVertexZ(-posGridY);
	end
end