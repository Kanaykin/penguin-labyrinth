function inheritsFrom( baseClass )
	local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if nil ~= baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    -- Implementation of additional OO properties starts here --

    -- Return the class object of the instance
    function new_class:class()
        return new_class
    end

    -- Return the super class object of the instance
    function new_class:superClass()
        return baseClass
    end

    -- Return true if the caller is an instance of theClass
    function new_class:isa( theClass )
        local b_isa = false

        local cur_class = new_class

        while ( nil ~= cur_class ) and ( false == b_isa ) do
            if cur_class == theClass then
                b_isa = true
            else
                cur_class = cur_class:superClass()
            end
        end

        return b_isa
    end

    return new_class
end

-----------------------------------------
local function search (k, plist)
  for i=1, table.getn(plist) do
    local v = plist[i][k]     -- try `i'-th superclass
    if v then return v end
  end
end

-----------------------------------------
function createClass (...)
  local c = {}        -- new class

  -- class will search for each method in the list of its
  -- parents (`arg' is the list of parents)
  setmetatable(c, {__index = function (t, k)
    return search(k, arg)
  end})

  -- prepare `c' to be the metatable of its instances
  c.__index = c

  -- define a new constructor for this new class
  function c:new (o)
    o = o or {}
    setmetatable(o, c)
    return o
  end

  -- return new class
  return c
end

