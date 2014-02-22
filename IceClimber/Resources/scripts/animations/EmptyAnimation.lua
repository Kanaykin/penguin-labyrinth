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
end

----------------------------
function EmptyAnimation:play()
	if self.mAnchor then
		self.mNode:setAnchorPoint(self.mAnchor);
	end
	if self.mTexture then
		tolua.cast(self.mNode, "CCSprite"):setTexture(self.mTexture);
		tolua.cast(self.mNode, "CCSprite"):setTextureRect(CCRectMake(0, 0, self.mTextureSize.width, self.mTextureSize.height));
	end
end