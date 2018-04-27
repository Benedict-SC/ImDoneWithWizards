scriptools.wait(3,function()
	game.player.state = "NOCONTROL";
	sound.play("fireAlarm");
	scriptools.wait(3.53,function()
		sound.playBGM("halfpasttwo");
	end);
	scriptools.wait(2,function() 
		game.convo = Convo("cutscene/landlord1");
		sound.play("evidenceOpen");
		game.player.state = "TEXTBOX";
		game.convo.start();
	end);
end);
