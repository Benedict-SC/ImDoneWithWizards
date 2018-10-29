scriptools.doOverTime(0.8,function(percent)
	love.graphics.pushCanvas(game.room.overlaycanvas);
	love.graphics.clear();
	love.graphics.setColor(0,0,0,math.floor(percent*255));
	love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
	love.graphics.popCanvas();
end,function()
	local table = game.room.thingLookup["table"];
	table.filepath = "images/table3.png";
	table.img = love.graphics.newImage(table.filepath);
	table.liteImg = table.img;
	table.darkImg = behaviors.darktable;
	--move player into position
	game.player.x = 131;
	game.player.y = 153;
	game.player.setAnimation("n");
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