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
			sfx.play(sfx.evidenceOpen);
			game.player.updateSprite(0,0);
			game.player.state = "TEXTBOX";
			thing.actionConvo.start();
		end
	elseif atype == "hypothesis" then
		thing.action = function()
			game.hypothesis.show();
			game.player.updateSprite(0,0);
			game.player.state = "HYPOTHESIS";
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
		
		local ev = game.inventory.addEvidence(eid);
		local owner = game.convo.ownerName;
		if newConvoId and owner then
			local newConv = Convo(newConvoId);
			newConv.ownerName = owner;
			game.room.thingLookup[owner].actionConvo = newConv;
		end
		ev.animateTag(function()
			game.convo.advance();		
		end)
	elseif actionName == "alterEvidence" then
		local ev = game.inventory.getEvidence(args.evidenceID);
		if ev then
			game.inventory.setAlt(args.evidenceID,args.alt);
		end
		game.convo.advance();
	elseif actionName == "flag" then
		game.flags[args.flagname] = args.value;
		game.convo.advance();
	elseif actionName == "music" then
		if args.sharp then
			sfx.playBGM(sfx[args.soundID]);
		else
			sfx.fadeInNewBGM(sfx[args.soundID]);
		end
		game.convo.advance();
	elseif actionName == "replace" then
		game.hypothesis.replaceFragment(args.target,args.newFrag);
		game.convo.advance();
	elseif actionName == "script" then
		game.convo.finish("NOCONTROL",function() require(args.scriptfilename); end);
	elseif actionName == "midscript" then
		require(args.scriptfilename);
		game.convo.advance();
	end
end