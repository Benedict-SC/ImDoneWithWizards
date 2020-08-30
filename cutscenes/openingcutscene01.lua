openingCutscene = {};

game.player.state = "NOCONTROL";
game.player.isColliding = false;
love.graphics.pushCanvas(game.room.overlaycanvas);
love.graphics.setColor(0,0,0);
love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
love.graphics.popCanvas();

sound.fadeInBGM(nil,function()
	local updater = {};
	updater.startTime = love.timer.getTime();
	updater.finish = function()
		openingCutscene.firstFlash();
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		if timeElapsed > 3 then
			updater.done = true;
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end);

openingCutscene.firstFlash = function()
	local updater = {}; --start the first white flash
	updater.startTime = love.timer.getTime();
	updater.banged = false;
	updater.finish = function()
		openingCutscene.afterFirstFlash();
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		local percentMoved = timeElapsed/0.6;
		updater.done = percentMoved >= 1;
		if updater.done then 
			percentMoved = 1; 
		end
		
		love.graphics.pushCanvas(game.room.overlaycanvas);
		if percentMoved <= 0.4 then
			local flashUpPercent = 2.5 * percentMoved;
			local brightness = flashUpPercent;
			love.graphics.setColor(brightness,brightness,brightness);
			love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
		elseif percentMoved > 0.4 and percentMoved <= 0.6 then
			if not updater.banged then
				sound.play("bang");
				updater.banged = true;
			end
			love.graphics.setColor(1,1,1);
			love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
		else
			local flashDownPercent = 2.5 * (percentMoved - 0.6);
			local brightness = 1 - flashDownPercent);
			love.graphics.setColor(brightness,brightness,brightness);
			love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
		end
		love.graphics.popCanvas();
		
		if updater.done then 
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end
	
openingCutscene.afterFirstFlash = function()
	scriptools.wait(1.4,function()
		game.convo = Convo("cutscene/landlord0");
		sound.play("evidenceOpen");
		game.player.state = "TEXTBOX";
		game.convo.start();
	end);
end