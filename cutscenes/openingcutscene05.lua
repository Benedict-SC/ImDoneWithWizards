scriptools.wait(0.4,function()
	game.player.setAnimation("ne");
	local leo = game.room.thingLookup["leo"];
	leo.setAnimation("e");
	local cameraPoint = 
	scriptools.panToThing(game.room.thingLookup["gocorpse"],0.9,{x=0,y=20},function()
		scriptools.wait(1,function()
			scriptools.recenterCamera(0.9,{x=0,y=20},function()
				game.convo = Convo("cutscene/intro02");
				sfx.play(sfx.evidenceOpen);
				game.player.state = "TEXTBOX";
				game.convo.start();
			end);
			scriptools.wait(1,function()
				game.player.setAnimation("n");
				leo.setAnimation("s");
			end);
		end);
	end);
end);