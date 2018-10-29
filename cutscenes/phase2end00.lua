game.player.state = "NOCONTROL";
scriptools.doOverTime(0.8,function(percent)
	love.graphics.pushCanvas(game.room.overlaycanvas);
	love.graphics.clear();
	love.graphics.setColor(0,0,0,math.floor(percent*255));
	love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
	love.graphics.popCanvas();
end,function()
	game.player.x = 215;
	game.player.y = 210;
	game.player.setAnimation("n");
	local leo = game.room.thingLookup["leo"];
	leo.x = 221; 
	leo.y = 180;
	leo.setAnimation("s");
	scriptools.doOverTime(0.8,function(percent)
		love.graphics.pushCanvas(game.room.overlaycanvas);
		love.graphics.clear();
		love.graphics.setColor(0,0,0,255-math.floor(percent*255));
		love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
		love.graphics.popCanvas();
	end,function()
		game.convo = Convo("cutscene/phase2end");
		sound.play("evidenceOpen");
		game.player.state = "TEXTBOX";
		game.convo.start();
	end);
end);