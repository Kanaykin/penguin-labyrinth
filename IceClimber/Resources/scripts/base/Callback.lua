Callback = {}
Callback.__index = Callback

-----------------------------------
function Callback.new(obj, func)
	return setmetatable({ mObj = obj or 0, mFunc = func or 0 }, Callback)
end

-----------------------------------
function Callback.__call(a, ...)
	return a.mFunc(a.mObj, ...);
end

setmetatable(Callback, { __call = function(_, ...) return Callback.new(...) end })