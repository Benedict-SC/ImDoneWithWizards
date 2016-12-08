Convo = function(convo_id)
	local conv = {};
	local filepath = "json/convos/" .. convo_id .. ".json";
	local jsonstring = love.filesystem.read(filepath);
	conv.data = json.decode(jsonstring);
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
	for k,v in pairs(conv.data.portraits) do
		local st_img = ImageThing(0,gameheight,1.5,conv.data.portraits[k].static);
		local talk_img = ImageThing(0,gameheight,1.5,conv.data.portraits[k].talking); --make this animated later
		conv.data.portraits[k].staticImg = st_img;
		conv.data.portraits[k].talkingImg = talk_img;
	end
	
	conv.start = function()
		conv.line = 1; 
		local line = conv.data.lines[conv.line];
		game.textbox.setText(line.text);
		game.textbox.td.charsDrawn = 0;
		game.textbox.state = "RISING";
		game.textbox.swapPortraitTo(conv.getPortrait().talkingImg);
		conv.lastCharacter = conv.getPortrait().character;
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
			conv.choice = 1;
		end
		--handle custom actions
		if line.action then
			if line.action == "hypothesis" then
				convoAction(line.action);
			elseif line.action == "evidence" then
				local args = {ename=line.evidenceName,newConvo=line.postConvo};
				convoAction(line.action,args);
			elseif line.action == "replace" then
				local args = {target=line.target,newFrag=line.newFrag};
				convoAction(line.action,args);
			end
			return;
		end
		--if we get past all that to this, we're just doing a normal line
		game.textbox.setText(line.text);
		game.textbox.td.charsDrawn = 0;
		if not (conv.getPortrait().character == conv.lastCharacter) then
			conv.lastCharacter = conv.getPortrait().character;
			game.textbox.swapPortraitTo(conv.getPortrait().staticImg);
		end
		game.textbox.state = "TYPING";
		game.textbox.startPortraitTalking();
	end
	conv.scrollUp = function()
		conv.choice = conv.choice - 1;
		if conv.choice < 1 then 
			local line = conv.getCurrentLine();
			conv.choice = #(line.choices);
		end
	end
	conv.scrollDown = function()
		local line = conv.getCurrentLine();
		conv.choice = conv.choice + 1;
		if conv.choice > #(line.choices) then
			conv.choice = 1;
		end
	end
	conv.pick = function()
		local line = conv.getCurrentLine();
		local id = line.choices[conv.choice].id;
		if not id then --default is to progress to the next line
			conv.advance();
			return;
		end
		local lineIndex = conv.idIndices[id];
		conv.advance(lineIndex);
	end
	conv.finish = function(newState)
		game.textbox.dismissBox();
		game.player.state = newState or "MOVING";
	end
	conv.getPortrait = function()
		local line = conv.data.lines[conv.line];
		return conv.data.portraits[line.portrait];
	end
	conv.getCurrentLine = function()
		return conv.data.lines[conv.line];
	end
	
	return conv;
end