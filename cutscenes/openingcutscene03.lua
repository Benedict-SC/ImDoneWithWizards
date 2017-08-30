scriptools.wait(1.5,function()
	sfx.play(sfx.phoneRing);
	scriptools.wait(3.1,function() 
		game.convo = Convo("cutscene/landlord2");
		sfx.play(sfx.evidenceOpen);
		game.player.state = "TEXTBOX";
		game.convo.start();
	end);
end);