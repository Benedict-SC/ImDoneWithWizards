scriptools.movePlayerOverTime(-24,-8,0.5,function()
	game.player.setAnimation("w");
	scriptools.doOverTime(0.8,function(percent)
		love.graphics.pushCanvas(game.room.overlaycanvas);
		love.graphics.clear();
		love.graphics.setColor(0,0,0,math.floor(percent*255));
		love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
		love.graphics.popCanvas();
	end,function()
		game.room.eliminateThingByName("sheet");
		sound.play("flumph");
		scriptools.doOverTime(0.8,function(percent)
			love.graphics.pushCanvas(game.room.overlaycanvas);
			love.graphics.clear();
			love.graphics.setColor(0,0,0,255-math.floor(percent*255));
			love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
			love.graphics.popCanvas();
		end,function()
			scriptools.wait(0.4,function()
				game.player.setAnimation("n");
				game.convo = Convo("cutscene/intro04");
				sound.play("evidenceOpen");
				game.player.state = "TEXTBOX";
				game.convo.start();
			end);
		end);
	end);
end);