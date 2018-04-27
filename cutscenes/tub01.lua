scriptools.doOverTime(0.8,function(percent)
	love.graphics.pushCanvas(game.room.overlaycanvas);
	love.graphics.clear();
	love.graphics.setColor(0,0,0,math.floor(percent*255));
	love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
	love.graphics.popCanvas();
end,function()
	game.room.thingLookup["tub"].img = love.graphics.newImage("images/tub_uncovered.png");
	--move other image
	sound.play("flumph");
	scriptools.doOverTime(0.8,function(percent)
		love.graphics.pushCanvas(game.room.overlaycanvas);
		love.graphics.clear();
		love.graphics.setColor(0,0,0,255-math.floor(percent*255));
		love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
		love.graphics.popCanvas();
	end,function()
		scriptools.wait(0.4,function()
			game.convo = Convo("cutscene/tub02");
			game.player.state = "TEXTBOX";
			game.convo.start();
		end);
	end);
end);