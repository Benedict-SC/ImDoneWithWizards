Game = function(w,h)
	game = {};
	game.canvas = love.graphics.newCanvas(w,h);
	game.canvas:setFilter("nearest","nearest");
	--rooms

	
	game.flags = {}; --normal flags
	game.eflags = {}; --evidence flags
	game.altRecords = {}; --evidence alts

	game.fadeCanvas = love.graphics.newCanvas(w,h);
	game.fadeMaxFrames = 10; --frames to crossfade
	game.shake = {x=0,y=0};
	
	game.title = TitleScreen();
	game.optionsMenu = OptionsScreen();
	game.titleOptions = TOptionsScreen();
	game.pronounsScreen = PronounsScreen();
	game.saveScreen = SaveScreen();
	game.controlsScreen = ControlsScreen();
	game.log = Log();
	game.menuMode = true;
	game.menu = game.title;
	game.menuFade = 0;
	game.startTime = 0;
	game.savedTime = 0;
	game.extras = {};
	game.extras.draw = function() end
	loadOptions();
	sound.playBGM("maintheme");
	
	local evidenceFile = love.filesystem.read("json/evidence.json");
	game.evidenceData = json.decode(evidenceFile).evidence;
	indexByVarName(game.evidenceData,"id");
	
	game.prepareRooms = function(savegame)
		
		game.log = Log();
		game.optionsMenu = OptionsScreen();
		if savegame then
			if DEBUG_STARTROOM then
				game.mainroom = Room("json/mainroom2");
			else
				game.mainroom = Room("mainroom" .. savegame);
			end
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
			cheevs.cheevoFlags = savedata.cheevs.cheevoFlags;
			cheevs.goatConvosSeen = ArrayFromRawArray(savedata.cheevs.goatConvosSeen);
			debug_console_string_2 = cheevs.goatConvosSeen.spacedList();
			if savedata.altRecords then
				game.altRecords = savedata.altRecords;
			end
			game.savedTime = savedata.playsecs;
			
			game.textbox = Textbox(296,80);
			game.textbox.optionalYPadding = -3;
			game.hypothesis = Hypothesis("hypothesis" .. savegame .. ".json");
			game.inventory = Inventory();
			
			palace.setup();
			for i=1,#(savedata.evidence),1 do
				local savedEvidence = savedata.evidence[i];
				local ev = game.inventory.addEvidence(savedEvidence.eid,savedEvidence.alt,savedEvidence.active);
				if game.altRecords[savedEvidence.eid] then
					game.inventory.setAlt(savedEvidence.eid,game.altRecords[savedEvidence.eid]);
				end
			end
			usedConvoList = ArrayFromRawArray(savedata.used);
			game.player.updateSprite(0,0);
			
			game.convo = Convo("testconvo");	
			runlua("cutscenes/temp.lua");
		else			
			game.flags = {};
			game.eflags = {};
			game.altRecords = {};
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
		game.menuMode = false;
		scriptools.doOverTime(0.5,function(percent)
			game.menuFade = 255 - (255*percent);
		end,function() game.menuFade = 0; end);	
	end
	
	game.update = function()
		if game.menuMode then
			scriptools.update();
			if game.room then
				game.room.render();
			end
			game.menu.update();
			game.menu.draw();
			if game.menuFade ~= 0 then
				pushColor();
				love.graphics.setColor(0,0,0,game.menuFade);
				love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
				popColor();
			end
			return;
		end
		if game.pronounsMode then
			scriptools.update();
			game.pronounsScreen.update();
			game.pronounsScreen.draw();
			if game.menuFade ~= 0 then
				pushColor();
				love.graphics.setColor(0,0,0,game.menuFade);
				love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
				popColor();
			end
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
				scriptools.wait(0.1,function()
					game.player.state = "MOVING";
					if (game.room == game.darkroom) and not game.flags["mindVisited"] then
						game.flags["mindVisited"] = true;
						game.player.state = "NOCONTROL";
						runlua("cutscenes/LMtut1.lua");
					end
				end);
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
		if game.menuFade ~= 0 then
			pushColor();
			love.graphics.setColor(0,0,0,game.menuFade);
			love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
			popColor();
		end
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