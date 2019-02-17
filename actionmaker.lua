configureAction = function(thing,thingdata)
	local atype = thingdata.action;
	if thingdata.useColliderInsteadOfSprite then
		collision.giveColliderWithNameBasedOnExistingCollider("actionCollider",thing);
	else
		collision.giveColliderWithNameBasedOnSprite("actionCollider",thing);
	end
	thing.actionCollider.offsetGeneratedSpriteCollider(thingdata.aXoffset,thingdata.aYoffset,thingdata.awidth,thingdata.aheight);
	thing.atype = atype;
	if atype == "convo" then 
		thing.actionConvo = Convo(thingdata.convoId);
		thing.actionConvo.ownerName = thing.name;
		thing.atype = atype;
		thing.action = function()
			game.convo = thing.actionConvo;
			sound.play("evidenceOpen");
			game.player.updateSprite(0,0);
			game.player.state = "TEXTBOX";
			thing.actionConvo.start();
		end
	elseif atype == "hypothesis" then
		thing.action = function()
			game.hypothesis.show();
			game.player.updateSprite(0,0);
			game.player.state = "HYPOTHESIS";
			local leo = game.room.thingLookup["leo"]
			leo.setAnimation(directionTo(leo,game.player));
		end
	elseif atype == "log" then
		thing.atype = atype;
		thing.action = function()
			if #(game.log.lineCache) > 0 then
				game.convo = game.log.convoFromCache();
				sound.play("evidenceOpen");
				game.player.updateSprite(0,0);
				game.player.state = "TEXTBOX";
				game.convo.start();
			else
				sound.play("invalid");
			end
		end
	elseif atype == "script" then
		thing.atype = atype;
		thing.action = function()
			runlua(thingdata.luafile);
		end
	end
end

convoAction = function(actionName,args)
	if actionName == "hypothesis" then 
		game.hypothesis.show();
		game.convo.finish("HYPOTHESIS");
	elseif actionName == "evidenceBranch" then
		local eid = args.evidenceID;
		local lineIndex = 1;
		if game.eflags[eid] then
			lineIndex = game.convo.idIndices[args.yesId];
		else
			lineIndex = game.convo.idIndices[args.noId];
		end
		game.convo.advance(lineIndex);
	elseif actionName == "flagBranch" then
		local fname = args.flagName;
		local lineIndex = 1;
		if game.flags[fname] then
			lineIndex = game.convo.idIndices[args.yesId];
		else
			lineIndex = game.convo.idIndices[args.noId];
		end
		game.convo.advance(lineIndex);
	elseif actionName == "jump" then
		local lineIndex = game.convo.idIndices[args.lineID];
		game.convo.advance(lineIndex);
	elseif actionName == "evidence" then 
		local eid = args.eID;
		local newConvoId = args.newConvo;
		
		local ev = game.inventory.addEvidence(eid,nil,true);
		if args.alt then
			game.inventory.setAlt(eid,args.alt);
		elseif game.altRecords[eid] then
			game.inventory.setAlt(eid,game.altRecords[eid]);
		end
		local owner = game.convo.ownerName;
		if newConvoId and owner then
			local newConv = Convo(newConvoId);
			newConv.ownerName = owner;
			game.room.thingLookup[owner].actionConvo = newConv;
		end
		ev.animateTag(function()
			game.convo.advance();		
		end)
	elseif actionName == "showEvidence" then 
		local eid = args.eID;
		local ev = game.inventory.getEvidence(eid);
		ev.animateTag(function()
			game.convo.advance();		
		end);
	elseif actionName == "replaceConvo" then
		local newConvoId = args.newConvo;
		local owner = game.convo.ownerName;
		if newConvoId and owner then
			local newConv = Convo(newConvoId);
			newConv.ownerName = owner;
			game.room.thingLookup[owner].actionConvo = newConv;
		end
		game.convo.advance();
	elseif actionName == "alterEvidence" then
		local ev = game.inventory.getEvidence(args.evidenceID);
		if ev then
			game.inventory.setAlt(args.evidenceID,args.alt);
		end
		game.altRecords[args.evidenceID] = args.alt;
		game.convo.advance();
	elseif actionName == "flag" then
		game.flags[args.flagname] = args.value;
		game.convo.advance();
	elseif actionName == "music" then
		if args.soundID then
			if args.sharp then
				sound.playBGM(args.soundID);
			else
				sound.fadeInBGM(args.soundID);
			end
		else
			sound.fadeInBGM();
		end
		game.convo.advance();
	elseif actionName == "sfx" then
		if args.soundID then
			sound.play(args.soundID);
		end
		game.convo.advance();
	elseif actionName == "replace" then
		game.hypothesis.replaceFragment(args.target,args.newFrag);
		game.convo.advance();
	elseif actionName == "deleteFrag" then
		game.hypothesis.deleteFragment(args.target);
		game.convo.advance();
	elseif actionName == "insertFrag" then
		game.hypothesis.insertFragment(args.position,args.newFrag);
		game.convo.advance();
	elseif actionName == "mark" then
		if not (usedConvoList.contains(args.convoId)) then
			usedConvoList.push(args.convoId);
		end
		game.convo.advance();
	elseif actionName == "unmark" then
		usedConvoList.removeElement(args.convoId);
		game.convo.advance();
	elseif actionName == "direction" then
		if args.other then
			args.other.setAnimation(args.dir);
		else
			game.player.setAnimation(args.dir);
		end
		game.convo.advance();
	elseif actionName == "script" then
		game.convo.finish("NOCONTROL",function() runlua( (args.scriptfilename):gsub("%.","/") .. ".lua"); end);
	elseif actionName == "midscript" then
		runlua( (args.scriptfilename):gsub("%.","/") .. ".lua");
		game.convo.advance();
	elseif actionName == "look" then
		local looker = game.player;
		local target = {x=20000,y=-1};
		local dir = "s";
		if args.dir then 
			dir = args.dir; 
		end
		if args.looker then
			looker = game.room.thingLookup[args.looker];
		end
		if args.target then
			if args.target == "player" then
				target = game.player;
			else
				target = game.room.thingLookup[args.target];
			end
			dir = directionTo(looker,target)
		end
		looker.setAnimation(dir);
		game.convo.advance();
	elseif actionName == "clang" then
		lifetime.shake(game.shake);
		game.textbox.state = "CLANG";
		sound.debeep(game.textbox.beep);
		sound.play("clang");
		scriptools.wait(1.6,function()
			game.convo.advance();		
		end);
	elseif actionName == "fade" then
		if not args.fadein then
			game.externalFadeHandle = scriptools.doOverTime(0.5,function(percent)
				game.externalFadeHandle.alpha = 255 * percent;
			end);
			game.externalFadeHandle.alpha = 0;
		else
			game.externalFadeHandle = scriptools.doOverTime(0.5,function(percent)
				game.externalFadeHandle.alpha = 255 * (1-percent);
			end);
			game.externalFadeHandle.alpha = 255;
		end
		game.externalFadeHandle.drawIt = function()
			pushColor();
			love.graphics.setColor(0,0,0,game.externalFadeHandle.alpha);
			love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
			popColor();
		end
		game.convo.advance();
	end
end