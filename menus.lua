TitleScreen = function()
	local tscreen = {};
	tscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	tscreen.bg = love.graphics.newImage("images/menus/titlebg.png");
	tscreen.handy = love.graphics.newImage("images/menus/handy.png");
	tscreen.pos = 0;
	tscreen.hasData = false;
	tscreen.handthing = BlankThing();
	local savefile = love.filesystem.read("gamedata.json");
	if savefile then
		tscreen.hasData = true;
	end
	tscreen.options = {
		{text="Continue",does=function()
			if game.title.hasData then
				game.prepareRooms(true);
				game.menuMode = false;
				runlua("cutscenes/temp.lua");
			else
				sound.play("invalid");
				lifetime.shake(game.title.handthing);
			end
		end},
		{text="New Game",does=function()
			game.prepareRooms(false);
			runlua("cutscenes/openingcutscene01.lua");
			game.menuMode = false;
			sound.fadeInBGM();
		end},
		{text="Options",does=function()
			sound.play("questionBeep");
			DEBUG_CONSOLE = not DEBUG_CONSOLE;
			DEBUG_COLLIDERS = not DEBUG_COLLIDERS;
		end},
		{text="Exit",does=function()
			love.event.quit();
		end}
	}
	tscreen.update = function()
		if pressedThisFrame.up then 
			tscreen.pos = tscreen.pos - 1; 
			sound.play("evidenceScroll");
		end;
		if pressedThisFrame.down then 
			tscreen.pos = tscreen.pos + 1; 
			sound.play("evidenceScroll");
		end;
		tscreen.pos = (tscreen.pos + #(tscreen.options)) % #(tscreen.options);
		
		if pressedThisFrame.action then
			tscreen.options[tscreen.pos + 1].does();
		end;
	end
	tscreen.draw = function()
		love.graphics.pushCanvas(tscreen.canvas);
			love.graphics.draw(tscreen.bg,0,0);
			love.graphics.draw(tscreen.handy,90 + tscreen.handthing.x,61 + (tscreen.pos * 18) + tscreen.handthing.y);
			love.graphics.setFont(loadedFonts["TitleOption"]);
			pushColor();
			love.graphics.setShader(textColorShader);
			
			for i=1, #tscreen.options, 1 do
				if (not tscreen.hasData) and i == 1 then
					love.graphics.setColor(128,128,128);
				else
					love.graphics.setColor(255,255,255);					
				end
				love.graphics.print(tscreen.options[i].text,120,66 + (i-1)*18);				
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
			saveGame();
		end},
		{text="Lightningbolt Mind",secondary="(Evidence)",does=function()
			debug_console_string = "todo: LM transition";
		end},
		{text="Command Perceptions",secondary="(Pronouns)",does=function()
			sound.play("questionBeep");
			game.pronounsScreen.init();
			game.pronounsMode = true;
			game.menuMode = false;
		end},
		{text="Focus Vision",secondary="(Go to fullscreen mode)",does=function()
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
		{text="Reality Shift",secondary="(Quit game)",does=function()
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
					love.event.quit();
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
	oscreen.fall = function()
		oscreen.offsetDown = 0;
		oscreen.mode = "MOVING";
		oscreen.leftside = false;
		scriptools.doOverTime(0.4,function(percent)
			oscreen.offsetDown = math.floor((240*percent)+0.5);
		end,function() 
			oscreen.mode = "OFF";
			oscreen.offsetDown = 240;
			game.menuMode = false;
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
							love.graphics.setColor(190,80,190);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(oscreen.options[i].double1,80,5 + (i-1)*25 + oscreen.offsetDown);
						if i == (oscreen.pos + 1) and not (oscreen.volLeft) then
							love.graphics.setColor(190,80,190);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.print(oscreen.options[i].double2,191,5 + (i-1)*25 + oscreen.offsetDown);
						if i == (oscreen.pos + 1) then
							love.graphics.setColor(190,80,190);
						else
							love.graphics.setColor(0,0,0);
						end
						love.graphics.setFont(loadedFonts["OpenDyslexicSmall"]);
						love.graphics.print(oscreen.options[i].secondary,180,18 + (i-1)*25 + oscreen.offsetDown);
						
						love.graphics.setShader();
						love.graphics.setColor(0,0,0);
						love.graphics.rectangle("fill",156,10 + (i-1)*25 + oscreen.offsetDown,30,3);
						love.graphics.setColor(190,80,190);
						love.graphics.rectangle("fill",156,10 + (i-1)*25 + oscreen.offsetDown,30 * sound.unmutedVolume,3);
					else
						love.graphics.setFont(loadedFonts["TitleOption"]);
						if i == (oscreen.pos + 1) and not oscreen.leftside then
							love.graphics.setColor(190,80,190);
						else
							love.graphics.setColor(0,0,0);
						end
							love.graphics.print(oscreen.options[i].text,80,4 + (i-1)*25 + oscreen.offsetDown);
						if i == (oscreen.pos + 1) and not oscreen.leftside then
							love.graphics.setColor(190,80,190);
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
					love.graphics.setColor(255,255,255);
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
				if not oscreen.quityes then handx = 142; end
				love.graphics.draw(oscreen.handy,handx,92);
			end
		love.graphics.popCanvas();
		love.graphics.draw(oscreen.canvas,0,0);
	end;
	return oscreen;
end