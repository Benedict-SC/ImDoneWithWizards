local opal = game.room.thingLookup["opal"];
opal.setAnimation("e");
emotes.exclaim(opal,nil,function()
	opal.setAnimation("e_move");
	scriptools.moveThingOverTime(opal,-20,0,0.6,function()
		opal.setAnimation("e");
	end);
end);