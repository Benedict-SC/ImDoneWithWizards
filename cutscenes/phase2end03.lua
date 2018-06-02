local opal = game.room.thingLookup["opal"];
opal.setAnimation("w_moveback");
scriptools.moveThingOverTime(opal,20,0,0.6,function()
	opal.setAnimation("e");
end);
emotes.exclaim(opal);