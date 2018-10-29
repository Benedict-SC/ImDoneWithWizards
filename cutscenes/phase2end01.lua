scriptools.panToPoint({x=105,y=206},0.8,function()
	game.player.setAnimation("w");
	local leo = game.room.thingLookup["leo"];
	leo.setAnimation("sw");
end);
