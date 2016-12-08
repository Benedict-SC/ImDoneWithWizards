configureAction = function(thing,thingdata)
	local atype = thingdata.action;
	collision.giveColliderWithNameBasedOnSprite("actionCollider",thing);
	thing.actionCollider.offsetGeneratedSpriteCollider(thingdata.aXoffset,thingdata.aYoffset,thingdata.awidth,thingdata.aheight);
	if atype == "convo" then 
		thing.actionConvo = Convo(thingdata.convoId);
		thing.actionConvo.ownerName = thing.name;
		thing.action = function()
			game.convo = thing.actionConvo;
			sfx.play(sfx.evidenceOpen);
			game.player.state = "TEXTBOX";
			thing.actionConvo.start();
		end
	elseif atype == "hypothesis" then
		thing.action = function()
			game.hypothesis.show();
			game.player.state = "HYPOTHESIS";
		end
	end
end

convoAction = function(actionName,args)
	if actionName == "hypothesis" then 
		game.hypothesis.show();
		game.convo.finish("HYPOTHESIS");
	elseif actionName == "evidence" then 
		local ename = args.ename;
		local newConvoId = args.newConvo;
		--the following is placeholder
		local edata = game.evidenceData[ename];
		local ev = Evidence(edata.bigPic,edata.icon,ename,edata.short,edata.summary);
		game.inventory.list.push(ev);
		local owner = game.convo.ownerName;
		if newConvoId and owner then
			local newConv = Convo(newConvoId);
			newConv.ownerName = owner;
			game.room.thingLookup[owner].actionConvo = newConv;
		end
		ev.animateTag(function()
			game.convo.advance();		
		end)
	elseif actionName == "replace" then
		game.hypothesis.replaceFragment(args.target,args.newFrag);
		game.convo.advance();
	end
end