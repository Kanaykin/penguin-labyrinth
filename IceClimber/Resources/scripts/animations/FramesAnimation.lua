require "EmptyAnimation"

FramesAnimation = inheritsFrom(EmptyAnimation)
FramesAnimation.mAnimation = nil;
FramesAnimation.mAction = nil;

--------------------------------
function FramesAnimation:destroy()
	FramesAnimation:superClass().destroy(self);
	self.mAction:release();
end

----------------------------
function FramesAnimation:play()
	FramesAnimation:superClass().play(self);

	self.mNode:runAction(self.mAction);
end

--------------------------------
function FramesAnimation:init(textureName, frames, node, texture, anchor)

	FramesAnimation:superClass().init(self, texture, node, anchor);
	
	self.mAnimation = CCAnimation:create();

	for i = 1, frames do
		local fullName = textureName..tostring(i)..".png";
		print("PlayerObject:createAnimation ", fullName);
		self.mAnimation:addSpriteFrameWithFileName(fullName);
	end
	self.mAnimation:setDelayPerUnit(1 / 10);
	self.mAnimation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(self.mAnimation);
	self.mAction = CCRepeatForever:create(action);

	self.mAction:retain();
end
