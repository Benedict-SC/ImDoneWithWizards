local leo = game.room.thingLookup["leo"];
leo.setAnimation("w");
emotes.sweatdrop(leo,{x=10,y=6},function()
	scriptools.wait(0.5,function()
		leo.setAnimation("s");
	end);
	game.convo = Convo("cutscene/intro05");
	sound.play("evidenceOpen");
	game.player.state = "TEXTBOX";
	game.convo.start();
end);