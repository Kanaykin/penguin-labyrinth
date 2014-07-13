require "BaseObject"
require "Callback"
require "SequenceAnimation"

FinishObject = inheritsFrom(BaseObject)

FinishObject.mFinishAnimation = nil;

--------------------------------
function FinishObject:createAnimation(nameAnimation)
	local texture = CCTextureCache:sharedTextureCache():addImage(nameAnimation);
	texture:retain();

	local anim1 = EmptyAnimation:create(); 
	anim1:init(texture, self.mNode, self.mNode:getAnchorPoint());

	local delayAnim = DelayAnimation:create();
	delayAnim:init(anim1, 1);


	self.mFinishAnimation:addAnimation(delayAnim);
end

--------------------------------
function FinishObject:init(field, node)
	print("FinishObject:init ");
	FinishObject:superClass().init(self, field, node);

	self.mFinishAnimation = SequenceAnimation:create();
	self.mFinishAnimation:init();
	self:createAnimation("love_cage_fox_free.png");
	self:createAnimation("love_cage_fox_free_litle.png");
end

--------------------------------
function FinishObject:tick(dt)
	FinishObject:superClass().tick(self, dt);

	self.mFinishAnimation:tick(dt);
end

---------------------------------
function FinishObject:onStateWin()
	FinishObject:superClass().onStateWin(self);

	self.mFinishAnimation:play();
end