scriptools.wait(3,function()
	game.player.state = "NOCONTROL";
	sfx.play(sfx.fireAlarm);
	scriptools.wait(3.53,function()
		sfx.fadeInNewBGM(0.05,sfx.halfpasttwo);
	end);
	scriptools.wait(2,function() 
		game.convo = Convo("cutscene/landlord1");
		sfx.play(sfx.evidenceOpen);
		game.player.state = "TEXTBOX";
		game.convo.start();
	end);
end);
