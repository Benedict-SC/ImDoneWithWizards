emotes.exclaim(game.player,{x=0,y=5});
game.player.setAnimation("n");
scriptools.wait(0.1,function()
	local leo = game.room.thingLookup["leo"];
	leo.setAnimation("sw");
end);
scriptools.recenterCamera(1,{x=0,y=20});