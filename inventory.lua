tagBackground = love.graphics.newImage("images/evidence_tag.png");
Evidence = function(bigfilename,iconfilename,name,shortSummary,summary,color)
	local ev = {};
	
	ev.bigPic = love.graphics.newImage("images/evidence/" .. (bigfilename or "blank.png"));
	ev.icon = love.graphics.newImage("images/evidence/" .. (iconfilename or "test_icon.png"));
	ev.name = name or "Evidence";
	ev.shortSummary = shortSummary or "A piece of evidence."
	ev.summary = summary or "Here's what the evidence is."
	ev.bubbleColor = color or {r=255,g=255,b=255};
	
	ev.animateTag = function(cb)
		game.textbox.state = "HOLDING";
		local tagCanvas = love.graphics.newCanvas(491,358);
		love.graphics.pushCanvas(tagCanvas);
			love.graphics.draw(tagBackground,0,0);
			love.graphics.draw(ev.bigPic,60,47);
			local rect = Rect(300,47,160,220);
			local fstrings = love.font.getFormattedStrings(ev.summary);
			local drawer = TextDrawer(rect,fstrings,1000);
			drawer.draw();
		love.graphics.popCanvas(tagCanvas);
		ev.tag = ImageyCanvasThing(gamewidth+250,gameheight/2 + 180,1.1,tagCanvas);
		game.textbox.extras.push(ev.tag);
		--time for two stupid layers of lifetimes, with input waiting in between
		local anim = Lifetime(ev.tag,20); --object is the tag canvasthing
		anim.thing.animationCallback = cb; --give the tag a function to call when it's all done animating
		anim.update = function()
			anim.thing.x = anim.thing.x - math.ceil(gamewidth/20);
			if (anim.thing.x <= gamewidth/2) then
				anim.lifespan = 0;
			end
		end
		anim.death = function() --when it reaches the middle of the screen
			anim.thing.x = gamewidth/2;
			game.textbox.state = "EVIDENCE";
			game.player.resumeEvidenceTag = anim.thing; --hand the tag and a new function to the player so it can pass it back on input
			game.player.resumeEvidenceFunction = function(tag)
				local part2 = Lifetime(tag,20);
				part2.update = function()
					part2.thing.x = part2.thing.x - math.ceil(gamewidth/20);
					if (part2.thing.x <= - 250) then
						part2.lifespan = 0;
						part2.thing.x = -250;
					end
				end
				part2.death = function() --finally call the callback, and destroy the tag
					part2.thing.animationCallback();
					game.textbox.extras.removeElement(part2.thing);
				end
				mortalCoil.push(part2);
			end
		end
		mortalCoil.push(anim);
	end
	
	return ev;
end

