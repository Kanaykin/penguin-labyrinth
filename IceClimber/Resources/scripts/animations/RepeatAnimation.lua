require "Animation"

RepeatAnimation = inheritsFrom(IAnimation)

RepeatAnimation.mImpl = nil

RepeatAnimationSoftImpl = inheritsFrom(IAnimation)
RepeatAnimationSoftImpl.mAnimation = nil

--------------------------------
function RepeatAnimationSoftImpl:init(animation)
	local action = animation:getAction();
	local repeatAction = CCRepeatForever:create(action);
	animation:setAction(repeatAction);

	self.mAnimation = animation;
end

----------------------------
function RepeatAnimationSoftImpl:play()
	self.mAnimation:play();
end

---------------------------------
function RepeatAnimationSoftImpl:setStopAfterDone(stopAfterDone)
	
end

---------------------------------
function RepeatAnimationSoftImpl:destroy()
	self.mAnimation:destroy();
end

--------------------------------
function RepeatAnimationSoftImpl:tick(dt)
end

---------------------------------
function RepeatAnimationSoftImpl:isDone()
	return self.mAnimation:isDone();
end

--///////////////////////////////
--------------------------------
RepeatAnimationHardImpl = inheritsFrom(IAnimation)
RepeatAnimationHardImpl.mAnimation = nil
RepeatAnimationHardImpl.mPlaying = false
RepeatAnimationHardImpl.mStopAfterDone = false

--------------------------------
function RepeatAnimationHardImpl:init(animation)
	self.mAnimation = animation;
end

----------------------------
function RepeatAnimationHardImpl:play()
	self.mAnimation:play();
	self.mPlaying = true
end

---------------------------------
function RepeatAnimationHardImpl:destroy()
	self.mAnimation:destroy();
end

---------------------------------
function RepeatAnimationHardImpl:setStopAfterDone(stopAfterDone)
	self.mStopAfterDone = stopAfterDone
end

----------------------------
function RepeatAnimationHardImpl:stop()
	self.mPlaying = false
end

--------------------------------
function RepeatAnimationHardImpl:tick(dt)
	if self.mPlaying and self:isDone() and not self.mStopAfterDone then
		print("RepeatAnimationHardImpl:tick replay ");
		self:play();
	end
end

---------------------------------
function RepeatAnimationHardImpl:isDone()
	return self.mAnimation:isDone();
end

--///////////////////////////////
--------------------------------
function RepeatAnimation:init(animation, soft)
	if soft then
		self.mImpl = RepeatAnimationHardImpl:create();
		self.mImpl:init(animation);
	else
		self.mImpl = RepeatAnimationSoftImpl:create();
		self.mImpl:init(animation);
	end
end

---------------------------------
function RepeatAnimation:isDone()
	return self.mImpl:isDone();
end

----------------------------
function RepeatAnimation:play()
	self.mImpl:play();
end

----------------------------
function RepeatAnimation:stop()
	self.mImpl:stop();
end

---------------------------------
function RepeatAnimation:destroy()
	self.mImpl:destroy();
end

---------------------------------
function RepeatAnimation:setStopAfterDone(stopAfterDone)
	self.mImpl:setStopAfterDone(stopAfterDone);
end

--------------------------------
function RepeatAnimation:tick(dt)
	self.mImpl:tick(dt);
end