local leo = game.room.thingLookup["leo"];
local destination = {x=180,y=180};
leo.setAnimation("w_move");
scriptools.moveThingOverTime(leo,destination.x-leo.x,destination.y-leo.y,0.9,function()
	leo.setAnimation("nw");
end);