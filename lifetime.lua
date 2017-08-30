lifetime = {}
mortalCoil = Array();
mortalCoil.update = function()
	for i=1,#mortalCoil,1 do
		local liver = mortalCoil[i];
		if not liver then error("i: " .. i .. ", length: " .. #mortalCoil); end
		liver.update();
		liver.lifespan = liver.lifespan - 1;
		if liver.lifespan <= 0 then
			liver.dead = true;
			if liver.death then
				liver.death();
			end
		end
	end
	--clear out dead livers
	local tempArray = Array();
	tempArray.update = mortalCoil.update;
	for i=1,#mortalCoil,1 do
		local liver = mortalCoil[i];
		if not liver.dead then tempArray.push(liver); end
	end
	mortalCoil = tempArray;
end
Lifetime = function(thing,frames)
	local lifeInfo = {};
	lifeInfo.lifespan = frames;
	lifeInfo.thing = thing;
	return lifeInfo;
	
end
lifetime.shake = function(thing) --example function
	local shaker = Lifetime(thing,6);
	shaker.lastXDisplacement = 0;
	shaker.lastYDisplacement = 0;
	shaker.angle = 0;
	--shaker.maxRadius = 7;
	shaker.radius = 7;
	shaker.update = function()
		--undo previous shake displacement
		shaker.thing.x = shaker.thing.x - shaker.lastXDisplacement;
		shaker.thing.y = shaker.thing.y - shaker.lastYDisplacement;
		--calculate displacement and move the thing
		local radians = shaker.angle*((2*math.pi)/360);
		local xDis = math.floor((shaker.radius * math.cos(radians)) + 0.5);
		local yDis = math.floor((shaker.radius * math.sin(radians)) + 0.5);
		shaker.thing.x = shaker.thing.x + xDis;
		shaker.thing.y = shaker.thing.y + yDis;
		--prep new angle and radius for next update
		shaker.angle = (shaker.angle + 180) + ((math.random(0,1)*120)-60);
		shaker.radius = shaker.radius - 1;--(shaker.maxRadius*decayPercent);
		
		shaker.lastXDisplacement = xDis;
		shaker.lastYDisplacement = yDis;
	end
	shaker.death = function()
		--undo previous shake displacement
		shaker.thing.x = shaker.thing.x - shaker.lastXDisplacement;
		shaker.thing.y = shaker.thing.y - shaker.lastYDisplacement;	
	end
	mortalCoil.push(shaker);
end
lifetime.delay = function(duration,cb)
	local delay = Lifetime(nil,duration);
	delay.update = nilf;
	delay.death = cb;
	mortalCoil.push(delay);
end