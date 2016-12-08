InspectorBox = function(player)
	local box = {};
	box.player = player;
	box.checkrange = 4;
	box.zones = {
		length=4;
		n=(function()
			local rect = box.player.collider.rect();
			return Rect(rect.x, rect.y - box.checkrange,rect.w,box.checkrange);
		end);
		e=(function()
			local rect = box.player.collider.rect();
			return Rect(rect.x + rect.w, rect.y,box.checkrange,rect.h);
		end);
		s=(function()
			local rect = box.player.collider.rect();
			return Rect(rect.x, rect.y + rect.h,rect.w,box.checkrange);
		end);
		w=(function()
			local rect = box.player.collider.rect();
			return Rect(rect.x-box.checkrange, rect.y,box.checkrange,rect.h);
		end);
	};
	box.pickTarget = function()
		local dir = string.sub(box.player.currentAnim,1,2);
		local inspectables = Array();
		local dirs = {"n","e","s","w"};
		for i=1,#dirs,1 do
			if string.find(dir,dirs[i]) then
				local checkrect = box.zones[dirs[i]]();
				local thinglist = game.room.things;
				for j=1,#thinglist,1 do
					local thing = thinglist[j];
					if thing.actionCollider then
						if checkrect.intersectsRect(thing.actionCollider.rect()) then
							inspectables.push(thing);
						end
					end
				end
			end
		end
		--we now have a list of inspectables
		return inspectables[1]; --just return the first one for now- we'll see if we need multi-handling later
	end
	
	return box;
end