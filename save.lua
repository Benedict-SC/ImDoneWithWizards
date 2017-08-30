saveDelayed = false;
saveGame = function()
	if saveDelayed then
		return;
	end
	saveDelayed = true;
	scriptools.wait(1,function()
		saveDelayed = false;
	end);
	local mainroomsave = game.mainroom.convertBackToData();
	local mrdata = json.encode(mainroomsave);
	mrdata = mrdata:gsub("\\/","/");
	local hooray, message = love.filesystem.write("mainroom.json",mrdata);
		if hooray then
			debug_console_string = "save success!";
			sfx.play(sfx.save);
		elseif message then
			error("extreme failure!\n" .. message);		
		end
	local gameData = {};
	gameData.px = game.player.x;
	gameData.py = game.player.y;
	if game.room == game.darkroom then
		gameData.px = game.mainroom.fake.x;
		gameData.py = game.mainroom.fake.y;	
	end
	gameData.playerDir = game.player.currentAnim;
	gameData.camera = {x=game.mainroom.camera.x,y=game.mainroom.camera.y};
	gameData.eflags = game.eflags;
	gameData.flags = game.flags;
	
	gameData.evidence = {};	
	for i=2, #(game.inventory.list), 1 do --skip Uncertainty- it comes standard with the inventory
		local ev = game.inventory.list[i];
		local freezeEv = {};
		freezeEv.eid = ev.id;
		freezeEv.alt = ev.alt;
		freezeEv.active = ev.active;
		gameData.evidence[i-1] = freezeEv;
	end
	
	local gameJson = json.encode(gameData);
	local hooray2, message2 = love.filesystem.write("gamedata.json",gameJson);
		if hooray2 then
			debug_console_string = debug_console_string .. "!";
		elseif message2 then
			error("extreme failure 2!\n" .. message2);		
		end
	
	local hypData = {fragments={}};
	for i=1,#(game.hypothesis.fragmentList),1 do
		local frag = game.hypothesis.fragmentList[i];
		hypData.fragments[i] = frag.filename;
	end
	local hypJson = json.encode(hypData);
		local hooray3, message3 = love.filesystem.write("hypothesis.json",hypJson);
		if hooray3 then
			debug_console_string = debug_console_string .. "!";
		elseif message3 then
			error("extreme failure 3!\n" .. message3);		
		end
end