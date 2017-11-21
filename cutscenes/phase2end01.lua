scriptools.panToPoint({x=35,y=220},0.8,function()
	local camOffsets = {x=215-game.player.x,y=210-game.player.y};
	game.player.x = 215;
	game.player.y = 210;
	game.room.camera.x = math.floor(game.room.camera.x - camOffsets.x + 0.5);
	game.room.camera.y = math.floor(game.room.camera.y - camOffsets.y + 0.5);
	game.player.setAnimation("w");
	local leo = game.room.thingLookup["leo"];
	leo.x = 221; 
	leo.y = 180;
	leo.setAnimation("sw");
	scriptools.wait(1,function()
		scriptools.panToPoint({x=105,y=206},0.8);
	end);
end);