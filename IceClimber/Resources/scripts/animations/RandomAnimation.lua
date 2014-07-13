require "Animation"

RandomAnimation = inheritsFrom(IAnimation)

RandomAnimation.mAnimations = nil
RandomAnimation.mCurrentAnimation = nil

--------------------------------
function RandomAnimation:init()
	self.mAnimations = {}
end

--------------------------------
function RandomAnimation:addAnimation(animation)
	self.mAnimations[#self.mAnimations + 1] = animation
end

--------------------------------
function RandomAnimation:tick(dt)
	if self.mCurrentAnimation then
		self.mCurrentAnimation:tick(dt);
	end
	self:playNext();
end

--------------------------------
function RandomAnimation:playNext()
	--print("RandomAnimation:playNext ", not self.mCurrentAnimation or self.mCurrentAnimation:isDone());
	if not self.mCurrentAnimation or self.mCurrentAnimation:isDone() then
		local animNum = math.random (1, #self.mAnimations);
		self.mCurrentAnimation = self.mAnimations[animNum];
		self.mCurrentAnimation:play();
	end
end

--------------------------------
function RandomAnimation:play()
	print("RandomAnimation:play");
	self:playNext();
end
