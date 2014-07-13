require "Animation"

DelayAnimation = inheritsFrom(IAnimation)

DelayAnimation.mImpl = nil

DelayAnimationSoftImpl = inheritsFrom(IAnimation)
DelayAnimationSoftImpl.mAnimation = nil

--------------------------------
function DelayAnimationSoftImpl:init(animation, delay)
	local action = animation:getAction();
	local delayAction = CCDelayTime:create(delay);
	local seq = CCSequence:createWithTwoActions(delayAction, action);

	animation:setAction(seq);

	self.mAnimation = animation;
end

---------------------------------
function DelayAnimationSoftImpl:isDone()
	return self.mAnimation:isDone();
end

---------------------------------
function DelayAnimationSoftImpl:destroy()
	self.mAnimation:destroy();
end

----------------------------
function DelayAnimationSoftImpl:play()
	--print("DelayAnimation:play")
	self.mAnimation:play();
end

--////////////////////////////////////////
--------------------------------
DelayAnimationHardImpl = inheritsFrom(IAnimation)
DelayAnimationHardImpl.mAnimation = nil
DelayAnimationHardImpl.mCurrentDelay = nil
DelayAnimationHardImpl.mDelay = nil
DelayAnimationHardImpl.mPlaying = false

function DelayAnimationHardImpl:init(animation, delay)
	self.mDelay = delay;
	self.mAnimation = animation;
end

---------------------------------
function DelayAnimationHardImpl:isDone()
	return self.mCurrentDelay and self.mCurrentDelay <= 0 and self.mAnimation:isDone();
end

---------------------------------
function DelayAnimationHardImpl:destroy()
	self.mAnimation:destroy();
end

----------------------------
function DelayAnimationHardImpl:play()
	print("DelayAnimationHardImpl:play")
	self.mCurrentDelay = self.mDelay;
	self.mPlaying = false;
end

--------------------------------
function DelayAnimationHardImpl:tick(dt)
	print("DelayAnimationHardImpl:tick ", self.mCurrentDelay)
	if self.mCurrentDelay then
		
		self.mCurrentDelay = self.mCurrentDelay - dt;
		
		if self.mCurrentDelay <= 0 and not self.mPlaying then
			self.mPlaying = true;
			self.mAnimation:play();
		else
			self.mAnimation:tick(dt);
		end
	end
end

--////////////////////////////////////////
--------------------------------
function DelayAnimation:init(animation, delay)
	if animation:getAction() then
		self.mImpl = DelayAnimationSoftImpl:create();
		self.mImpl:init(animation, delay);
	else 
		self.mImpl = DelayAnimationHardImpl:create();
		self.mImpl:init(animation, delay);
	end
end

--------------------------------
function DelayAnimation:tick(dt)
	self.mImpl:tick(dt);
end

---------------------------------
function DelayAnimation:isDone()
	return self.mImpl:isDone();
end

----------------------------
function DelayAnimation:play()
	--print("DelayAnimation:play")
	--self.mAnimation:play();
	self.mImpl:play();
end

---------------------------------
function DelayAnimation:destroy()
	self.mImpl:destroy();
end