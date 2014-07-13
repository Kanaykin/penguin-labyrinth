require "HunterObject"
require "MobObject"
require "SnareTrigger"
require "FoxObject"
require "DogObject"
require "FinishTrigger"
require "FinishObject"

FactoryObject = {}

FactoryObject.BRICK_TAG = -1;
FactoryObject.DECOR_TAG = 0;
FactoryObject.MOB_TAG = 100;
FactoryObject.PLAYER_TAG = 101;
FactoryObject.PLAYER2_TAG = 102;
FactoryObject.LOVE_CAGE_TAG = 103;
FactoryObject.WEB_TAG = 104;
FactoryObject.FINISH_TAG = 105;

FactoryObject.HUNTER_TAG = 106;
FactoryObject.DOG_TAG = 107;
FactoryObject.FOX_TAG = 108;
FactoryObject.FOX2_TAG = 109;

------------------------------
function FactoryObject:createObject(field, node)
	print("FactoryObject:createObject ", field, ", ", node);
	local  tag = node:getTag();
	local func = FactoryObject.CreateFunctions[tag];
	if func then
		return func(self, field, node);
	else
		print("Not found create function for node with tag ", tag);
	end

	return nil;
end

------------------------------
function FactoryObject:createBrick(field, node)
	print("FactoryObject:createBrick ", field, ", ", node);
	field:addBrick(node);
	return node;
end

------------------------------
function FactoryObject:createHunter(field, node)
	print("FactoryObject:createHunter ", field, ", ", node);
	local mob = HunterObject:create();
	mob:init(field, node);
	field:addMob(mob);
	return mob;
end

------------------------------
function FactoryObject:createDog(field, node)
	print("FactoryObject:createDog ", field, ", ", node);
	local mob = DogObject:create();
	mob:init(field, node);
	field:addMob(mob);
	return mob;
end

------------------------------
function FactoryObject:createMob(field, node)
	print("FactoryObject:createMob ", field, ", ", node);
	local mob = MobObject:create();
	mob:init(field, node);
	field:addMob(mob);
	return mob;
end

------------------------------
function FactoryObject:createFinishObject(field, node)
	print("FactoryObject:createFinishObject ", field, ", ", node);
	local obj = FinishObject:create();
	obj:init(field, node);
	field:addObject(obj);
	return obj;
end

------------------------------
function FactoryObject:createWeb(field, node)
	print("FactoryObject:createWeb ", field, ", ", node);
	local web = SnareTrigger:create();
	web:init(field, node, Callback.new(field, Field.onPlayerEnterWeb), Callback.new(field, Field.onPlayerLeaveWeb));
	field:addMob(web);
	return web;
end

------------------------------
function FactoryObject:createFinish(field, node)
	print("FactoryObject:createFinish ", field, ", ", node);
	local finish = FinishTrigger:create();
	finish:init(field, node, nil, nil);
	field:addFinish(finish);
	return finish;
end

------------------------------
function FactoryObject:createPlayer(field, node)
	print("FactoryObject:createPlayer ", field, ", ", node);
	local player = PlayerObject:create(); --PlayerObject:create();
	player:init(field, node, node:getTag() == FactoryObject.PLAYER2_TAG);
	field:addPlayer(player);
	return player;
end

------------------------------
function FactoryObject:createFoxPlayer(field, node)
	print("FactoryObject:createFoxPlayer ", field, ", ", node);
	local player = FoxObject:create(); --PlayerObject:create();
	player:init(field, node, node:getTag() == FactoryObject.FOX2_TAG);
	field:addPlayer(player);
	return player;
end

------------------------------
FactoryObject.CreateFunctions = {
	[FactoryObject.BRICK_TAG] = FactoryObject.createBrick,
	[FactoryObject.MOB_TAG] = FactoryObject.createMob,
	[FactoryObject.HUNTER_TAG] = FactoryObject.createHunter,
	[FactoryObject.DOG_TAG] = FactoryObject.createDog,
	[FactoryObject.WEB_TAG] = FactoryObject.createWeb,
	[FactoryObject.FINISH_TAG] = FactoryObject.createFinish,
	[FactoryObject.PLAYER_TAG] = FactoryObject.createPlayer,
	[FactoryObject.PLAYER2_TAG] = FactoryObject.createPlayer,
	[FactoryObject.FOX_TAG] = FactoryObject.createFoxPlayer,
	[FactoryObject.FOX2_TAG] = FactoryObject.createFoxPlayer,
	[FactoryObject.LOVE_CAGE_TAG] = FactoryObject.createFinishObject
}