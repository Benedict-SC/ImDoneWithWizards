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
				require("cutscenes.temp");
			else
				sfx.play(sfx.invalid);
				lifetime.shake(game.title.handthing);
			end
		end},
		{text="New Game",does=function()
			game.prepareRooms(false);
			require("cutscenes.openingcutscene01");
			game.menuMode = false;
			sfx.fadeBGM(nil,2.5);
		end},
		{text="Options",does=function()
			sfx.play(sfx.questionBeep);
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
			sfx.play(sfx.evidenceScroll);
		end;
		if pressedThisFrame.down then 
			tscreen.pos = tscreen.pos + 1; 
			sfx.play(sfx.evidenceScroll);
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
	local tscreen = {};
	tscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	tscreen.bg = love.graphics.newImage("images/menus/optionsbg.png");
	tscreen.handy = love.graphics.newImage("images/menus/handy.png");
	tscreen.handthing = BlankThing();
	tscreen.pos = 0;
	tscreen.options = {
		{text="Save Game",does=function()
			saveGame();
		end},
		{text="Options",does=function()
			sfx.play(sfx.questionBeep);
			DEBUG_CONSOLE = not DEBUG_CONSOLE;
			DEBUG_COLLIDERS = not DEBUG_COLLIDERS;
			--DEBUG_SLOW = not DEBUG_SLOW;
		end},
		{text="Back to Game",does=function()
			game.menuMode = false;
		end}
	}
	tscreen.update = function()
		if pressedThisFrame.up then 
			tscreen.pos = tscreen.pos - 1; 
			sfx.play(sfx.evidenceScroll);
		end;
		if pressedThisFrame.down then 
			tscreen.pos = tscreen.pos + 1; 
			sfx.play(sfx.evidenceScroll);
		end;
		tscreen.pos = (tscreen.pos + #(tscreen.options)) % #(tscreen.options);
		
		if pressedThisFrame.action then
			tscreen.options[tscreen.pos + 1].does();
		end;
	end
	tscreen.draw = function()
		love.graphics.pushCanvas(tscreen.canvas);
			love.graphics.draw(tscreen.bg,0,0);
			love.graphics.draw(tscreen.handy,90+tscreen.handthing.x,61 + (tscreen.pos * 18)+tscreen.handthing.y);
			love.graphics.setFont(loadedFonts["TitleOption"]);
			pushColor();
			love.graphics.setColor(0,0,0);
			love.graphics.setShader(textColorShader);
			for i=1, #tscreen.options, 1 do
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