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
	return updater;
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
	return updater;
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
	return updater;
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
	return updater;
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
	return updater;
end
scriptools.moveAtSpeedOverDistance = function(thing,pixPerSec,xdist,ydist,checkColl,funcwhendone)
	local updater = {};
	updater.lastTime = love.timer.getTime();
	updater.mover = thing;
	updater.xTraveled = 0;
	updater.yTraveled = 0;
	updater.xdist = xdist;
	updater.ydist = ydist;
	local angle = math.atan2(ydist,xdist);
	while angle < 0 do angle = angle + (2*math.pi); end
	while angle > (2*math.pi) do angle = angle - (2*math.pi); end
	updater.xspeed = pixPerSec * math.cos(angle);
	updater.yspeed = pixPerSec * math.sin(angle);
	if funcwhendone then
		updater.finish = funcwhendone;
	else 
		updater.finish = function() end
	end
	updater.func = function()
		--compute how far to move this step
		local timeDelta = love.timer.getTime() - updater.lastTime;
		updater.lastTime = love.timer.getTime();
		local xstep = updater.xspeed * timeDelta;
		local ystep = updater.yspeed * timeDelta;
		if (math.abs(updater.xTraveled + xstep) >= math.abs(updater.xdist)) and (math.abs((updater.yTraveled + ystep)) > math.abs(updater.ydist)) then
			--cap the last step so we don't overshoot
			xstep = updater.xdist - updater.xTraveled;
			ystep = updater.ydist - updater.yTraveled;
		end
		--track how far we've gone
		updater.xTraveled = updater.xTraveled + xstep;
		updater.yTraveled = updater.yTraveled + ystep;
		--actually do the movement
		updater.mover.x = updater.mover.x + xstep;
		updater.mover.y = updater.mover.y + ystep;

		if checkColl then
			local pcoll = updater.mover.collider.collidesWith(game.player.collider);
			if pcoll then
				updater.mover.x = updater.mover.x - xstep;
				updater.mover.y = updater.mover.y - ystep;
				updater.done = true;
			else
				local colls = game.room.getCollisions(updater.mover.collider);
				for i = 1, #colls do
					if colls[i].collider ~= updater.mover.collider then
						updater.mover.x = updater.mover.x - xstep;
						updater.mover.y = updater.mover.y - ystep;
						updater.done = true;
						break;
					end
				end
			end			
		end
		if not updater.done then
			updater.done = (math.abs(updater.xTraveled) >= math.abs(updater.xdist)) and (math.abs(updater.yTraveled) >= math.abs(updater.ydist));
		end
		if updater.done then 
			updater.finish();
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
	return updater;
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
	return scriptools.moveCameraOverTime(newPoint.x-currentPoint.x,newPoint.y-currentPoint.y,secs,funcwhendone);
end
scriptools.panToPoint = function(newPoint,secs,funcwhendone)
	if secs == nil then
		secs = 1;
	end
	local currentPoint = {x=game.player.x+game.room.camera.x,y=game.player.y+game.room.camera.y};
	return scriptools.moveCameraOverTime(newPoint.x-currentPoint.x,newPoint.y-currentPoint.y,secs,funcwhendone);
end
scriptools.recenterCamera = function(secs,offset,funcwhendone)
	return scriptools.panToThing(game.player,secs,offset,funcwhendone);
	
end