Convo = function(convo_id)
	local filepath = "json/convos/" .. convo_id .. ".json";
	local jsonstring = love.filesystem.read(filepath);
	local data = json.decode(jsonstring);
	local conv = CustomConvo(data);
	conv.convoId = convo_id;
	return conv;
end
CustomConvo = function(linesArray)
	local conv = {};
	conv.data = linesArray;
	conv.idIndices = {};
	conv.line = 1;
	conv.choice = 1;
	for i=1,#conv.data.lines,1 do
		local line = conv.data.lines[i];
		if line.text then
			line.text = "<f=OpenDyslexic>".. conv.data.lines[i].text .. "</f>";
		end
		if line.id then 
			conv.idIndices[line.id] = i;
		end
	end
	
	
	conv.start = function()
		conv.line = 1; 
		local line = conv.data.lines[conv.line];
		while line.action == "branch" do --code copied from action handler- can't call directly since it relies on conv.advance()
			local lineIndex = 1;
			if(line.branchType == "evidence") then
				local ename = line.evidence;
				if game.eflags[ename] then
					lineIndex = conv.idIndices[line.yes];
				else
					lineIndex = conv.idIndices[line.no];
				end
			else
				local fname = line.flag;
				if game.flags[fname] then
					lineIndex = conv.idIndices[line.yes];
				else
					lineIndex = conv.idIndices[line.no];
				end
			end
			conv.line = lineIndex;
			line = conv.data.lines[lineIndex];
		end
		while line.action do
			conv.handleAction(line);
			line = conv.data.lines[conv.line];
		end
		if line.portrait == "maaaaaaa" then
			sound.play("maaaaaaa");
		elseif line.portrait == "maa?" then
			sound.play("maaQ");
		elseif line.portrait == "scaregoat" then
			sound.play("scaregoat");
		end

		game.textbox.setText(line.text);
		game.textbox.td.charsDrawn = 0;
		game.textbox.state = "RISING";
		local port = conv.getPortrait();
		if not (line.silent) then
			game.textbox.swapPortraitTo(port.talkingImg);
		else
			game.textbox.swapPortraitTo(port.staticImg);
		end
		conv.lastCharacter = conv.getPortrait().character;
		if not (usedConvoList.contains(conv.convoId)) then
			usedConvoList.push(conv.convoId);
		end
		if not conv.loggy then
			game.log.addLine(line.text,conv.lastCharacter);
		end
	end
	conv.advance = function(lineOverride)
		conv.line = conv.line + 1;
		if lineOverride then
			conv.line = lineOverride;
		end
		if conv.line > #conv.data.lines then 
			conv.finish();
			return;
		end
		--handle quit actions
		local line = conv.data.lines[conv.line];
		if line.quit then
			conv.finish();
			return;
		end
		if line.choices then
			conv.choice = 0;
		end
		--handle custom actions
		if line.action then
			conv.handleAction(line);
			return;
		end
		--if we get past all that to this, we're just doing a normal line
		if not line.text then
			error(lineOverride);
		end
		game.textbox.setText(line.text);
		game.textbox.td.charsDrawn = 0;
		if not (conv.getPortrait().character == conv.lastCharacter) then
			conv.lastCharacter = conv.getPortrait().character;
			local port = conv.getPortrait();
			game.textbox.swapPortraitTo(port.staticImg);
		end
		game.textbox.state = "TYPING";
		if game.convo.getCurrentLine().silent then	
			game.textbox.setBeeps("quiet");
		elseif line.portrait == "maaaaaaa" then
			sound.play("maaaaaaa");
		elseif line.portrait == "maa?" then
			sound.play("maaQ");
		elseif line.portrait == "scaregoat" then
			sound.play("scaregoat");
		else
			game.textbox.setBeeps(conv.getPortrait().character);
		end
		if not (line.silent) then
			game.textbox.startPortraitTalking();
		end
		if not conv.loggy then
			game.log.addLine(line.text,conv.lastCharacter);
		end
	end
	conv.handleAction = function(line)
			local args = {};
			local action = line.action;
			if action == "hypothesis" then
				args = {};
			elseif action == "evidence" then
				args = {eID=line.evidenceID,newConvo=line.postConvo,alt=line.alt};
			elseif action == "showEvidence" then
				args = {eID=line.evidenceID};
			elseif action == "replaceConvo" then
				args = {newConvo=line.postConvo};
			elseif action == "alterEvidence" then
				args = {evidenceID = line.evidenceID,alt=line.alt};
			elseif action == "branch" then
				if line.branchType == "evidence" then
					action = "evidenceBranch";
					args = {evidenceID=line.evidence,yesId = line.yes,noId = line.no};
				elseif line.branchType == "flag" then
					action = "flagBranch";
					args = {flagName = line.flag, yesId = line.yes,noId = line.no};
				end
			elseif action == "jump" then
				args = {lineID = line.lineID};
			elseif action == "flag" then
				args = {flagname = line.flag,value = line.value};
			elseif action == "music" then
				args = {soundID = line.soundID,sharp = line.sharp};
			elseif action == "sfx" then
				args = {soundID = line.soundID};
			elseif action == "replace" then
				args = {target=line.target,newFrag=line.newFrag};
			elseif (action == "unmark") or (action == "mark") then
				args = {convoId=line.convoId};
			elseif action == "direction" then
				args = {other=line.other,dir=line.dir};
			elseif action == "deleteFrag" then
				args = {target=line.target};
			elseif action == "insertFrag" then
				args = {position=line.position,newFrag=line.newFrag};
			elseif action == "script" or action == "midscript" then
				args = {scriptfilename=line.scriptfilename};
			elseif action == "look" then
				args = {target = line.target,dir = line.dir,looker = line.looker};
			elseif action == "fade" then
				args = {fadein = line["in"]};
			end
			convoAction(action,args);
			return;
	end
	conv.scrollUp = function()
		conv.choice = conv.choice - 1;
		if conv.choice < 1 then 
			local line = conv.getCurrentLine();
			conv.choice = #(line.choices);
		end
		sound.play("evidenceScroll");
	end
	conv.scrollDown = function()
		local line = conv.getCurrentLine();
		conv.choice = conv.choice + 1;
		if conv.choice > #(line.choices) then
			conv.choice = 1;
		end
		sound.play("evidenceScroll");
	end
	conv.pick = function()
		if conv.choice == 0 then
			sound.play("evidenceScroll");
			conv.choice = 1;
			return;
		end
		local line = conv.getCurrentLine();
		local id = line.choices[conv.choice].id;
		if not id then --default is to progress to the next line
			conv.advance();
			return;
		end
		local lineIndex = conv.idIndices[id];
		conv.advance(lineIndex);
	end
	conv.finish = function(newState,whenDismissedFunction)
		game.textbox.dismissBox(whenDismissedFunction);
		game.player.state = newState or "MOVING";
	end
	conv.getPortrait = function(lineNumber)
		local line = conv.data.lines[lineNumber or conv.line];
		local port = portraits[line.portrait];
		--port.talkingImg.offsetLeft = port.offsetLeft;
		--port.talkingImg.offsetRight = port.offsetRight;
		--port.staticImg.offsetLeft = port.offsetLeft;
		--port.staticImg.offsetRight = port.offsetRight;
		return port;
	end
	conv.getCurrentLine = function()
		return conv.data.lines[conv.line];
	end
	
	return conv;
end
usedConvoList = Array();
portraitString = love.filesystem.read("json/portraits.json");
portraits = json.decode(portraitString).portraits;
for k,v in pairs(portraits) do
		local st_img = ImageThing(0,gameheight,1.5,portraits[k].static);
		local talk_img = ImageThing(0,gameheight,1.5,portraits[k].talking);
		--local talk_img = AnimatedThing(0,gameheight,1.5,"ports/satisfied");
		local nk = k:gsub("?","q")
		local talkfile = love.filesystem.read("json/animations/ports/" .. nk .. ".json");
		if talkfile then
			talk_img = AnimatedThing(0,gameheight,1.5,"ports/" .. nk);
		end
		portraits[k].staticImg = st_img;
		portraits[k].talkingImg = talk_img;
		portraits[k].talkingImg.offsetLeft = portraits[k].offsetLeft;
		portraits[k].talkingImg.offsetRight = portraits[k].offsetRight;
		portraits[k].staticImg.offsetLeft = portraits[k].offsetLeft;
		portraits[k].staticImg.offsetRight = portraits[k].offsetRight;
end