emotes = {};
emotes.emoteCount = 0;
emotes.exclaim = function(thing,offset,whenDone)
	if not offset then
		offset = {x=0,y=0};
	end
	local exclaimer = ImageThing(thing.x + offset.x,thing.y + offset.y - thing.height(),1.1,"images/exclamation.png");
	exclaimer.color = {r=255,g=255,b=255,a=0};
	exclaimer.person = thing;
	exclaimer.offset = offset;
	emotes.emoteCount = emotes.emoteCount + 1;
	local ename = "epoint" .. emotes.emoteCount;
	game.room.registerThing(exclaimer,ename);
	sound.play("exclaim");
	
	scriptools.doOverTime(0.3,function(percent)
		exclaimer.color.a = percent;
	end,function()
		exclaimer.color.a = 1;	
	end);
	
	local updater = {};
	updater.startTime = love.timer.getTime();
	updater.startY = exclaimer.y;
	updater.startPersonY = exclaimer.person.y;
	updater.ePoint = exclaimer;
	if whenDone then
		updater.finish = whenDone;
	else 
		updater.finish = function() end
	end
	updater.func = function()
		local timeElapsed = love.timer.getTime() - updater.startTime;
		local percentMoved = timeElapsed/0.4;
		updater.done = percentMoved >= 1;
		if updater.done then percentMoved = 1; end
		local heightroot = 4
		local root = (percentMoved*heightroot*2)-heightroot;
		local square = root * root;
		local jump = math.floor((heightroot*heightroot)-square);
		
		--updater.ePoint.y = updater.startY - jump;
		updater.ePoint.y = ((updater.ePoint.person.y - updater.startPersonY) + updater.startY) - jump;
		updater.ePoint.x = updater.ePoint.person.x + updater.ePoint.offset.x;
		if updater.done then 
			scriptools.wait(0.6,function()
				game.room.eliminateThingByName(ename);
				updater.finish();
			end);
			scriptools.doOverTime(0.6,function(percent)
				updater.ePoint.y = ((updater.ePoint.person.y - updater.startPersonY) + updater.startY) - jump;
				updater.ePoint.x = updater.ePoint.person.x + updater.ePoint.offset.x;
			end);
		end
	end
	updater.done = false;
	scriptools.registerFunction(updater);
end
emotes.sweatdrop = function(thing,offset,whenDone)
	if not offset then
		offset = {x=0,y=0};
	end
	local drops = AnimatedThing(thing.x + offset.x,thing.y + offset.y - thing.height(),1,"sweat");
	emotes.emoteCount = emotes.emoteCount + 1;
	local ename = "sweat" .. emotes.emoteCount;
	emotes.emoteCount = emotes.emoteCount + 1;
	local ename2 = "sweat" .. emotes.emoteCount;
	game.room.registerThing(drops,ename);
	
	scriptools.wait(0.5,function()
		game.room.eliminateThingByName(ename);
		local drops2 = AnimatedThing(thing.x + offset.x,thing.y + offset.y - thing.height(),1,"sweat");
		game.room.registerThing(drops2,ename2);
	end);
	scriptools.wait(1,function()
		game.room.eliminateThingByName(ename2);
		if whenDone then
			whenDone();
		end
	end);
end