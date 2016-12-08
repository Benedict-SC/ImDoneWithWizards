Game = function(w,h)
	game = {};
	game.canvas = love.graphics.newCanvas(w,h);
	--rooms

	game.mainroom = Room("mainroom");
	game.darkroom = Room("darkroom");
	game.room = game.mainroom;

	game.fadeCanvas = love.graphics.newCanvas(w,h);
	game.fadingOutRoom = game.room;
	game.fadeMaxFrames = 10; --frames to crossfade
	
	local evidenceFile = love.filesystem.read("json/evidence.json");
	game.evidenceData = json.decode(evidenceFile).evidence;
	indexNames(game.evidenceData);

	game.player = PlayerController("testplayer");
	game.room.things.push(game.player);
	game.textbox = Textbox(590,140);
	game.hypothesis = Hypothesis("json/hypotheses/test_hypothesis.json");
	game.inventory = Inventory();
	game.convo = Convo("testconvo");
	game.player.x = 380;
	game.player.y = 650;
	game.update = function()
		if not game.fading then
			game.room.render();
			if DEBUG_SLOW then
				if counter%6 == 0 then
					game.player.update();
				end
			else
				game.player.update();
			end
		else
			--check if we're done
			if game.fadetime <= 0 then
				game.fading = false;
				game.fadetime = 0;
				game.player.state = "MOVING";
			end
			local alpha = 255 * (game.fadetime/game.fadeMaxFrames);
			if alpha > 255 or alpha < 0 then error("bad alpha value"); end
			--fade out old room
			love.graphics.clear();
			love.graphics.pushCanvas(game.fadeCanvas);
			love.graphics.clear();
			love.graphics.setColor(255,255,255);
			game.fadingOutRoom.render();
			love.graphics.popCanvas();

			love.graphics.setColor(255,255,255,alpha);
			love.graphics.draw(game.fadeCanvas);

			--fade in new room
			love.graphics.pushCanvas(game.fadeCanvas);
			love.graphics.clear();
			love.graphics.setColor(255,255,255);
			game.room.render();
			love.graphics.popCanvas();

			love.graphics.setColor(255,255,255,255 - alpha);
			love.graphics.draw(game.fadeCanvas);

			love.graphics.setColor(255,255,255);
			game.fadetime = game.fadetime - 1;
		end
		if DEBUG_SLOW then
			if counter%6 == 0 then
				game.textbox.update();
				game.hypothesis.update();
			end
		else
			game.textbox.update();
			game.hypothesis.update();
		end
		game.textbox.draw();
		game.hypothesis.draw();
	end
	game.magicFadeToRoom = function(newroom)
		game.fading = true;
		game.fadetime = game.fadeMaxFrames;
		game.fadingOutRoom = game.room;
		game.fadingOutRoom.facsimilePlayer();
		game.room = newroom;
		game.room.restorePlayer();
		game.player.state = "NOCONTROL";
	end
	game.fadeRooms = function()
		if game.room == game.mainroom then
			game.magicFadeToRoom(game.darkroom);
		else
			game.magicFadeToRoom(game.mainroom);
		end
	end
	sfx.playBGM(sfx.bgmDemo);
	return game;
end