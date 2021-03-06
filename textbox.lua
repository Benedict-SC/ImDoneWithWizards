Textbox = function(w,h)
	box = {};
	box.bg = BorderedThing(2,gameheight,1.1,"images/paperborder2.png",w,h,12,9);
	box.padding = 2;
	box.w = w;
	box.h = h;
	box.x = box.bg.x;
	box.y = box.bg.y;	
	box.string = "<f=OpenDyslexic><s=13>some words <c=#0033FF>that are <b>blue <i>and bold</i> but not italic</b></c> get <b>printed.</b> Here's a <i>really long one that just keeps going and going and going and going</i> and stretches over multiple lines oh<s=12> dear</s> that's a porblem</s></f>";
	box.portrait = ImageThing(-200,200,1.5,"images/guyman.png");
	box.tinyarrow = love.graphics.newImage("images/tinyarrow.png");
	box.portrait.offsetLeft = 0;
	box.portrait.offsetRight = 0;
	box.optionalYPadding = 0;
	box.extras = Array();
	--box.swappingPortrait = Thing(0,0,1.6);
	box.td = TextDrawer(Rect(0,0,1,1),love.font.getFormattedStrings(box.string),0);
	box.charmax = love.font.formattedStringLength(box.td.fstrings);
	box.advQueued = false;
	box.beep = nil;
	box.setBeeps = function(character)
		if sound.beeps[character] then
			box.beep = character;
			sound.beep(character);
		else
			sound.debeep(character);
			box.beep = nil;
		end
	end
	box.onClose = function()
	end
	
	box.setPadding = function(px)
		box.padding = px;
		box.resize();
	end
	box.setDimensions = function(width,height)
		if width > 0 then 
			box.w = width; 
		end
		if height > 0 then 
			box.h = height;
		end
		box.resize();
	end
	box.setText = function(ftext)
		local fstrings = love.font.getFormattedStrings(ftext);
		box.td.fstrings = fstrings;
		box.charmax = love.font.formattedStringLength(fstrings);
	end
	box.resize = function()
		local rport = box.portrait;
		if box.pstate == "SWAPPING" then
			rport = box.swappingPortrait;
		end
		box.bg.w = box.w;
		box.bg.h = box.h;
		box.bg.x = box.x;
		box.bg.y = box.y;
		box.td.rect.x = box.bg.x+box.bg.bw+box.padding + rport.width() + rport.offsetRight + rport.offsetLeft;
		box.td.rect.y = box.bg.y+box.bg.bh+box.padding + box.optionalYPadding;
		box.td.rect.w = w - (2*box.bg.bw) - (2*box.padding) - rport.width() - rport.offsetRight - rport.offsetLeft;
		box.td.rect.h = h - (2*box.bg.bh) - (2*box.padding);
	end
	box.draw = function()
		local boxcanvas = love.graphics.newCanvas(gamewidth,gameheight);
		love.graphics.pushCanvas(boxcanvas);
			box.bg.draw();
			box.td.draw();
			box.portrait.draw();
			if box.pstate == "SWAPPING" then 
				box.swappingPortrait.draw();
			end
			if box.state == "CHOOSING" or box.state == "DELAY" then
				for i=1,#(box.choices),1 do
					if i == game.convo.choice then
						local choice = box.choices[i];
						local roundRect = Rect(choice.rect.x-2,choice.rect.y-2,choice.fullwidth+4,13);
						pushColor();
						love.graphics.setColor(1,1,1,0.7843);
						love.graphics.rectangle("fill",roundRect.x,roundRect.y,roundRect.w,roundRect.h,3,3);
						popColor();
						love.graphics.draw(box.tinyarrow,roundRect.x - 6,roundRect.y+4);
					end
					box.choices[i].draw();
				end
			end
			thingsUtil.renderThings(box.extras);
			if #(box.extras) > 0 then
				--error(box.extras[1].y);
			end
		love.graphics.popCanvas();
		love.graphics.draw(boxcanvas,game.shake.x,game.shake.y);
	end
	
	--box states: RISING,TYPING,WAITING,FALLING,CHOOSING,HIDDEN,HOLDING,EVIDENCE
	--portrait states: SWAPPING,WAITING
	box.state = "HIDDEN";
	box.pstate = "WAITING";
	box.speed = 8;
	box.pframes = 9;
	box.update = function()
		--box update
		if box.state == "RISING" then
			local risetop = gameheight - box.h - box.padding;
			if box.y > risetop then
				box.y = box.y - box.speed;
				if box.y <= risetop then
					box.y = risetop;
					box.state = "TYPING";
					if game.convo.getCurrentLine().silent then	
						box.setBeeps("quiet");
					else
						box.setBeeps(game.convo.getPortrait().character);
					end
				end
			end
			box.resize();
		elseif box.state == "TYPING" then
			if box.td.charsDrawn < box.charmax then
				--local prevDrawn = math.floor(box.td.charsDrawn);
				local charspeed = ((input.action or input.cancel) and box.td.charsDrawn > 6) and 2.5 or 0.5;  
				box.td.charsDrawn = box.td.charsDrawn + charspeed;
				if pressedThisFrame["menu"] then
					box.td.charsDrawn = box.charmax;
				end
				--if math.floor(box.td.charsDrawn) > prevDrawn then
				--	sound.play(box.beep);
				--end
			else
				box.shutPortraitUp();
				sound.debeep(box.beep);
				local line = game.convo.getCurrentLine();
				if line.choices then
					box.choices = Array();
					local offset = 50 - (11*#(line.choices))
					for i=1,#(line.choices),1 do
						local choiceFstrings = love.font.getFormattedStrings("<f=OpenDyslexic><c=#DD00DD>"..line.choices[i].text .. "</c></f>");
						local cRect = Rect(box.td.rect.x,box.td.rect.y + offset + (12*i),box.td.rect.w,box.td.rect.h);
						local textDrawer = TextDrawer(cRect,choiceFstrings,1000);
						textDrawer.fullwidth = love.font.formattedStringWidth(choiceFstrings);
						box.choices.push(textDrawer);
					end
					box.state = "CHOOSING";--[[ 
					box.state = "DELAY";
					lifetime.delay(50,function() box.state = "CHOOSING" end) ]]
					--local delay = Lifetime(box,40);
					--delay.update = nilf;
					--delay.death = function()
					--	delay.thing.state = "CHOOSING";
					--end
					--mortalCoil.push(delay);
				else
					box.state = "WAITING";
					if line.auto then 
						box.advQueued = true;
						scriptools.wait(0.6,function()
							if box.advQueued then
								box.advQueued = false;
								game.convo.advance();		
							end				
						end);
					end
				end
			end
		elseif box.state == "WAITING" then
			
		elseif box.state == "CHOOSING" then
			
		elseif box.state == "FALLING" then
			local bottom = gameheight;
			if box.y < bottom then
				box.y = box.y + box.speed;
				if box.y >= bottom then
					box.y = bottom;
					box.td.charsDrawn = 0;
					box.state = "HIDDEN";
					if box.onClose then
						box.onClose();
					end
				end
			end
			box.resize();
		elseif box.state == "HIDDEN" then
			--box.state = "RISING";
		elseif box.state == "HOLDING" then
			
		end
		--portrait update
		if box.pstate == "SWAPPING" then
			box.swappingPortrait.x = box.swappingPortrait.x + box.swapspeed;
			box.portrait.x = box.portrait.x - box.mainspeed;
			if box.swappingPortrait.x >= box.showspot then 
				box.swappingPortrait.x = box.showspot;
				box.portrait.x = box.hidespot;
				--swap them
				local temp = box.swappingPortrait;
				box.swappingPortrait = box.portrait;
				box.portrait = temp;
				box.portrait.z = 1.5;
				box.swappingPortrait.z = 1.6;
				
				box.pstate = "WAITING";
				box.resize();
				--box.swapPortraitTo(swappingPortrait); --debug testing thing
			end
		end
		--debug_console_string = "bstate: " .. box.state;
		--debug_console_string_2 = "pstate: " .. box.pstate;
	end
	box.portraitPadding = 10;
	box.swapPortraitTo = function(newport)
		box.swappingPortrait = newport;
		box.mainspeed = math.ceil((box.portrait.width() + box.portrait.offsetLeft) / box.pframes);
		box.swapspeed = math.ceil((newport.width() + newport.offsetLeft) / box.pframes);
		box.hidespot = -box.portrait.width()/2;
		box.showspot = (newport.width()/2) + box.portraitPadding + newport.offsetLeft;
		box.swappingPortrait.x = box.hidespot;
			--quickly swap out, resize box, and swap back.
				local temp = box.swappingPortrait;
				box.swappingPortrait = box.portrait;
				box.portrait = temp;
				box.resize();
				temp = box.swappingPortrait;
				box.swappingPortrait = box.portrait;
				box.portrait = temp;
		box.pstate = "SWAPPING";
	end
	box.startPortraitTalking = function()
		if box.pstate == "SWAPPING" then
			local exister = box.swappingPortrait;
			box.swappingPortrait = game.convo.getPortrait().talkingImg;
			box.swappingPortrait.x = exister.x;
			box.swappingPortrait.y = exister.y;
			box.swappingPortrait.z = exister.z;
		else
			local exister = box.portrait;
			box.portrait = game.convo.getPortrait().talkingImg;
			box.resize();
			box.portrait.x = exister.x;
			box.portrait.y = exister.y;
			box.portrait.z = exister.z;
		end
	end
	box.shutPortraitUp = function()
		if box.pstate == "SWAPPING" then
			local exister = box.swappingPortrait;
			box.swappingPortrait = game.convo.getPortrait().staticImg;
			box.swappingPortrait.x = exister.x;
			box.swappingPortrait.y = exister.y;
			box.swappingPortrait.z = exister.z;
		else
			local exister = box.portrait;
			box.portrait = game.convo.getPortrait().staticImg;
			box.portrait.x = exister.x;
			box.portrait.y = exister.y;
			box.portrait.z = exister.z;
		end
	end
	box.dismissBox = function(onComplete)
		sound.play("evidenceClose");
		local blanky = BlankThing();
		blanky.offsetLeft = 0;
		blanky.offsetRight = 0;
		box.swapPortraitTo(blanky);
		box.state = "FALLING";
		box.onClose = onComplete;
	end
	
	box.resize();
	return box;
end