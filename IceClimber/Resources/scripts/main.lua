require "Game"

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

-----------------------------------------------
local function main()
	print("lua script started");

	local game = Game:create();
	game:init();
end
xpcall(main, __G__TRACKBACK__)