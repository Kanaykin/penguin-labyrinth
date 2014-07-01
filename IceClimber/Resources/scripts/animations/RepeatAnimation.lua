require "Animation"

RepeatAnimation = inheritsFrom(IAnimation)

RepeatAnimation.mAnimation = nil

--------------------------------
function RepeatAnimation:init(animation)
	local action = animation:getAction();
	local repeatAction = CCRepeatForever:create(action);
	animation:setAction(repeatAction);

	self.mAnimation = animation;
end

----------------------------
function RepeatAnimation:play()
	self.mAnimation:play();
end

---------------------------------
function RepeatAnimation:destroy()
	self.mAnimation:destroy();
end