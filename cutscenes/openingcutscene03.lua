scriptools.wait(1.5,function()
	sound.play("phoneRing");
	scriptools.wait(3.1,function() 
		game.convo = Convo("cutscene/landlord2");
		sound.play("evidenceOpen");
		game.player.state = "TEXTBOX";
		game.convo.start();
	end);
end);