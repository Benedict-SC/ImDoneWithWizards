Fragment = function(filename)
	local frag = {};
	local jstring = love.filesystem.read("json/hypotheses/".. filename .. ".json");
	frag.json = json.decode(jstring);
	frag.filename = filename;
	frag.seen = false;
	
	frag.loadIn = function()
		local infix = frag.json.folder and (frag.json.folder .. "/") or "";
		frag.text = ImageThing(0,0,0,"images/hypotheses/".. infix .. frag.json.bg ..".png");
		frag.questions = Array(); --note: this is just the menu objects. they contain no data
		if frag.json.questions then
			for i=1,#(frag.json.questions),1 do
				local q = frag.json.questions[i];
				local qfile = "images/hypotheses/" .. infix .. frag.json.bg .. "_" .. q.filename .. ".png";
				local qimg = ImageThing(q.x - gamewidth/2,q.y - gameheight,0.2,qfile);
				frag.questions.push(qimg);
				frag.questions[q.filename] = qimg;
				if not (i==game.hypothesis.activeQuestion) then
					qimg.deactivate();
				end
			end
		else
		
		end
	end
	frag.unload = function()
		frag.text = BlankThing();
		frag.questions = nil;
	end
	frag.see = function()
		if not (frag.seen) then
			frag.seen = true;
		end
	end
	
	return frag;
end

