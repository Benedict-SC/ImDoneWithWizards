transitionMenuScreens = function(canv1,canv2,tmenu,left)
	local transitionMenu = {};
	transitionMenu.prog = 0;
	transitionMenu.left = left;
	transitionMenu.c1 = canv1;
	transitionMenu.c2 = canv2;
	transitionMenu.update = function() end
	transitionMenu.draw = function()
		if transitionMenu.left then
			love.graphics.draw(transitionMenu.c1,gamewidth*transitionMenu.prog,0);
			love.graphics.draw(transitionMenu.c2,-gamewidth + (gamewidth*transitionMenu.prog),0);
		else
			love.graphics.draw(transitionMenu.c1,-transitionMenu.prog * gamewidth,0);
			love.graphics.draw(transitionMenu.c2,gamewidth - (transitionMenu.prog * gamewidth),0);
		end
	end
	game.menu = transitionMenu;
	scriptools.doOverTime(0.3,function(percent)
		transitionMenu.prog = percent;
	end,function()
		game.menu = tmenu;
	end);
end
TitleScreen = function()
	local tscreen = {};
	tscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	tscreen.bg = love.graphics.newImage("images/menus/mainmenubg.png");
	tscreen.handy = love.graphics.newImage("images/menus/handy.png");
	tscreen.pos = 0;
	tscreen.mode = "OK";
	tscreen.hasData = false;
	tscreen.handthing = BlankThing();
	local savefile1 = love.filesystem.read("gamedata1.json");
	local savefile2 = love.filesystem.read("gamedata2.json");
	local savefile3 = love.filesystem.read("gamedata3.json");
	if savefile1 or savefile2 or savefile3 then
		tscreen.hasData = true;
	end
	tscreen.options = {
		{text="Continue",does=function()
			if game.title.hasData then
				sound.play("questionBeep");
				local menucanv = love.graphics.newCanvas(gamewidth,gameheight);
				love.graphics.pushCanvas(menucanv);
				tscreen.draw();
				love.graphics.popCanvas();
				local savecanv = love.graphics.newCanvas(gamewidth,gameheight);
				game.saveScreen.filemode = "LOAD";
				game.saveScreen.updateFileInfo();
				love.graphics.pushCanvas(savecanv);
				game.saveScreen.draw();
				love.graphics.popCanvas();
				transitionMenuScreens(menucanv,savecanv,game.saveScreen,true);				
--[[ 
				game.menu = game.saveScreen;
				game.saveScreen.filemode = "LOAD";
				game.saveScreen.updateFileInfo(); ]]
				--[[game.prepareRooms(true);
				game.menuMode = false;
				runlua("cutscenes/temp.lua"); ]]
			else
				sound.play("invalid");
				lifetime.shake(game.title.handthing);
			end
		end},
		{text="New Game",does=function()
			sound.fadeInBGM(nil);
			scriptools.doOverTime(0.3,function(percent)
				game.menuFade = percent;
			end,function()
				game.menuFade = 1;
				game.prepareRooms(false);
				runlua("cutscenes/openingcutscene01.lua");
				game.menuMode = false;
			end);
		end},
		{text="Options",does=function()
			local menucanv = love.graphics.newCanvas(gamewidth,gameheight);
			love.graphics.pushCanvas(menucanv);
			game.title.draw();
			love.graphics.popCanvas();
			local ccanv = love.graphics.newCanvas(gamewidth,gameheight);
			love.graphics.pushCanvas(ccanv);
			game.titleOptions.draw();
			love.graphics.popCanvas();
			transitionMenuScreens(menucanv,ccanv,game.titleOptions,false);
		end},
		{text="Exit",does=function()
			love.event.quit();
		end}
	}
	tscreen.update = function()
		if tscreen.mode == "OK" then
			if pressedThisFrame.up then 
				tscreen.pos = tscreen.pos - 1; 
				sound.play("evidenceScroll");
			end;
			if pressedThisFrame.down then 
				tscreen.pos = tscreen.pos + 1; 
				sound.play("evidenceScroll");
			end;
			tscreen.pos = (tscreen.pos + #(tscreen.options)) % #(tscreen.options);
			
			if pressedThisFrame.action or pressedThisFrame.menu then
				tscreen.options[tscreen.pos + 1].does();
			end;
		end
	end
	tscreen.draw = function()
		love.graphics.pushCanvas(tscreen.canvas);
			love.graphics.draw(tscreen.bg,0,0);
			love.graphics.draw(tscreen.handy,90 + tscreen.handthing.x,101 + (tscreen.pos * 18) + tscreen.handthing.y);
			love.graphics.setFont(loadedFonts["TitleOption"]);
			pushColor();
			love.graphics.setShader(textColorShader);
			
			for i=1, #tscreen.options, 1 do
				if (not tscreen.hasData) and i == 1 then
					love.graphics.setColor(0.5,0.5,0.5);
				else
					love.graphics.setColor(0,0,0);					
				end
				love.graphics.print(tscreen.options[i].text,120,108 + (i-1)*18);				
			end
			--love.graphics.print("Continue",120,66);
			--love.graphics.print("New Game",120,84);
			--love.graphics.print("Options",120,102);
			--love.graphics.print("Exit",120,120);
			love.graphics.setShader();
			popColor();
		love.graphics.popCanvas();
		love.graphics.draw(tscreen.canvas,0,0);
	end
	return tscreen;
end
OptionsScreen = function()
	local oscreen = {};
	oscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	oscreen.bg = love.graphics.newImage("images/menus/bookbg.png");
	oscreen.bgmark = love.graphics.newImage("images/menus/bookmark.png");
	oscreen.handy = love.graphics.newImage("images/menus/handy.png");
	oscreen.handthing = BlankThing();
	oscreen.offsetDown = 240;
	oscreen.mode = "MOVING";
	oscreen.pos = 0;
	oscreen.leftside = false;
	oscreen.quitconfirm = love.graphics.newImage("images/menus/quitconfirm.png");
	oscreen.quityes = false;
	oscreen.options = {
		{text="Control Fate",secondary="(Save game)",does=function()
			--[[ saveGame(); ]]
			game.menu = game.saveScreen;
			game.saveScreen.filemode = "SAVE";
			game.saveScreen.updateFileInfo();
		end},
		{text="Lightningbolt Mind",secondary="(Evidence)",does=function()
			oscreen.fall(function() 
				game.player.state = "NOCONTROL";
				scriptools.wait(0.2,function()
					game.fadeRooms(); 
				end);
			end);
		end},
		{text="Command Perceptions",secondary="(Pronouns)",does=function()
			sound.play("questionBeep");
			game.pronounsScreen.init();
			game.pronounsMode = true;
			game.menuMode = false;
		end},
		{text="Focus Vision",secondary="(Go to fullscreen mode)",does=function()
			local currentcanvas = love.graphics.getCanvas();
			love.graphics.setCanvas();
			if not fullscreen then
				debug_console_string = "todo: fullscreen";	
				love.window.setFullscreen( true );
				game.optionsMenu.windowOpt.text = "Expand Senses";
				game.optionsMenu.windowOpt.secondary = "(Go to windowed mode)";
			else
				debug_console_string = "todo: windowed";	
				love.window.setFullscreen( false );
				game.optionsMenu.windowOpt.text = "Focus Vision";
				game.optionsMenu.windowOpt.secondary = "(Go to fullscreen mode)";
			end
			love.graphics.setCanvas(currentcanvas);
			fullscreen = not fullscreen;
		end},
		{text="Enchanted Silence",secondary="(Mute)",does=function()
			sound.play("questionBeep");
			DEBUG_MUTE = not DEBUG_MUTE;
			if DEBUG_MUTE then
				sound.mute();
				game.optionsMenu.muteOpt.text = "Dispel Silence";
				game.optionsMenu.muteOpt.secondary = "(Unmute)";
			else	
				sound.unmute();
				game.optionsMenu.muteOpt.text = "Enchanted Silence";
				game.optionsMenu.muteOpt.secondary = "(Mute)";
			end
		end},
		{double1="Muffle Noise",double2="Earboost",secondary="(Volume control)",does1=function()
			sound.downGlobalVolume();
			sound.play("questionBeep");
		end,does2=function()
			sound.upGlobalVolume();
			sound.play("questionBeep");
		end},
		{text="Reality Shift",secondary="(Exit to title)",does=function()
			oscreen.mode = "QUIT";
		end}
	}
	oscreen.windowOpt = oscreen.options[4];
	oscreen.muteOpt = oscreen.options[5];
	oscreen.volIndex = 6;
	oscreen.volLeft = true;
	oscreen.update = function()
		if oscreen.mode == "MOVING" then
			return;
		elseif oscreen.mode == "QUIT" then
			if pressedThisFrame.left or pressedThisFrame.right then 
				oscreen.quityes = not oscreen.quityes;
				sound.play("evidenceScroll");
			end
			if pressedThisFrame.action then
				if oscreen.quityes then
					oscreen.mode = "MOVING";
					sound.fadeInBGM(nil);
					scriptools.doOverTime(1.2,function(percent) 
						game.menuFade = percent;
					end,function()
						game.menuFade = 1;
						game.menu = game.title;
						game.title.mode = "LOADING";
						sound.playBGM("maintheme");
						scriptools.doOverTime(0.5,function(percent)
							game.menuFade = 1 - percent;
						end,function() 
							game.menuFade = 0;
							game.title.mode = "OK"; 
						end);	
					end);
				else
					oscreen.mode = "OK";
				end
			end
		else
			if pressedThisFrame.up and not oscreen.leftside then 
				oscreen.pos = oscreen.pos - 1; 
				sound.play("evidenceScroll");
			end
			if pressedThisFrame.down and not oscreen.leftside then 
				oscreen.pos = oscreen.pos + 1; 
				sound.play("evidenceScroll");
			end
			if pressedThisFrame.left then
				if (oscreen.pos+1) == oscreen.volIndex then
					oscreen.volLeft = not oscreen.volLeft;
				else
					oscreen.leftside = true;
				end
			end
			if pressedThisFrame.right then
				if (oscreen.pos+1) == oscreen.volIndex then
					oscreen.volLeft = not oscreen.volLeft;
				else
					oscreen.leftside = false;
				end
			end
			oscreen.pos = (oscreen.pos + #(oscreen.options)) % #(oscreen.options);
			
			if pressedThisFrame.action then
				if oscreen.leftside then
					oscreen.fall();
					oscreen.leftside = false;
				elseif (oscreen.pos + 1) == oscreen.volIndex then
					if oscreen.volLeft then
						oscreen.options[oscreen.pos + 1].does1();
					else
						oscreen.options[oscreen.pos + 1].does2();
					end
				else
					oscreen.options[oscreen.pos + 1].does();
				end
			end
			if pressedThisFrame.menu or pressedThisFrame.cancel then
				oscreen.fall();
			end
		end
	end;
	oscreen.rise = function()
		oscreen.offsetDown = 240;
		oscreen.mode = "MOVING";
		scriptools.doOverTime(0.4,function(percent)
			oscreen.offsetDown = math.floor((240 - (240*percent))+0.5);
		end,function() 
			oscreen.mode = "OK";
			oscreen.offsetDown = 0;
		end);
	end
	oscreen.fall = function(cb)
		oscreen.offsetDown = 0;
		oscreen.mode = "MOVING";
		oscreen.leftside = false;
		scriptools.doOverTime(0.4,function(percent)
			oscreen.offsetDown = math.floor((240*percent)+0.5);
		end,function() 
			oscreen.mode = "OFF";
			oscreen.offsetDown = 240;
			game.menuMode = false;
			if cb then cb(); end
		end);
	end
	oscreen.draw = function()
		love.graphics.pushCanvas(oscreen.canvas);
			love.graphics.clear();
			love.graphics.draw(oscreen.bg,0,-64 + oscreen.offsetDown);
			if oscreen.leftside then
				love.graphics.draw(oscreen.bgmark,0,-64 + oscreen.offsetDown);
			end
			if not oscreen.leftside then
				love.graphics.draw(oscreen.handy,50+oscreen.handthing.x,0 + (oscreen.pos * 25)+oscreen.handthing.y + oscreen.offsetDown);
			end
			pushColor();
			love.graphics.setShader(textColorShader);
				love.graphics.setFont(loadedFonts["TitleOption"]);
				love.graphics.setColor(0,0,0);
				love.graphics.print("Supreme Ultimate Dominion",80,4 + (-1*25) + oscreen.offsetDown);
				love.graphics.setFont(loadedFonts["OpenDyslexicSmall"]);
				love.graphics.print("(Astral Contingency)",180,18 + (-1*25) + oscreen.offsetDown);
				for i=1, #oscreen.options, 1 do
					if i == oscreen.volIndex then
						love.graphics.setFont(loadedFonts["OpenDyslexicBold"]);
						if i == (oscreen.pos + 1) and oscreen.volLeft then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(oscreen.options[i].double1,80,5 + (i-1)*25 + oscreen.offsetDown);
						if i == (oscreen.pos + 1) and not (oscreen.volLeft) then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(oscreen.options[i].double2,191,5 + (i-1)*25 + oscreen.offsetDown);
						if i == (oscreen.pos + 1) then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.setFont(loadedFonts["OpenDyslexicSmall"]);
						love.graphics.print(oscreen.options[i].secondary,180,18 + (i-1)*25 + oscreen.offsetDown);
						
						love.graphics.setShader();
						love.graphics.setColor(0,0,0);
						love.graphics.rectangle("fill",156,10 + (i-1)*25 + oscreen.offsetDown,30,3);
						love.graphics.setColor(0.745,0.31373,0.745);
						love.graphics.rectangle("fill",156,10 + (i-1)*25 + oscreen.offsetDown,30 * sound.unmutedVolume,3);
						love.graphics.setShader(textColorShader);
					else
						love.graphics.setFont(loadedFonts["TitleOption"]);
						if i == (oscreen.pos + 1) and not oscreen.leftside then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
							love.graphics.print(oscreen.options[i].text,80,4 + (i-1)*25 + oscreen.offsetDown);
						if i == (oscreen.pos + 1) and not oscreen.leftside then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.setFont(loadedFonts["OpenDyslexicSmall"]);
						love.graphics.print(oscreen.options[i].secondary,180,18 + (i-1)*25 + oscreen.offsetDown);
					end
				end
			love.graphics.setShader();
			popColor();		
			if oscreen.mode == "QUIT" then
				love.graphics.draw(oscreen.quitconfirm,0,0);
				pushColor();
				love.graphics.setShader(textColorShader);
					love.graphics.setColor(1,1,1);
					love.graphics.setFont(loadedFonts["TitleOption"]);
					love.graphics.print("Exit to title?",104,51);
					love.graphics.setFont(loadedFonts["OpenDyslexic"]);
					love.graphics.print("(Unsaved progress will be lost.)",69,70)
					love.graphics.setFont(loadedFonts["TitleOption"]);
					love.graphics.print("Yes",96,96);
					love.graphics.print("No",170,96);
				love.graphics.setShader();
				popColor();
				local handx = 71;
				if not oscreen.quityes then handx = 142; end
				love.graphics.draw(oscreen.handy,handx,92);
			end
		love.graphics.popCanvas();
		love.graphics.draw(oscreen.canvas,0,0);
	end;
	return oscreen;
end
TOptionsScreen = function()
	local toscreen = {};
	toscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	toscreen.bg = love.graphics.newImage("images/menus/toptionsbg.png");
	toscreen.handy = love.graphics.newImage("images/menus/handy.png");
	toscreen.handthing = BlankThing();
	toscreen.mode = "OK";
	toscreen.pos = 0;
	toscreen.quitconfirm = love.graphics.newImage("images/menus/quitconfirm.png");
	toscreen.quityes = false;
	toscreen.options = {
		{text="Controls",does=function()
			local ccanv = love.graphics.newCanvas(gamewidth,gameheight);
			love.graphics.pushCanvas(ccanv);
			game.controlsScreen.draw();
			love.graphics.popCanvas();
			local ocanv = love.graphics.newCanvas(gamewidth,gameheight);
			love.graphics.pushCanvas(ocanv);
			toscreen.draw();
			love.graphics.popCanvas();
			transitionMenuScreens(ocanv,ccanv,game.controlsScreen,false);
		end},
		{text="Pronouns",does=function()
			sound.play("questionBeep");
			game.pronounsScreen.init();
			game.pronounsMode = true;
			game.menuMode = false;
		end},
		{text="Go fullscreen",does=function()
			local currentcanvas = love.graphics.getCanvas();
			love.graphics.setCanvas();
			if not fullscreen then
				love.window.setFullscreen( true );
				game.titleOptions.windowOpt.text = "Go windowed";
			else
				love.window.setFullscreen( false );
				game.titleOptions.windowOpt.text = "Go fullscreen";
			end
			love.graphics.setCanvas(currentcanvas);
			fullscreen = not fullscreen;
		end},
		{text="Mute",does=function()
			sound.play("questionBeep");
			DEBUG_MUTE = not DEBUG_MUTE;
			if DEBUG_MUTE then
				sound.mute();
				game.titleOptions.muteOpt.text = "Unmute";
			else	
				sound.unmute();
				game.titleOptions.muteOpt.text = "Mute";
			end
		end},
		{double1="Volume -",double2="+ Volume",does1=function()
			sound.downGlobalVolume();
			sound.play("questionBeep");
		end,does2=function()
			sound.upGlobalVolume();
			sound.play("questionBeep");
		end},
		{text="Quit game",does=function()
			toscreen.mode = "QUIT";
		end}
	}
	toscreen.windowOpt = toscreen.options[3];
	toscreen.muteOpt = toscreen.options[4];
	toscreen.volIndex = 5;
	toscreen.volLeft = true;
	toscreen.update = function()
		if toscreen.mode == "MOVING" then
			return;
		elseif toscreen.mode == "QUIT" then
			if pressedThisFrame.left or pressedThisFrame.right then 
				toscreen.quityes = not toscreen.quityes;
				sound.play("evidenceScroll");
			end
			if pressedThisFrame.action or pressedThisFrame.menu then
				if toscreen.quityes then
					love.event.quit();
				else
					toscreen.mode = "OK";
				end
			end
		else
			if pressedThisFrame.up then 
				toscreen.pos = toscreen.pos - 1; 
				sound.play("evidenceScroll");
			end
			if pressedThisFrame.down then 
				toscreen.pos = toscreen.pos + 1; 
				sound.play("evidenceScroll");
			end
			if pressedThisFrame.left then
				if (toscreen.pos+1) == toscreen.volIndex then
					toscreen.volLeft = not toscreen.volLeft;
				end
			end
			if pressedThisFrame.right then
				if (toscreen.pos+1) == toscreen.volIndex then
					toscreen.volLeft = not toscreen.volLeft;
				end
			end
			toscreen.pos = (toscreen.pos + #(toscreen.options)) % #(toscreen.options);
			
			if pressedThisFrame.action or pressedThisFrame.menu then
				if (toscreen.pos + 1) == toscreen.volIndex then
					if toscreen.volLeft then
						toscreen.options[toscreen.pos + 1].does1();
					else
						toscreen.options[toscreen.pos + 1].does2();
					end
				else
					toscreen.options[toscreen.pos + 1].does();
				end
			end
			if pressedThisFrame.cancel then
				local menucanv = love.graphics.newCanvas(gamewidth,gameheight);
				love.graphics.pushCanvas(menucanv);
				game.title.draw();
				love.graphics.popCanvas();
				local ocanv = love.graphics.newCanvas(gamewidth,gameheight);
				love.graphics.pushCanvas(ocanv);
				toscreen.draw();
				love.graphics.popCanvas();
				transitionMenuScreens(ocanv,menucanv,game.title,true);
			end
		end
	end;
	toscreen.draw = function()
		love.graphics.pushCanvas(toscreen.canvas);
			love.graphics.clear();
			love.graphics.draw(toscreen.bg,0,0);
			if toscreen.mode ~= "QUIT" then
				love.graphics.draw(toscreen.handy,56+toscreen.handthing.x + (toscreen.pos*3),40 + (toscreen.pos * 22)+toscreen.handthing.y);
			end
			pushColor();
			love.graphics.setShader(textColorShader);
				for i=1, #(toscreen.options), 1 do
					if i == toscreen.volIndex then
						love.graphics.setFont(loadedFonts["OpenDyslexicBold"]);
						if i == (toscreen.pos + 1) and toscreen.volLeft then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(toscreen.options[i].double1,105,45 + (i-1)*22);
						if i == (toscreen.pos + 1) and not (toscreen.volLeft) then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(toscreen.options[i].double2,201,45 + (i-1)*22);
						
						love.graphics.setShader();
						love.graphics.setColor(0,0,0);
						love.graphics.rectangle("fill",165,50 + (i-1)*22,30,3);
						love.graphics.setColor(0.745,0.31373,0.745);
						love.graphics.rectangle("fill",165,50 + (i-1)*22,30 * sound.unmutedVolume,3);
						love.graphics.setShader(textColorShader);
					else
						love.graphics.setFont(loadedFonts["TitleOption"]);
						if i == (toscreen.pos + 1) then
							love.graphics.setColor(0.745,0.31373,0.745);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(toscreen.options[i].text,86+(i*3),44 + (i-1)*22);
					end
				end
			popColor();		
			love.graphics.setShader();
			if toscreen.mode == "QUIT" then
				love.graphics.draw(toscreen.quitconfirm,0,0);
				pushColor();
				love.graphics.setShader(textColorShader);
					love.graphics.setColor(1,1,1);
					love.graphics.setFont(loadedFonts["TitleOption"]);
					love.graphics.print("Exit game?",104,51);
					love.graphics.setFont(loadedFonts["OpenDyslexic"]);
					love.graphics.print("(Unsaved progress will be lost.)",69,70)
					love.graphics.setFont(loadedFonts["TitleOption"]);
					love.graphics.print("Yes",96,96);
					love.graphics.print("No",170,96);
				love.graphics.setShader();
				popColor();
				local handx = 71;
				if not toscreen.quityes then handx = 142; end
				love.graphics.draw(toscreen.handy,handx,92);
			end
		love.graphics.popCanvas();
		love.graphics.draw(toscreen.canvas,0,0);
	end;
	return toscreen;
end
SaveScreen = function()
	local sscreen = {};
	sscreen.savebg = love.graphics.newImage("images/menus/savebg.png");
	sscreen.loadbg = love.graphics.newImage("images/menus/loadbg2.png");
	sscreen.statics = love.graphics.newImage("images/menus/savestatics.png");
	sscreen.closelabel = love.graphics.newImage("images/menus/close.png");
	sscreen.selector = love.graphics.newImage("images/menus/saveSelector.png");
	sscreen.gray = love.graphics.newImage("images/menus/saveGray.png");
	sscreen.autobutton = love.graphics.newImage("images/menus/autosave.png");
	sscreen.autoselect = love.graphics.newImage("images/menus/autoselector.png");
	sscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	sscreen.pos = 0;
	sscreen.filemode = "LOAD";
	sscreen.autosaveExists = false;
	sscreen.autoplaytime = "0:00";
	sscreen.options = {
		{text="File 1",playtime="0:00",phase=0,progression=0,active=false},
		{text="File 2",playtime="0:00",phase=0,progression=0,active=false},
		{text="File 3",playtime="0:00",phase=0,progression=0,active=false},
	}
	sscreen.updateFileInfo = function()
		local p1list = {"A03","BC03","D03","E02","E03"};
		local p2list = {"A03","B00","C01","D04","E02","E03"};
		local p3list = {"G02","H00","I02","J03"};
		local p4list = {"K00","L03","M07"};
		for i=1,3,1 do
			local savefile = love.filesystem.read("gamedata" .. i .. ".json");
			local hypfile = love.filesystem.read("hypothesis" .. i .. ".json");
			local bothfound = savefile and hypfile;
			if bothfound then
				sscreen.options[i].active = true;
				local savedata = json.decode(savefile);
				if savedata.playsecs then 
					local playmins = math.floor(savedata.playsecs / 60);
					local playhrs = math.floor(playmins / 60);
					playmins = playmins % 60;
					if playmins < 10 then 
						playmins = "0" .. playmins
					end
					sscreen.options[i].playtime = "" .. playhrs .. ":" .. playmins;
				end
				local hypdata = json.decode(hypfile);
				local hcount = 0;
				if savedata.flags["phase4"] then
					sscreen.options[i].phase = 4;
					for j=1,#(hypdata.fragments),1 do
						if contains(p4list,hypdata.fragments[j]) then
							hcount = hcount + 1;
						end
					end
					sscreen.options[i].progression = hcount/3;
				elseif savedata.flags["phase3"] then
					sscreen.options[i].phase = 3;
					for j=1,#(hypdata.fragments),1 do
						if contains(p3list,hypdata.fragments[j]) then
							hcount = hcount + 1;
						end
					end
					sscreen.options[i].progression = hcount/4;
				elseif savedata.flags["phase2"] then
					sscreen.options[i].phase = 2;
					for j=1,#(hypdata.fragments),1 do
						if contains(p2list,hypdata.fragments[j]) then
							hcount = hcount + 1;
						end
					end
					sscreen.options[i].progression = hcount/5;
				else
					sscreen.options[i].phase = 1;
					for j=1,#(hypdata.fragments),1 do
						if contains(p1list,hypdata.fragments[j]) then
							hcount = hcount + 1;
						end
					end
					sscreen.options[i].progression = hcount/4;
				end
			end
		end
		local autosavefile = love.filesystem.read("gamedata4.json");
		local autosavehyp = love.filesystem.read("hypothesis4.json");
		sscreen.autosaveExists = autosavefile and autosavehyp;
		if sscreen.autosaveExists then 
			local autodata = json.decode(autosavefile);
			if autodata.playsecs then 
				local playmins = math.floor(autodata.playsecs / 60);
				local playhrs = math.floor(playmins / 60);
				playmins = playmins % 60;
				if playmins < 10 then 
					playmins = "0" .. playmins
				end
				sscreen.autoplaytime = "" .. playhrs .. ":" .. playmins;
			end
		end
	end;
	sscreen.update = function()
		--debug_console_string_2 = sscreen.pos;
		if pressedThisFrame.up then 
			sscreen.pos = sscreen.pos - 1; 
			sound.play("evidenceScroll");
		end;
		if pressedThisFrame.down then 
			sscreen.pos = sscreen.pos + 1; 
			sound.play("evidenceScroll");
		end;
		if sscreen.filemode == "SAVE" then
			sscreen.pos = (sscreen.pos + #(sscreen.options)) % #(sscreen.options);
		else
			sscreen.pos = (sscreen.pos + (#(sscreen.options) + 1)) % (#(sscreen.options)+1);
		end
		
		if pressedThisFrame.action or pressedThisFrame.menu then
			if sscreen.filemode == "SAVE" then
				if sscreen.pos ~= 3 then
					sscreen.saveToFile(sscreen.pos+1);
				else
					sound.play("invalid");
				end
			else
				sscreen.loadFile(sscreen.pos+1);
			end
		end;
		if pressedThisFrame.cancel then
			if sscreen.filemode == "SAVE" then
				game.menu = game.optionsMenu;
			else
				local menucanv = love.graphics.newCanvas(gamewidth,gameheight);
				love.graphics.pushCanvas(menucanv);
				game.title.draw();
				love.graphics.popCanvas();
				local savecanv = love.graphics.newCanvas(gamewidth,gameheight);
				love.graphics.pushCanvas(savecanv);
				sscreen.draw();
				love.graphics.popCanvas();
				transitionMenuScreens(savecanv,menucanv,game.title,false);
			end
		end;
	end
	sscreen.draw = function()
		love.graphics.pushCanvas(sscreen.canvas);
			if sscreen.filemode == "SAVE" then
				love.graphics.draw(sscreen.savebg,0,0);
			else
				love.graphics.draw(sscreen.loadbg,0,0);
			end
			love.graphics.draw(sscreen.statics,0,0);
			love.graphics.draw(sscreen.autobutton,0,0);
			local autofont = loadedFonts["InlineTiny"];
			pushColor();
				love.graphics.setShader(textColorShader);
				love.graphics.setColor(0.4745,0.4745,0.4745);
				love.graphics.setFont(autofont);
				love.graphics.print(sscreen.autoplaytime,175,0);
				love.graphics.setShader();
			popColor();
			local lfont = loadedFonts["ButtonLabels"];
            love.graphics.setFont(lfont);
			local changewidth = lfont:getWidth(" " .. capitalize(keyControls.action[1]));
			local exitwidth = lfont:getWidth(" " .. capitalize(keyControls.cancel[1]));
            love.graphics.printf(" " .. capitalize(keyControls.action[1]),263-changewidth,4,100,"left");
			love.graphics.printf(" " .. capitalize(keyControls.cancel[1]),4,4,100,"left");
			love.graphics.draw(sscreen.closelabel,4+exitwidth,0);
			if sscreen.pos ~= 3 then
				love.graphics.draw(sscreen.selector,0,20 + (sscreen.pos*51));
			else
				love.graphics.draw(sscreen.autoselect,0,0);
			end
			for i=1, #(sscreen.options), 1 do		
				pushColor();
				love.graphics.setShader(textColorShader);
					love.graphics.setColor(0.4745,0.4745,0.4745);
					love.graphics.setFont(loadedFonts["OpenDyslexic"]);
					love.graphics.print("Playtime: " .. sscreen.options[i].playtime,77,31+((i-1)*51))
				love.graphics.setShader();
				love.graphics.setColor(1,0,1);
				for j=1, sscreen.options[i].phase, 1 do
					love.graphics.ellipse("fill",87+(j-1)*41,52+((i-1)*51),4,4);
					if j > 1 then
						love.graphics.rectangle("fill",87+(j-2)*41,51+((i-1)*51),41,2);
					end
				end
				if sscreen.options[i].phase >= 1 then
					love.graphics.rectangle("fill",87+(sscreen.options[i].phase-1)*41,51+((i-1)*51),(sscreen.options[i].progression)*41,2);
					popColor();
				else
					popColor();
					love.graphics.draw(sscreen.gray,0,20 + ((i-1)*51));
				end
			end
		love.graphics.popCanvas();
		love.graphics.draw(sscreen.canvas,0,0);
	end
	sscreen.loadFile = function(fileno)
		if (sscreen.pos ~= 3) and (sscreen.options[fileno].active) then
			sound.fadeInBGM(nil);
			scriptools.doOverTime(0.3,function(percent)
				game.menuFade = percent;
			end,function()
				game.menuFade = 1;
				game.prepareRooms(fileno);	
			end)
		elseif sscreen.pos == 3 and sscreen.autosaveExists then
			sound.fadeInBGM(nil);
			scriptools.doOverTime(0.3,function(percent)
				game.menuFade = percent;
			end,function()
				game.menuFade = 1;
				game.prepareRooms(fileno);	
			end)
		else
			sound.play("invalid");
		end
	end
	sscreen.saveToFile = function(fileno)
		saveGame(fileno);
		game.saveScreen.updateFileInfo();
	end
	return sscreen;
end