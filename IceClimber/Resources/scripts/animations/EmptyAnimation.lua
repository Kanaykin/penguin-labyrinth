require "Animation"

EmptyAnimation = inheritsFrom(IAnimation)
EmptyAnimation.mTexture = nil;
EmptyAnimation.mAnchor = nil;
EmptyAnimation.mNode = nil;
EmptyAnimation.mTextureSize = nil;

--------------------------------
function EmptyAnimation:init(texture, node, anchor)
	self.mNode = node;
	self.mTexture = texture;
	self.mAnchor = anchor;
	self.mTextureSize = self.mNode:getContentSize();
	print("EmptyAnimation:init ", self.mTextureSize.width, ", ", self.mTextureSize.height);
end

--------------------------------
function EmptyAnimation:getAction()
	return nil;
end

--------------------------------
function EmptyAnimation:getNode()
	return self.mNode;
end

---------------------------------
function EmptyAnimation:isDone()
	return true;
end

----------------------------
function EmptyAnimation:play()
	if self.mAnchor then
		self.mNode:setAnchorPoint(self.mAnchor);
	end
	if self.mTexture then
		print("EmptyAnimation:play self.mNode ", self.mNode);
		print("EmptyAnimation:play self.mTextureSize ", self.mTextureSize.width);
		tolua.cast(self.mNode, "CCSprite"):setTexture(self.mTexture);
		tolua.cast(self.mNode, "CCSprite"):setTextureRect(CCRectMake(0, 0, self.mTextureSize.width, self.mTextureSize.height));
	end
end