Hypothesis = function(filename)
	local hyp = {};

	local jstring = love.filesystem.read(filename);
	hyp.json = json.decode(jstring);
	hyp.fragmentList = Array();
	for i=1,#(hyp.json.fragments),1 do
		local frag = Fragment(hyp.json.fragments[i]);
		hyp.fragmentList.push(frag);
		frag.seen = true;
	end
	hyp.activeFragment = 1;
	hyp.fragmentPos = {x=gamewidth/2,y=0,z=1.1};
	hyp.cloud = ImageThing(0,0,0,"images/bigballoon2.png");
	hyp.transitions = love.graphics.newImage("images/transitionbubbles2.png");
	hyp.lArrow = AnimatedThing(0,0,0,"arrowleft");
	hyp.rArrow = AnimatedThing(0,0,0,"arrowright");
	hyp.transitionXLeft = -153;
	hyp.transitionXRight = 120;
	hyp.transitionY = -gameheight + 20;
	hyp.ctrlAx = 12;
	hyp.ctrlDx = 14;
	hyp.ctrlY = 82;
	hyp.arrowX = -1; --relative to the controls
	hyp.arrowY = 14;--relative to the controls
	hyp.questions = Array();
	hyp.activeQuestion = 1;
	hyp.sheen = ImageThing(-gamewidth,gameheight,1,"images/sheen.png");
	hyp.changed = false;
	
	hyp.guy = ImageThing(gamewidth/2,gameheight,1.05,"images/guyhead.png");
	hyp.guylow = hyp.guy.img:getHeight() + gameheight;
	hyp.guy.y = hyp.guylow;	

	hyp.replaceFragment = function(id, fragFile)
		local frag = Fragment(fragFile);
		local findFrag = hyp.indexOfFragment(id);
		if findFrag == 0 then
			return;
		end
		hyp.fragmentList[findFrag] = frag;
		hyp.activeQuestion = 1;
		hyp.changed = true;
	end
	hyp.addFragment = function(fragfile)
		local frag = Fragment(fragfile);
		hyp.fragmentList.push(frag);
		hyp.changed = true;
		return #(hyp.fragmentList);
	end
	hyp.insertFragment = function(index,fragfile)
		local frag = Fragment(fragfile);
		table.insert(hyp.fragmentList,index,frag);
		if hyp.activeFragment >= index then
			hyp.activeFragment = hyp.activeFragment + 1;
		end
		hyp.changed = true;
		return #(hyp.fragmentList);
	end
	hyp.deleteFragment = function(fragfile)
		for i=1,#(hyp.fragmentList),1 do
			local frag = hyp.fragmentList[i];
			if frag.filename == fragfile then 
				table.remove(hyp.fragmentList,i);
				if hyp.activeFragment >= i and hyp.activeFragment > 1 then
					hyp.activeFragment = hyp.activeFragment - 1;
				end
				hyp.changed = true;
				return;
			end
		end
	end
	hyp.indexOfFragment = function(fileId)
		for i=1,#(hyp.fragmentList),1 do
			local frag = hyp.fragmentList[i];
			if frag.filename == fileId then return i; end
		end
		return 0;
	end
	hyp.currentFragment = function()
		return hyp.fragmentList[hyp.activeFragment];
	end
	hyp.currentQuestion = function()
		return hyp.currentFragment().json.questions[hyp.activeQuestion];
	end
	
	hyp.seeAll = function()
		for i=1,#(hyp.fragmentList),1 do
			local frag = hyp.fragmentList[i];
			frag.seen = true;
		end
	end
	
	hyp.draw = function()
		love.graphics.setFont(loadedFonts["TitleOption"]);
		if not (hyp.state == "LEFT" or hyp.state == "RIGHT") then
			if hyp.fragmentPos.y > 0 then
				hyp.cloud.offsetDraw(hyp.fragmentPos.x,hyp.fragmentPos.y);
				if not (hyp.activeFragment == 1) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+hyp.transitionXLeft,hyp.fragmentPos.y+hyp.transitionY);
					printInColor("A",hyp.fragmentPos.x+hyp.transitionXLeft + hyp.ctrlAx,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY,hyp.lCols.r,hyp.lCols.g,hyp.lCols.b);
					love.graphics.draw(hyp.lArrow.getFrame(),hyp.fragmentPos.x+hyp.transitionXLeft + hyp.ctrlAx + hyp.arrowX,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY + hyp.arrowY);
				end
				if not (hyp.activeFragment == #(hyp.fragmentList)) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+hyp.transitionXRight,hyp.fragmentPos.y+hyp.transitionY);
					printInColor("D",hyp.fragmentPos.x+hyp.transitionXRight + hyp.ctrlDx,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY,hyp.rCols.r,hyp.rCols.g,hyp.rCols.b);
					love.graphics.draw(hyp.rArrow.getFrame(),hyp.fragmentPos.x+hyp.transitionXRight + hyp.ctrlAx + hyp.arrowX,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY + hyp.arrowY);
				end
				local frag = hyp.fragmentList[hyp.activeFragment];
				frag.text.offsetDraw(hyp.fragmentPos.x,hyp.fragmentPos.y);
				for i=1,#(frag.questions),1 do
					frag.questions[i].offsetDraw(hyp.fragmentPos.x,hyp.fragmentPos.y)
				end
			end
		else
			hyp.cloud.offsetDraw(hyp.fragmentPos.x + hyp.sideOffset,hyp.fragmentPos.y);
			if not (hyp.oldFragment == 1) then
				love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+hyp.transitionXLeft + hyp.sideOffset,hyp.fragmentPos.y+hyp.transitionY);
					printInColor("A",hyp.fragmentPos.x +hyp.transitionXLeft + hyp.sideOffset+ hyp.ctrlAx,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY,hyp.lCols.r,hyp.lCols.g,hyp.lCols.b);
			end
			if not (hyp.oldFragment == #(hyp.fragmentList)) then
				love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+hyp.transitionXRight + hyp.sideOffset,hyp.fragmentPos.y+hyp.transitionY);
					printInColor("D",hyp.fragmentPos.x+hyp.transitionXRight + hyp.sideOffset + hyp.ctrlDx,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY,hyp.rCols.r,hyp.rCols.g,hyp.rCols.b);
			end
			if hyp.state == "LEFT" then
				if not (hyp.activeFragment == 1) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+hyp.transitionXLeft+ hyp.sideOffset-gamewidth,hyp.fragmentPos.y+hyp.transitionY);
					printInColor("A",hyp.fragmentPos.x+hyp.transitionXRight+ hyp.sideOffset-gamewidth + hyp.ctrlAx,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY,hyp.lCols.r,hyp.lCols.g,hyp.lCols.b);
				end
			else
				if not (hyp.activeFragment == #(hyp.fragmentList)) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+hyp.transitionXRight+ hyp.sideOffset+gamewidth,hyp.fragmentPos.y+hyp.transitionY);
					printInColor("D",hyp.fragmentPos.x+hyp.transitionXRight+ hyp.sideOffset+gamewidth + hyp.ctrlDx,hyp.fragmentPos.y+hyp.transitionY + hyp.ctrlY,hyp.rCols.r,hyp.rCols.g,hyp.rCols.b);
				end
			end
			local frag = hyp.fragmentList[hyp.oldFragment];
			frag.text.offsetDraw(hyp.fragmentPos.x + hyp.sideOffset,hyp.fragmentPos.y);
			for i=1,#(frag.questions),1 do
				frag.questions[i].offsetDraw(hyp.fragmentPos.x + hyp.sideOffset,hyp.fragmentPos.y)
			end
			local newfrag = hyp.fragmentList[hyp.activeFragment];
			local bigOffset = (hyp.state == "LEFT") and hyp.sideOffsetMax or -hyp.sideOffsetMax;
			hyp.cloud.offsetDraw(hyp.fragmentPos.x + hyp.sideOffset - bigOffset,hyp.fragmentPos.y);
			newfrag.text.offsetDraw(hyp.fragmentPos.x + hyp.sideOffset - bigOffset,hyp.fragmentPos.y);
			for i=1,#(newfrag.questions),1 do
				newfrag.questions[i].offsetDraw(hyp.fragmentPos.x + hyp.sideOffset - bigOffset,hyp.fragmentPos.y)
			end
		end
		if hyp.state == "SELECT" or hyp.state == "LEFT" or hyp.state == "RIGHT" then
			love.graphics.setShader(sheenShader);
			hyp.sheen.draw();
			love.graphics.setShader();
		end
		if hyp.guy.y < hyp.guylow then
			hyp.guy.draw();
			printInColor("X",hyp.guy.x - 109,hyp.guy.y - 19,0,0,0);
		end
		if hyp.state == "EVIDENCE" then
			game.inventory.dropdownDraw();
		end
	end
	hyp.blinkControls = function()
		local left = false;
		for i=1,hyp.activeFragment-1,1 do
			local frag = hyp.fragmentList[i];
			if not (frag.seen) then
				hyp.lBlinkHandle.cancel = true;
				hyp.blinkLeft();
				break;
			end
		end
		local right = false;
		for i=hyp.activeFragment+1,#(hyp.fragmentList),1 do
			local frag = hyp.fragmentList[i];
			if not (frag.seen) then
				hyp.rBlinkHandle.cancel = true;
				hyp.blinkRight();
				break;
			end
		end
	end
	hyp.gray = {r=193,g=193,b=193};
	hyp.pink = {r=251,g=71,b=232};
	hyp.colorDiffs = {r=hyp.pink.r-hyp.gray.r,g=hyp.pink.g-hyp.gray.g,b=hyp.pink.b-hyp.gray.b};
	hyp.lCols = {r=hyp.gray.r,g=hyp.gray.g,b=hyp.gray.b};
	hyp.rCols = {r=hyp.gray.r,g=hyp.gray.g,b=hyp.gray.b};
	hyp.rBlinkHandle = {};
	hyp.lBlinkHandle = {};
	hyp.blinkLeft = function()
		local lastBlinkOrigin = hyp.activeFragment;
		hyp.lBlinkHandle = scriptools.doOverTime(1.2,function(percent) 
			local pinkness = 1-(2*math.abs(.5-percent));
			game.hypothesis.lCols = {r=game.hypothesis.gray.r + (pinkness*game.hypothesis.colorDiffs.r),g=game.hypothesis.gray.g + (pinkness*game.hypothesis.colorDiffs.g),b=game.hypothesis.gray.b + (pinkness*game.hypothesis.colorDiffs.b)}
		end,function()
			if (game.hypothesis.activeFragment == lastBlinkOrigin) and (game.hypothesis.state == "SELECT") then
				game.hypothesis.blinkLeft();
			end
			game.hypothesis.lCols = {r=game.hypothesis.gray.r,g=game.hypothesis.gray.g,b=game.hypothesis.gray.b};
		end);
	end
	hyp.blinkRight = function()
		local lastBlinkOrigin = hyp.activeFragment;
		hyp.rBlinkHandle = scriptools.doOverTime(1.2,function(percent)
			local pinkness = 1-(2*math.abs(.5-percent)); 
			game.hypothesis.rCols = {r=game.hypothesis.gray.r + (pinkness*game.hypothesis.colorDiffs.r),g=game.hypothesis.gray.g + (pinkness*game.hypothesis.colorDiffs.g),b=game.hypothesis.gray.b + (pinkness*game.hypothesis.colorDiffs.b)}
		end,function()
			if (game.hypothesis.activeFragment == lastBlinkOrigin) and (game.hypothesis.state == "SELECT") then
				game.hypothesis.blinkRight();
			end
			game.hypothesis.rCols = {r=game.hypothesis.gray.r,g=game.hypothesis.gray.g,b=game.hypothesis.gray.b};
		end);
	end
	--states: APPEARING,LEFT,RIGHT,SELECT,EVIDENCE,HIDING
	hyp.state = "HIDDEN";
	hyp.showframes = 9;
	hyp.update = function()
		local frag = hyp.fragmentList[hyp.activeFragment];
		if hyp.state == "APPEARING" then
			hyp.fragmentPos.y = hyp.fragmentPos.y + hyp.bubblespeed;
			hyp.guy.y = hyp.guy.y + hyp.guyspeed;
			if hyp.fragmentPos.y >= gameheight then
				hyp.fragmentPos.y = gameheight;
				hyp.guy.y = gameheight + 5;
				hyp.state = "SELECT";
				hyp.blinkControls();
				hyp.fragmentList[hyp.activeFragment].see();
				local textImg = hyp.fragmentList[hyp.activeFragment].text.img;
				sheenShader:send("fragtext",textImg);
				sheenShader:send("gwidth",gamewidth);
				sheenShader:send("gheight",gameheight);
				sheenShader:send("offset",0.0);
				if (hyp.changed) then
					sound.play("hypothesisUpdated");
					hyp.changed = false;
				end
			end
		elseif hyp.state == "LEFT" then
			
		elseif hyp.state == "RIGHT" then

		elseif hyp.state == "SELECT" then
			if pressedThisFrame.down or pressedThisFrame.right or pressedThisFrame.up or pressedThisFrame.left then
				if #(frag.questions) > 0 then
					local oldQuestion = hyp.activeQuestion;
					local questionId;
					if pressedThisFrame.down then
						questionId = frag.json.questions[hyp.activeQuestion].down;
					elseif pressedThisFrame.up then
						questionId = frag.json.questions[hyp.activeQuestion].up;
					elseif pressedThisFrame.left then
						questionId = frag.json.questions[hyp.activeQuestion].left;
					elseif pressedThisFrame.right then 
						questionId = frag.json.questions[hyp.activeQuestion].right;
					end
					local newQ = frag.questions[questionId];
					hyp.activeQuestion = frag.questions.indexOf(newQ);
					frag.questions[oldQuestion].deactivate();
					frag.questions[hyp.activeQuestion].activate();
					sound.play("questionBeep");
					lifetime.shake(frag.questions[hyp.activeQuestion]);
				else
					hyp.shaHeen();
				end
			elseif pressedThisFrame.cancel then
				hyp.hide(function() game.player.state = "MOVING" end);
			elseif pressedThisFrame.action then
				if #(frag.questions) > 0 then
					hyp.state = "EVIDENCE";
					local q = frag.questions[hyp.activeQuestion];
					local xmax = math.floor(hyp.fragmentPos.x + q.x + q.img:getWidth()/2);
					local xmin = math.floor(hyp.fragmentPos.x + q.x - (q.img:getWidth()/2) - game.inventory.bubbleWidth);
					local x = 0;
					if xmax + game.inventory.bubbleWidth > gamewidth then --does it not fit on the right?
						if xmin < 0 then --does it not fit on the left?
							--figure out which side will obscure less of the text and put it there
							local minwidth = xmin; 
							local maxwidth = gamewidth - xmax;
							if maxwidth >= minwidth then
								x = gamewidth - game.inventory.bubbleWidth;
							else
								x = 0;
							end
						else --put it on the left
							x = xmin;
						end
					else --put it on the right
						x = xmax;
					end
					--debug_console_string = "x: " .. x;
					local y = math.floor(hyp.fragmentPos.y + q.y);
					if y < 70 then
						y = 70;
					end
					game.inventory.activateDropdown(x,y);
				else
					hyp.shaHeen();
				end
			elseif pressedThisFrame.leftTab then
				hyp.switchFragment(true);
			elseif pressedThisFrame.rightTab then
				hyp.switchFragment(false);
			end
		elseif hyp.state == "EVIDENCE" then
			if game.inventory.animatingMove or game.inventory.collapsing then 
				return; --don't allow input during animation
			end
			if pressedThisFrame.down then
				game.inventory.moveDown();
			elseif pressedThisFrame.up then
				game.inventory.moveUp();
			elseif pressedThisFrame.cancel then
				game.inventory.deactivateDropdown(function()
					hyp.state = "SELECT";
				end);
			elseif pressedThisFrame.action then
				local ev = game.inventory.currentEvidence();
				local question = frag.json.questions[hyp.activeQuestion];
				if question.evidences then
					local evidenceResult = question.evidences[ev.id];
					if evidenceResult then
						local convoId = evidenceResult.convo;
						game.convo = Convo("hypothesis/" .. convoId);
						sound.play("evidenceOpen");
						game.player.state = "TEXTBOX";
						hyp.hide(nilf);
						game.convo.start();
					else
						sound.play("invalid");
					end
				else
					sound.play("invalid");
				end
			end
		elseif hyp.state == "HIDING" then
			hyp.fragmentPos.y = hyp.fragmentPos.y + hyp.bubblespeed;
			hyp.guy.y = hyp.guy.y + hyp.guyspeed;
			if hyp.fragmentPos.y <= 0 then
				hyp.fragmentPos.y = 0;
				hyp.guy.y = hyp.guylow;
				hyp.state = "HIDDEN";
				hyp.fragmentList[hyp.activeFragment].unload();
				hyp.hideCallback();
			end
		elseif hyp.state == "HIDDEN" then
			--don't do nothin'
		end
	end
	hyp.switchFragment = function(left)
		hyp.oldFragment = hyp.activeFragment;
		if left then
			hyp.activeFragment = hyp.activeFragment - 1;
			if hyp.activeFragment <= 0 then 
				hyp.activeFragment = hyp.oldFragment;
				hyp.oldFragment = nil;
				return;
			else
				hyp.state = "LEFT";
			end
		else
			hyp.activeFragment = hyp.activeFragment + 1;
			if hyp.activeFragment > #(hyp.fragmentList) then 
				hyp.activeFragment = hyp.oldFragment;
				hyp.oldFragment = nil;
				return;
			else
				hyp.state = "RIGHT";
			end
		end
		hyp.oldQuestion = hyp.activeQuestion;
		hyp.activeQuestion = 1;
		hyp.fragmentList[hyp.activeFragment].loadIn();
		local textImg = hyp.fragmentList[hyp.oldFragment].text.img;
		if not textImg then error("no image"); end
		sheenShader:send("fragtext",textImg);
		sheenShader:send("gwidth",gamewidth);
		sheenShader:send("gheight",gameheight);
		hyp.sideOffsetMax = gamewidth;
		hyp.sideOffset = 0;
		sheenShader:send("offset",0.0);
		local slideDuration = 15;
		local slide = Lifetime(hyp,slideDuration);
		if left then 
			slide.update = function()
				slide.thing.sideOffset = slide.thing.sideOffset + (gamewidth/slideDuration);
				sheenShader:send("offset",slide.thing.sideOffset);
			end
		else
			slide.update = function()
				slide.thing.sideOffset = slide.thing.sideOffset - (gamewidth/slideDuration);
				sheenShader:send("offset",slide.thing.sideOffset);
			end
		end
		slide.death = function()
			hyp.state = "SELECT";
			hyp.blinkControls();
			slide.thing.sideOffset = 0;
			local textImg = hyp.fragmentList[hyp.activeFragment].text.img;
			sheenShader:send("fragtext",textImg);
			hyp.fragmentPos.x = gamewidth/2;
			hyp.fragmentList[hyp.oldFragment].unload();
			hyp.oldFragment = nil;
			hyp.fragmentList[hyp.activeFragment].see();
		end
		sound.play("fragmentWhoosh");
		mortalCoil.push(slide);
	
		
	end
	hyp.canShaHeen = true;
	hyp.shaHeen = function()
		if hyp.canShaHeen then
			sound.play("schwing");
			hyp.canShaHeen = false;
			sheenShader:send("offset",0.0);
			hyp.sheen.x = -gamewidth;
			scriptools.doOverTime(0.4,function(percent)
				hyp.sheen.x = -gamewidth + (percent*2*gamewidth);
			end,function()
				hyp.sheen.x = -gamewidth;
				hyp.canShaHeen = true;
			end);
		end
	end
	hyp.show = function()
        sound.play("evidenceOpen");
		if sound.bgmName == "bgmDemo" then
			sound.crossfadeBGM("hypothesisMusic","bgmDemo");
		end
		hyp.fragmentList[hyp.activeFragment].loadIn();
		hyp.bubblespeed = math.floor(hyp.cloud.img:getHeight() / hyp.showframes);
		hyp.guyspeed = -math.floor(hyp.guy.img:getHeight() / hyp.showframes);
		hyp.state = "APPEARING";
	end
	hyp.hide = function(cb)
        sound.play("evidenceClose");
		sound.crossfadeBGM("bgmDemo","hypothesisMusic");
		hyp.bubblespeed = -math.floor(hyp.cloud.img:getHeight() / hyp.showframes);
		hyp.guyspeed = math.floor(hyp.guy.img:getHeight() / hyp.showframes);
		hyp.state = "HIDING";
		hyp.hideCallback = cb;
		hyp.checkPhase(cb);
	end
	hyp.checkPhase = function(cb)
		if #(hyp.fragmentList) == 4 then 
			local Acheck = (hyp.fragmentList[1].filename == "A03");
			local BCcheck = (hyp.fragmentList[2].filename == "BC03");
			local Dcheck = (hyp.fragmentList[3].filename == "D03");
			local Echeck = (hyp.fragmentList[4].filename == "E03");
			if Acheck and BCcheck and Dcheck and Echeck then--hard-coded check for end of phase 1
				game.convo = Convo("cutscene/phase1");
				sound.play("evidenceOpen");
				game.player.state = "TEXTBOX";
				hyp.hideCallback = nilf;
				game.convo.start();
			end
			local Gcheck = (hyp.fragmentList[1].filename == "G02");
			local Hcheck = (hyp.fragmentList[2].filename == "H00");
			local Icheck = (hyp.fragmentList[3].filename == "I02");
			local Jcheck = (hyp.fragmentList[4].filename == "J03");
			if Gcheck and Hcheck and Icheck and Jcheck then--hard-coded check for end of phase 3
				runlua("cutscenes/phase3end.lua");
			end
		elseif #(hyp.fragmentList) == 5 then
			local Acheck = (hyp.fragmentList[1].filename == "A03");
			local Bcheck = (hyp.fragmentList[2].filename == "B00");
			local Ccheck = (hyp.fragmentList[3].filename == "C01");
			local Dcheck = (hyp.fragmentList[4].filename == "D04");
			local Echeck = (hyp.fragmentList[5].filename == "E03");
			if Acheck and Bcheck and Ccheck and Dcheck and Echeck then--hard-coded check for end of phase 2
				game.convo = Convo("cutscene/phase2end");
				sound.play("evidenceOpen");
				game.player.state = "TEXTBOX";
				hyp.hideCallback = nilf;
				game.convo.start();
			end
		elseif #(hyp.fragmentList) == 3 then
			local Kcheck = (hyp.fragmentList[1].filename == "K00");
			local Lcheck = (hyp.fragmentList[2].filename == "L03");
			local Mcheck = (hyp.fragmentList[3].filename == "M07");
			if Kcheck and Lcheck and Mcheck then--hard-coded check for end of phase 4
				game.convo = Convo("cutscene/phase4end");
				sound.play("evidenceOpen");
				game.player.state = "TEXTBOX";
				hyp.hideCallback = nilf;
				game.convo.start();
			end
		end
	end
	return hyp;
end

sheenShader = love.graphics.newShader[[
		extern Image fragtext;
		extern number gwidth;
		extern number gheight;
		extern number offset;
		vec4 effect( vec4 color, Image texture, vec2 texpoint, vec2 screenpoint){
			vec4 pixel = Texel(texture, texpoint);
			number x = screenpoint.x;
			number y = screenpoint.y;
			vec2 adjustedScreenPoint = vec2((x-offset)/gwidth,y/gheight);
			vec4 maskPixel = Texel(fragtext, adjustedScreenPoint);
			vec4 target = vec4(229.0/255.0,183.0/255.0,0.0,1.0);
			pixel *= color;
			if( maskPixel.r > 0.75 && maskPixel.b == 0.0){
				return pixel;
			}else{
				return vec4(0.0,0.0,0.0,0.0);
			}
		}
]]
sheenShader:send("gwidth",gamewidth);
sheenShader:send("gheight",gameheight);