Inventory = function()
	local inv = {};
	inv.list = Array();
	local curiosity = Evidence();
	curiosity.icon = love.graphics.newImage("images/evidence/curiosity.png");
	curiosity.name = "Uncertainty";
	curiosity.shortSummary = "I need to know more."
	inv.list.push(curiosity);
	--for i=1,6,1 do inv.list.push(Evidence()) end --fake entries
	
	--set up resources
	inv.maskHeight = 400;
	inv.canvas = love.graphics.newCanvas(150, inv.maskHeight);
	inv.bubble = love.graphics.newImage("images/smallballoon.png");
	inv.entryHeight = 47;
	inv.namefont = love.graphics.newFont("fonts/OpenDyslexic-Bold.otf",12);
	inv.shortsummaryfont = love.graphics.newFont("fonts/OpenDyslexic-Italic.otf",8);
	inv.gradientShader = love.graphics.newShader[[
		vec4 effect( vec4 color, Image texture, vec2 texpoint, vec2 screenpoint){
			vec4 pixel = Texel(texture, texpoint);
			pixel *= color;
			if(pixel.a == 0){
				return pixel;
			}
			if(texpoint.y <= 0.1){
				number alpha = (0.1 - (0.1 - texpoint.y)) * 10.0;
				if(pixel.a > alpha){
					pixel.a = alpha;
				}
				return pixel;
			}else if(texpoint.y >=0.9){
				number alpha = (1.0 - texpoint.y) * 10.0;
				if(pixel.a > alpha){
					pixel.a = alpha;
				}
				return pixel;
			}else{
				return pixel;
			}
		}
	]]
	--declare functions
	inv.currentEvidence = function()
		return inv.list[inv.selectPosition];
	end
	inv.activateDropdown = function(x,y)
		sfx.play(sfx.evidenceOpen);
		inv.collapsing = true;
		inv.dropdownX = x;
		inv.dropdownY = y - inv.maskHeight/2;
		inv.dropdownAcc = 0.16;
		local grower = Lifetime(inv,12);
		grower.update = function()
			grower.thing.dropdownPercent = grower.thing.dropdownPercent + grower.thing.dropdownAcc;
			grower.thing.dropdownAcc = grower.thing.dropdownAcc * 0.85;
			if grower.thing.dropdownPercent > 1 then 
				grower.lifespan = 0;
			end
		end
		grower.death = function()
			grower.thing.dropdownPercent = 1;
			inv.collapsing = false;
		end
		mortalCoil.push(grower);
	end
	inv.deactivateDropdown = function(callback)
		sfx.play(sfx.evidenceClose);
		inv.collapsing = true;
		inv.dropdownAcc = -0.06;
		local grower = Lifetime(inv,18);
		grower.update = function()
			if grower.thing.dropdownPercent < 0 then 
				grower.thing.dropdownPercent = 0;
				return;
			end
			grower.thing.dropdownPercent = grower.thing.dropdownPercent + grower.thing.dropdownAcc;
			grower.thing.dropdownAcc = grower.thing.dropdownAcc * 1.3;
		end
		grower.death = function()
			grower.thing.dropdownPercent = 0;
			inv.collapsing = false;
			callback();
		end
		mortalCoil.push(grower);
	end
	inv.moveDown = function()
		inv.selectPosition = inv.selectPosition + 1;
		if inv.selectPosition > #(inv.list) then
			inv.selectPosition = #(inv.list);
		else
			inv.animateMoving(inv.selectPosition - 1);
		end
	end
	inv.moveUp = function()
		inv.selectPosition = inv.selectPosition - 1;
		if inv.selectPosition < 1 then
			inv.selectPosition = 1;
		else
			inv.animateMoving(inv.selectPosition + 1);
		end
	end
	inv.animateMoving = function(oldIdx)
		sfx.play(sfx.evidenceScroll);
		local animator = Lifetime(inv,8);
		inv.animatingMove = true;
		inv.animationOffset = inv.entryHeight;
		animator.oldEvidence = inv.list[inv.selectPosition];
		animator.newEvidence = inv.list[oldIdx];
		animator.percent = 0;
		animator.sign = oldIdx - inv.selectPosition;
		animator.update = function()
			animator.percent = animator.percent + .2;
			if animator.percent > 1 then animator.percent = 1 end;
			animator.newEvidence.bubbleColor = {r=255,g=math.floor(128 + 128*animator.percent),b=255};
			animator.oldEvidence.bubbleColor = {r=255,g=math.floor(255 - (128*animator.percent)),b=255};
			animator.thing.animationOffset = math.floor(animator.thing.entryHeight * animator.percent * animator.sign);
			animator.thing.animationOffset = animator.thing.animationOffset + (-signof(animator.thing.animationOffset)*animator.thing.entryHeight)
		end
		animator.death = function()
			animator.oldEvidence.bubbleColor = {r=255,g=255,b=255};
			animator.newEvidence.bubbleColor = {r=255,g=255,b=255};		
			inv.animatingMove = false;
			inv.animationOffset = 0;
		end
		mortalCoil.push(animator);
		animator.update();
		animator.percent = animator.percent - 0.2;
	end
	--draw the dropdown
	inv.selectPosition = 1;
	inv.dropdownX = 300;
	inv.dropdownY = 300;
	inv.dropdownPercent = .5;
	inv.dropdownDraw = function()
		love.graphics.pushCanvas(inv.canvas);
			love.graphics.clear();
			local r,g,b,a = love.graphics.getColor();
			local alpha = 255;
			if (inv.dropdownAcc < 0) then 
				alpha = 255*inv.dropdownPercent;
				love.graphics.setColor(255,255,255,alpha);
			end
			local pixelGap = math.floor(inv.dropdownPercent * inv.entryHeight);
			for i=1,#(inv.list),1 do --draw all the background ones
				if not (i == inv.selectPosition) then
					local evidence = inv.list[i];
					
					local offset = pixelGap * (i-inv.selectPosition);
					if inv.animatingMove then
						offset = offset+inv.animationOffset; --add the offset
					end
					if math.abs(offset) < ((inv.maskHeight/2) + inv.entryHeight) then --check if offscreen
						local y = inv.maskHeight/2 + offset - (math.floor(inv.entryHeight));
						if inv.animatingMove then
							pushColor();
							love.graphics.setColor(evidence.bubbleColor.r,evidence.bubbleColor.g,evidence.bubbleColor.b,alpha);
							love.graphics.draw(inv.bubble,0,y);
							popColor();
						else
							love.graphics.draw(inv.bubble,0,y);
						end
						inv.drawBubbleContents(evidence,y,alpha);
					end
					--draw text up ins
					--draw a pic
				end
			end
			--draw the main ones
			local evidence = inv.list[inv.selectPosition];
			local y = inv.maskHeight/2 - (math.floor(inv.entryHeight));
			if inv.animatingMove then
				pushColor();
				love.graphics.setColor(evidence.bubbleColor.r,evidence.bubbleColor.g,evidence.bubbleColor.b,alpha);
				love.graphics.draw(inv.bubble,0,y+inv.animationOffset);
				popColor();
				inv.drawBubbleContents(evidence,y+inv.animationOffset,alpha);
			else
				pushColor();
				love.graphics.setColor(255,128,255,alpha);
				love.graphics.draw(inv.bubble,0,y);
				popColor();
				inv.drawBubbleContents(evidence,y,alpha);
			end
			if (inv.dropdownAcc < 0) then 
				love.graphics.setColor(r,g,b,a);
			end
		love.graphics.popCanvas();
		love.graphics.setShader(inv.gradientShader);
		love.graphics.draw(inv.canvas,inv.dropdownX,inv.dropdownY);
		love.graphics.setShader();
	end
	inv.drawBubbleContents = function(evidence,y,alpha)
		love.graphics.draw(evidence.icon,8,y + 11);
		pushColor();
		love.graphics.setColor(0,0,0,alpha);
		love.graphics.setFont(inv.namefont);
		love.graphics.print(evidence.name,50,y+11);
		love.graphics.setColor(100,100,100,alpha);
		love.graphics.setFont(inv.shortsummaryfont);
		love.graphics.print(evidence.shortSummary,48,y+28);
		popColor();
	end
	
	return inv;
end