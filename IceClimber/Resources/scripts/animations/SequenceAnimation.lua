require "Animation"

SequenceAnimation = inheritsFrom(IAnimation)

SequenceAnimation.mAnimations = nil
SequenceAnimation.mCurrentAnimation = nil

--------------------------------
function SequenceAnimation:init()
	self.mAnimations = {}
end

--------------------------------
function SequenceAnimation:addAnimation(animation)
	self.mAnimations[#self.mAnimations + 1] = animation
end

--------------------------------
function SequenceAnimation:tick(dt)
	if self.mCurrentAnimation and self.mAnimations[self.mCurrentAnimation] then
		self.mAnimations[self.mCurrentAnimation]:tick(dt)
		self:playNext();
	end
end

--------------------------------
function SequenceAnimation:playNext()
	local needPlay = false;
	if not self.mCurrentAnimation then
		self.mCurrentAnimation = 1;
		needPlay = true;
	elseif self.mAnimations[self.mCurrentAnimation] and self.mAnimations[self.mCurrentAnimation]:isDone() then
		self.mCurrentAnimation = self.mCurrentAnimation + 1;
		needPlay = true;
	end
	if needPlay and self.mAnimations[self.mCurrentAnimation] then
		self.mAnimations[self.mCurrentAnimation]:play();
	end
end

--------------------------------
function SequenceAnimation:play()
	print("SequenceAnimation:play");
	self:playNext();
end