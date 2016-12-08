Fragment = function(filename)
	local frag = {};
	local jstring = love.filesystem.read("json/hypotheses/".. filename .. ".json");
	frag.json = json.decode(jstring);
	frag.filename = filename;
	frag.seen = false;
	
	frag.loadIn = function()
		local infix = frag.json.folder and (frag.json.folder .. "/") or "";
		frag.text = ImageThing(0,0,0,"images/hypotheses/".. infix .. frag.json.bg ..".png");
		frag.questions = Array();
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
	end
	frag.unload = function()
		frag.text = BlankThing();
		frag.questions = nil;
	end
	frag.see = function()
		if not (frag.seen) then
			sfx.play(sfx.hypothesisUpdated);
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
	hyp.cloud = ImageThing(0,0,0,"images/bigballoon.png");
	hyp.transitions = love.graphics.newImage("images/transitionbubbles.png");
	hyp.questions = Array();
	hyp.activeQuestion = 1;
	
	hyp.guy = ImageThing(gamewidth/2,gameheight,1.05,"images/guyhead.png");
	hyp.guylow = hyp.guy.img:getHeight() + gameheight;
	hyp.guy.y = hyp.guylow;

	hyp.replaceFragment = function(id, fragFile)
		local frag = Fragment(fragFile);
		hyp.fragmentList[(hyp.indexOfFragment(id))] = frag;
	end
	hyp.indexOfFragment = function(fileId)
		for i=1,#(hyp.fragmentList),1 do
			local frag = hyp.fragmentList[i];
			if frag.filename == fileId then return i; end
		end
		return 0;
	end
	
	hyp.draw = function()
		if not (hyp.state == "LEFT" or hyp.state == "RIGHT") then
			if hyp.fragmentPos.y > 0 then
				if not (hyp.activeFragment == 1) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x-580,hyp.fragmentPos.y-450);
				end
				if not (hyp.activeFragment == #(hyp.fragmentList)) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+320,hyp.fragmentPos.y-450);
				end
				local frag = hyp.fragmentList[hyp.activeFragment];
				hyp.cloud.offsetDraw(hyp.fragmentPos.x,hyp.fragmentPos.y);
				frag.text.offsetDraw(hyp.fragmentPos.x,hyp.fragmentPos.y);
				for i=1,#(frag.questions),1 do
					frag.questions[i].offsetDraw(hyp.fragmentPos.x,hyp.fragmentPos.y)
				end
			end
		else
			if not (hyp.oldFragment == 1) then
				love.graphics.draw(hyp.transitions,hyp.fragmentPos.x-580 + hyp.sideOffset,hyp.fragmentPos.y-450);
			end
			if not (hyp.oldFragment == #(hyp.fragmentList)) then
				love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+320 + hyp.sideOffset,hyp.fragmentPos.y-450);
			end
			if hyp.state == "LEFT" then
				if not (hyp.activeFragment == 1) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x-580+ hyp.sideOffset-gamewidth,hyp.fragmentPos.y-450);
				end
			else
				if not (hyp.activeFragment == #(hyp.fragmentList)) then
					love.graphics.draw(hyp.transitions,hyp.fragmentPos.x+320+ hyp.sideOffset+gamewidth,hyp.fragmentPos.y-450);
				end
			end
			local frag = hyp.fragmentList[hyp.oldFragment];
			hyp.cloud.offsetDraw(hyp.fragmentPos.x + hyp.sideOffset,hyp.fragmentPos.y);
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
		if hyp.guy.y < hyp.guylow then
			hyp.guy.draw();
		end
		if hyp.state == "EVIDENCE" then
			game.inventory.dropdownDraw();
		end
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
				hyp.fragmentList[hyp.activeFragment].see();
			end
		elseif hyp.state == "LEFT" then
			
		elseif hyp.state == "RIGHT" then

		elseif hyp.state == "SELECT" then
			if pressedThisFrame.down or pressedThisFrame.right or pressedThisFrame.up or pressedThisFrame.left then
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
				sfx.play(sfx.questionBeep);
				lifetime.shake(frag.questions[hyp.activeQuestion]);
			elseif pressedThisFrame.cancel then
				hyp.hide(function() game.player.state = "MOVING" end);
			elseif pressedThisFrame.action then
				hyp.state = "EVIDENCE";
				local q = frag.questions[hyp.activeQuestion];
				local x = hyp.fragmentPos.x + q.x + q.img:getWidth()/2;
				local y = hyp.fragmentPos.y + q.y;
				game.inventory.activateDropdown(x,y);
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
					local evidenceResult = question.evidences[ev.name];
					if evidenceResult then
						local convoId = evidenceResult.convo;
						game.convo = Convo(convoId);
						sfx.play(sfx.evidenceOpen);
						game.player.state = "TEXTBOX";
						hyp.hide(nilf);
						game.convo.start();
					else
						sfx.play(sfx.invalid);
					end
				else
					sfx.play(sfx.invalid);
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
		hyp.sideOffsetMax = gamewidth;
		hyp.sideOffset = 0;
		local slideDuration = 15;
		local slide = Lifetime(hyp,slideDuration);
		if left then 
			slide.update = function()
				slide.thing.sideOffset = slide.thing.sideOffset + (gamewidth/slideDuration);
			end
		else
			slide.update = function()
				slide.thing.sideOffset = slide.thing.sideOffset - (gamewidth/slideDuration);
			end
		end
		slide.death = function()
			hyp.state = "SELECT";
			slide.thing.sideOffset = 0;
			hyp.fragmentPos.x = gamewidth/2;
			hyp.fragmentList[hyp.oldFragment].unload();
			hyp.oldFragment = nil;
			hyp.fragmentList[hyp.activeFragment].see();
		end
		sfx.play(sfx.fragmentWhoosh);
		mortalCoil.push(slide);
	
		
	end
	hyp.show = function()
		sfx.play(sfx.evidenceOpen);
		hyp.fragmentList[hyp.activeFragment].loadIn();
		hyp.bubblespeed = math.floor(hyp.cloud.img:getHeight() / hyp.showframes);
		hyp.guyspeed = -math.floor(hyp.guy.img:getHeight() / hyp.showframes);
		hyp.state = "APPEARING";
	end
	hyp.hide = function(cb)
		sfx.play(sfx.evidenceClose);
		hyp.bubblespeed = -math.floor(hyp.cloud.img:getHeight() / hyp.showframes);
		hyp.guyspeed = math.floor(hyp.guy.img:getHeight() / hyp.showframes);
		hyp.state = "HIDING";
		hyp.hideCallback = cb;
	end
	return hyp;
end