require "Animation"

DelayAnimation = inheritsFrom(IAnimation)

DelayAnimation.mAnimation = nil

--------------------------------
function DelayAnimation:init(animation, delay)
	local action = animation:getAction();
	local delayAction = CCDelayTime:create(delay);
	local seq = CCSequence:createWithTwoActions(delayAction, action);

	animation:setAction(seq);

	self.mAnimation = animation;
end

---------------------------------
function DelayAnimation:isDone()
	return self.mAnimation:isDone();
end

----------------------------
function DelayAnimation:play()
	self.mAnimation:play();
end

---------------------------------
function DelayAnimation:destroy()
	self.mAnimation:destroy();
end