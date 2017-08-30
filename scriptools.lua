scriptools = {};
scriptools.updates = Array();
scriptools.registerFunction = function(funcobj)
	scriptools.updates.push(funcobj);
end
scriptools.update = function()
	for i=1,#(scriptools.updates),1 do
		if not (scriptools.updates[i].cancel )then	
			scriptools.updates[i].func();
		end
	end
	local i=1;
	while i <= #(scriptools.updates) do
		if scriptools.updates[i].done or scriptools.updates[i].cancel then
			scriptools.updates.remove(i);
		else
			i = i + 1;
		end
	end
end

scriptools.doForever = function(eternalfunc) 
	local updater = {};
	updater.startTime = love.timer.getTime();
	updater.finish = function() end
	updater.func = eternalfunc;
	updater.done = false;
	scriptools.registerFunction(updater);
end

scriptools.movePlayerOverTime = function(x,y,secs,funcwhendone)
	game.player.updateSprite(x,y);
	game.player.state = "NOCONTROL";
	local updater = {};
	updater.startTime = love.timer.getTime();
	updater.startPoint = {x=game.player.x,y=game.player.y};
	if funcwhendone then
		updater.finish = funcwhendone;
	else 
		updater.finish = function() end
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		local percentMoved = timeElapsed/secs;
		updater.done = percentMoved >= 1;
		if updater.done then percentMoved = 1; end
		local xDist = math.floor(percentMoved * x);
		local yDist = math.floor(percentMoved * y);
		game.player.x = updater.startPoint.x + xDist;
		game.player.y = updater.startPoint.y + yDist;
		if updater.done then 
			game.player.updateSprite(0,0);
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end
scriptools.moveCameraOverTime = function(x,y,secs,funcwhendone)
	local updater = {};
	updater.startTime = love.timer.getTime();
	updater.startPoint = {x=game.room.camera.x,y=game.room.camera.y};
	if funcwhendone then
		updater.finish = funcwhendone;
	else 
		updater.finish = function() end
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		local percentMoved = timeElapsed/secs;
		updater.done = percentMoved >= 1;
		if updater.done then percentMoved = 1; end
		local xDist = math.floor(percentMoved * x);
		local yDist = math.floor(percentMoved * y);
		game.room.camera.x = updater.startPoint.x + xDist;
		game.room.camera.y = updater.startPoint.y + yDist;
		if updater.done then 
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end
scriptools.moveThingOverTime = function(thing,x,y,secs,funcwhendone)
	local updater = {};
	updater.startTime = love.timer.getTime();
	updater.startPoint = {x=thing.x,y=thing.y};
	if funcwhendone then
		updater.finish = funcwhendone;
	else 
		updater.finish = function() end
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		local percentMoved = timeElapsed/secs;
		updater.done = percentMoved >= 1;
		if updater.done then percentMoved = 1; end
		local xDist = math.floor(percentMoved * x);
		local yDist = math.floor(percentMoved * y);
		thing.x = updater.startPoint.x + xDist;
		thing.y = updater.startPoint.y + yDist;
		if updater.done then 
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end

scriptools.wait = function(secs,funcwhendone)
	local updater = {};
	updater.startTime = love.timer.getTime();
	if funcwhendone then
		updater.finish = funcwhendone;
	else 
		updater.finish = function() end
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		updater.done = timeElapsed >= secs;
		if updater.done then 
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end

scriptools.doOverTime = function(secs,everyFrame,funcwhendone)
	local updater = {};
	updater.startTime = love.timer.getTime();
	if funcwhendone then
		updater.finish = funcwhendone;
	else 
		updater.finish = function() end
	end
	updater.everyFrame = everyFrame;
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		local percent = timeElapsed/secs;
		updater.done = percent >= 1;
		if updater.done then percent = 1; end
		everyFrame(percent);
		if updater.done then 
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
	return updater;
end

scriptools.panToThing = function(thing,secs,offset,funcwhendone)
	if secs == nil then
		secs = 1;
	end
	if offset == nil then
		offset = {x=0,y=0};
	end
	local currentPoint = {x=game.player.x+game.room.camera.x,y=game.player.y+game.room.camera.y};
	local newPoint = {x=thing.x+offset.x,y=thing.y + offset.y - thing.height()};
	scriptools.moveCameraOverTime(newPoint.x-currentPoint.x,newPoint.y-currentPoint.y,secs,funcwhendone);
end
scriptools.panToPoint = function(newPoint,secs,funcwhendone)
	if secs == nil then
		secs = 1;
	end
	local currentPoint = {x=game.player.x+game.room.camera.x,y=game.player.y+game.room.camera.y};
	scriptools.moveCameraOverTime(newPoint.x-currentPoint.x,newPoint.y-currentPoint.y,secs,funcwhendone);
end
scriptools.recenterCamera = function(secs,offset,funcwhendone)
	scriptools.panToThing(game.player,secs,offset,funcwhendone);
	
end