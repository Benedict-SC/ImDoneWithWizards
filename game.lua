Game = function(w,h)
	game = {};
	game.canvas = love.graphics.newCanvas(w,h);
	game.canvas:setFilter("nearest","nearest");
	--rooms

	
	game.flags = {}; --normal flags
	game.eflags = {}; --evidence flags

	game.fadeCanvas = love.graphics.newCanvas(w,h);
	game.fadeMaxFrames = 10; --frames to crossfade
	
	game.title = TitleScreen();
	game.optionsMenu = OptionsScreen();
	game.menuMode = true;
	game.menu = game.title;
	sfx.playBGM(sfx.maintheme);
	
	local evidenceFile = love.filesystem.read("json/evidence.json");
	game.evidenceData = json.decode(evidenceFile).evidence;
	indexByVarName(game.evidenceData,"id");
	
	game.prepareRooms = function(savegame)
		if savegame then
			--game.mainroom = Room("json/mainroom2");
			game.mainroom = Room("mainroom");
			game.darkroom = Room("json/darkroom");
			game.room = game.mainroom;
			game.fadingOutRoom = game.room;
			
			
			game.player = PlayerController("star");
			game.room.things.push(game.player);
			
			local savefile = love.filesystem.read("gamedata.json");
			local savedata = json.decode(savefile);
			game.room.camera = savedata.camera;
			game.player.x = savedata.px;
			game.player.y = savedata.py;
			game.player.setAnimation(savedata.playerDir);
			game.eflags = savedata.eflags;
			game.flags = savedata.flags;
			
			game.textbox = Textbox(296,80);
			game.hypothesis = Hypothesis("hypothesis.json");
			game.inventory = Inventory();
			
			palace.setup();
			for i=1,#(savedata.evidence),1 do
				local savedEvidence = savedata.evidence[i];
				game.inventory.addEvidence(savedEvidence.eid,savedEvidence.alt);
			end
			usedConvoList = ArrayFromRawArray(savedata.used);
			
			game.convo = Convo("testconvo");	
		else			
			game.flags = {};
			game.eflags = {};
			game.mainroom = Room("json/mainroom2");
			game.darkroom = Room("json/darkroom");
			game.room = game.mainroom;
			game.fadingOutRoom = game.room;
			
			game.player = PlayerController("star");
			game.room.things.push(game.player);
			game.textbox = Textbox(296,80);
			game.hypothesis = Hypothesis("json/hypotheses/test_hypothesis.json");
			game.inventory = Inventory();
			game.convo = Convo("testconvo");
			game.player.x = 220;
			game.player.y = 260;
			game.player.setAnimation("n");
		end
	end
	
	game.update = function()
		if game.menuMode then
			scriptools.update();
			game.menu.update();
			game.menu.draw();
			return;
		end
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
		scriptools.update();
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
		game.room.camera = game.fadingOutRoom.camera;
		game.room.restorePlayer();
		game.player.state = "NOCONTROL";
	end
	game.fadeRooms = function()
		if game.room == game.mainroom then
			game.magicFadeToRoom(game.darkroom);
			sfx.fadeInNewBGM(1,sfx.wwwwwh);
		else
			game.magicFadeToRoom(game.mainroom);
			sfx.fadeInNewBGM(1,sfx.bgmDemo);
		end
	end
	--sfx.playBGM(sfx.bgmDemo);
	return game;
end