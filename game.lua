Game = function(w,h)
	game = {};
	game.canvas = love.graphics.newCanvas(w,h);
	game.canvas:setFilter("nearest","nearest");
	--rooms

	
	game.flags = {}; --normal flags
	game.eflags = {}; --evidence flags

	game.fadeCanvas = love.graphics.newCanvas(w,h);
	game.fadeMaxFrames = 10; --frames to crossfade
	game.shake = {x=0,y=0};
	
	game.title = TitleScreen();
	game.optionsMenu = OptionsScreen();
	game.pronounsScreen = PronounsScreen();
	game.saveScreen = SaveScreen();
	game.log = Log();
	game.menuMode = true;
	game.menu = game.title;
	game.startTime = 0;
	game.savedTime = 0;
	game.extras = {};
	game.extras.draw = function() end
	sound.playBGM("maintheme");
	
	local evidenceFile = love.filesystem.read("json/evidence.json");
	game.evidenceData = json.decode(evidenceFile).evidence;
	indexByVarName(game.evidenceData,"id");
	
	game.prepareRooms = function(savegame)
		if savegame then
			--game.mainroom = Room("json/mainroom2");
			game.mainroom = Room("mainroom" .. savegame);
			behaviors.roomflicker(game.mainroom);
			game.darkroom = Room("json/darkroom");
			game.darkroom.wrapDark();
			game.room = game.mainroom;
			game.fadingOutRoom = game.room;
			
			
			game.player = PlayerController("star");
			game.room.things.push(game.player);
			
			local savefile = love.filesystem.read("gamedata" .. savegame .. ".json");
			local savedata = json.decode(savefile);
			game.room.camera = savedata.camera;
			game.player.x = savedata.px;
			game.player.y = savedata.py;
			game.player.setAnimation(savedata.playerDir);
			game.eflags = savedata.eflags;
			game.flags = savedata.flags;
			game.savedTime = savedata.playsecs;
			
			game.textbox = Textbox(296,80);
			game.textbox.optionalYPadding = -3;
			game.hypothesis = Hypothesis("hypothesis" .. savegame .. ".json");
			game.inventory = Inventory();
			
			palace.setup();
			for i=1,#(savedata.evidence),1 do
				local savedEvidence = savedata.evidence[i];
				game.inventory.addEvidence(savedEvidence.eid,savedEvidence.alt);
			end
			usedConvoList = ArrayFromRawArray(savedata.used);
			game.player.updateSprite(0,0);
			
			game.convo = Convo("testconvo");	
		else			
			game.flags = {};
			game.eflags = {};
			game.mainroom = Room("json/mainroom2");
			behaviors.roomflicker(game.mainroom);
			game.darkroom = Room("json/darkroom");
			game.darkroom.wrapDark();
			game.room = game.mainroom;
			game.fadingOutRoom = game.room;
			
			game.player = PlayerController("star");
			game.room.things.push(game.player);
			game.textbox = Textbox(296,80);
			game.textbox.optionalYPadding = -3;
			game.hypothesis = Hypothesis("json/hypotheses/test_hypothesis.json");
			game.inventory = Inventory();
			game.convo = Convo("testconvo");
			game.player.x = 220;
			game.player.y = 260;
			game.player.setAnimation("n");
			palace.setup();
		end
		game.startTime = love.timer.getTime();
	end
	
	game.update = function()
		if game.menuMode then
			scriptools.update();
			if game.room then
				game.room.render();
			end
			game.menu.update();
			game.menu.draw();
			return;
		end
		if game.pronounsMode then
			scriptools.update();
			game.pronounsScreen.update();
			game.pronounsScreen.draw();
			return;
		end
		game.room.update();
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
				if (game.room == game.darkroom) and not game.flags["mindVisited"] then
					game.flags["mindVisited"] = true;
					game.player.state = "NOCONTROL";
					runlua("cutscenes/LMtut1.lua");
				end
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
		if game.externalFadeHandle then
			game.externalFadeHandle.drawIt();
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
		game.extras.draw();
		game.textbox.draw();
		game.hypothesis.draw();
		-- portraits["satisfied"].talkingImg.x = 150;
		-- portraits["satisfied"].talkingImg.draw();
		-- portraits["satisfied"].talkingImg.x = 0;
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
			sound.fadeInBGM("wwwwwh");
		else
			game.magicFadeToRoom(game.mainroom);
			sound.fadeInBGM("bgmDemo");
		end
	end
	--sound.playBGM("bgmDemo");
	return game;
end