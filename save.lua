saveDelayed = false;
saveGame = function(fileno)
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
	local hooray, message = love.filesystem.write("mainroom" .. fileno .. ".json",mrdata);
		if hooray then
			debug_console_string = "save success!";
			if fileno ~= 4 then
				sound.play("save");
			end
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
	game.player.updateSprite(0,0);
	gameData.playerDir = game.player.currentAnim;
	gameData.camera = {x=game.mainroom.camera.x,y=game.mainroom.camera.y};
	gameData.eflags = game.eflags;
	gameData.flags = game.flags;
	gameData.altRecords = game.altRecords;
	gameData.used = usedConvoList;
	gameData.playsecs = game.savedTime + (love.timer.getTime() - game.startTime);

	
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
	local hooray2, message2 = love.filesystem.write("gamedata" .. fileno .. ".json",gameJson);
		if hooray2 then
			debug_console_string = debug_console_string .. "!";
			game.title.hasData = true;
		elseif message2 then
			error("extreme failure 2!\n" .. message2);		
		end
	
	local hypData = {fragments={}};
	for i=1,#(game.hypothesis.fragmentList),1 do
		local frag = game.hypothesis.fragmentList[i];
		hypData.fragments[i] = frag.filename;
	end
	local hypJson = json.encode(hypData);
		local hooray3, message3 = love.filesystem.write("hypothesis" .. fileno .. ".json",hypJson);
		if hooray3 then
			debug_console_string = debug_console_string .. "!";
			game.title.hasData = true;
		elseif message3 then
			error("extreme failure 3!\n" .. message3);		
		end
end
saveOptions = function()
	local options = {};
	options.keyControls = keyControls;
	local optstring = json.encode(options);
	local hooray4, message4 = love.filesystem.write("userOptions.json",optstring);
		if hooray4 then
			debug_console_string = "options saved!";
		elseif message2 then
			error("extreme failure 4!\n" .. message2);		
		end
end
loadOptions = function()
	local optionsFile = love.filesystem.read("userOptions.json");
	if optionsFile then
		local optionData = json.decode(optionsFile);
		keyControls = optionData.keyControls;
	end
end