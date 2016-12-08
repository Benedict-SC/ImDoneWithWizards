require("inspectorbox");
PlayerController = function(animationFilename)
	local base = AnimatedThing(0,0,1,animationFilename);
	collision.giveColliderBasedOnSprite(base);
	base.inspector = InspectorBox(base);
	base.lastHoriz = 0; --velocities last frame
	base.lastVert = 0;
	--[[base.hstring = "last horiz: " .. base.lastHoriz;
	base.vstring = "last vrtcl: " .. base.lastVert;
	base.super = base.draw;
	base.draw = function()
		base.super();
		if not (base.lastHoriz == 0 and base.lastVert == 0) then
			base.hstring = "last horiz: " .. base.lastHoriz;
			base.vstring = "last vrtcl: " .. base.lastVert;
		end
		love.graphics.print(base.hstring,0,0);
		love.graphics.print(base.vstring,0,20);
	end]]--
	
	base.currentDir = base.data.default;
	base.moveSecs = {};
	
	base.state = "MOVING" --TEXTBOX HYPOTHESIS NOCONTROL
	base.horiz = 0;
	base.vert = 0;
	base.update = function()
		--get axes
		local horiz = 0;
		if input.left then horiz = horiz - 1 end;
		if input.right then horiz = horiz + 1 end;
		local vert = 0;
		if input.up then vert = vert - 1 end;
		if input.down then vert = vert + 1 end;
		if counter%8 == 0 or (base.lastHoriz == 0 and base.lastVert == 0) then 
			base.horiz = horiz;
			base.vert = vert;
		end
		
		if base.state == "MOVING" then --replace condition with a more general "player is not in a moving state" check
			base.move(horiz,vert);
			if pressedThisFrame.action then
				local toInspect = base.inspector.pickTarget();
				if toInspect then 
					toInspect.action();
				end
				--[[if game.textbox.state == "HIDDEN" then
					game.convo.start();]]
			elseif (input.leftTab or input.rightTab) and not game.fading then 
				game.fadeRooms(); 
			end
		elseif base.state == "TEXTBOX" then
			if pressedThisFrame.action then 
				if game.textbox.state == "WAITING" then
				sfx.play(sfx.evidenceScroll);
					game.convo.advance();
				elseif game.textbox.state == "CHOOSING" then
					sfx.play(sfx.evidenceScroll);
					game.convo.pick();
				elseif game.textbox.state == "EVIDENCE" then
					base.resumeEvidenceFunction(base.resumeEvidenceTag); --passed in from Evidence's animateTag()
					base.resumeEvidenceFunction, base.resumeEvidenceTag = nil,nil; --and clear that crap out
				end
			elseif game.convo.getCurrentLine().choices then 
				if pressedThisFrame.down then 
					game.convo.scrollDown();
				elseif pressedThisFrame.up then
					game.convo.scrollUp();
				end
			end
			
		elseif base.state == "HYPOTHESIS" then
			--delegate to hypothesis.lua
		end
		
		if love.keyboard.isDown("p") and love.keyboard.isDown("q") then error("emergency exit: " .. game.inventory.animationOffset); end
	end
	
	base.move = function(horiz,vert)
		local speed = 4;
		if not (horiz == 0) and not (vert == 0) then speed = speed / math.sqrt(2) end;
		--if horiz == 0 and vert == 0 then
		--	base.updateSprite(0,0);
		--else
			base.updateSprite(base.horiz,base.vert);
		--end
		
		local oldColl = base.collider.rect();
		local xmove = (horiz * speed);
		local ymove = (vert * speed);
		local preX = base.x;
		local preY = base.y;
		base.x = base.x + xmove;
		base.y = base.y + ymove;
		
		local collisions = game.room.getCollisions(base.collider);
		while #collisions > 0 do
			local collRect = collisions[1].zone;
			local out1 = "" .. collRect.w .. "/" .. collRect.h;
			if collRect.w < collRect.h then 
				local decrease = math.abs(collRect.w)*signof(xmove); --how much to displace by
				if math.abs(collRect.w) >= math.abs(xmove) then --if it's more than we actually moved, then
					decrease = xmove; --lower the decrease to the actual movement
				end
				base.x = base.x - decrease; --correct course
				if base.collider.collidesWith(collisions[1].collider) then --that didn't work
					base.x = preX + xmove; --reset to the original movement attempt
					base.y = preY + ymove;
					decrease = math.abs(collRect.h)*signof(ymove); --get a new amount to displace by
					if math.abs(collRect.h) >= math.abs(ymove) then --if it's more than we blah blah blah
						decrease = ymove;
					end
					base.y = base.y - decrease; --correct course
					if base.collider.collidesWith(collisions[1].collider) then --that didn't work either???
						error("we can't get out!!!");
					else --okay cool we're done
						ymove = ymove - decrease;
					end
				else --okay cool we're done
					xmove = xmove - decrease;
				end
			else
				local decrease = math.abs(collRect.h)*signof(ymove); --how much to displace by
				if math.abs(collRect.h) >= math.abs(ymove) then --if it's more than we actually moved, then
					decrease = ymove; --lower the decrease to the actual movement
				end
				base.y = base.y - decrease; --correct course
				if base.collider.collidesWith(collisions[1].collider) then --that didn't work
					base.x = preX + xmove; --reset to the original movement attempt
					base.y = preY + ymove;
					decrease = math.abs(collRect.w)*signof(xmove); --get a new amount to displace by
					if math.abs(collRect.w) >= math.abs(xmove) then --if it's more than we blah blah blah
						decrease = xmove;
					end
					base.x = base.x - decrease; --correct course
					if base.collider.collidesWith(collisions[1].collider) then --that didn't work either???
						error("we can't get out!!!");
					else --okay cool we're done
						xmove = xmove - decrease;
					end
				else --okay cool we're done
					ymove = ymove - decrease;
				end
			end
			collisions = game.room.getCollisions(base.collider);
		end
		
	end
	
	base.updateSprite = function(horiz,vert)
		
		if horiz == 0 and vert == 0 then
			if base.lastHoriz > 0 then
				if base.lastVert > 0 then
					base.currentAnim = "se";
				elseif base.lastVert < 0 then
					base.currentAnim = "ne";
				else
					base.currentAnim = "e";
				end
			elseif base.lastHoriz < 0 then
				if base.lastVert > 0 then
					base.currentAnim = "sw";
				elseif base.lastVert < 0 then
					base.currentAnim = "nw";
				else
					base.currentAnim = "w";
				end
			else
				if base.lastVert > 0 then
					base.currentAnim = "s";
				elseif base.lastVert < 0 then
					base.currentAnim = "n";
				else
					--last frame we were idle, so do nothing
				end
			end
			base.currentDir = base.currentAnim;
			base.moveSecs[base.currentDir] = (base.moveSecs[base.currentDir] or 0) + (love.timer.getDelta());
		else
			if horiz > 0 then
				if vert > 0 then
					base.currentAnim = "se_move";
				elseif vert < 0 then
					base.currentAnim = "ne_move";
				else
					base.currentAnim = "e_move";
				end
			elseif horiz < 0 then
				if vert > 0 then
					base.currentAnim = "sw_move";
				elseif vert < 0 then
					base.currentAnim = "nw_move";
				else
					base.currentAnim = "w_move";
				end
			else
				if vert > 0 then
					base.currentAnim = "s_move";
				elseif vert < 0 then
					base.currentAnim = "n_move";
				else
					error("unreachable movement state");
				end
			end
		end
		base.lastHoriz = horiz;
		base.lastVert = vert;
	end
	
	--[[base.oldDraw = base.draw;
	base.draw = function()
		base.oldDraw();
		local dirs = {"n","e","s","w"};
		for i=1,#dirs,1 do
			base.inspector.zones[(dirs[i])]().draw();
		end
		love.graphics.print(base.currentAnim,base.x,base.y-base.canvas:getHeight());
	end]]--
	
	return base;
end