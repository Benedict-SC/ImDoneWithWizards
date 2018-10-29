ControlsScreen = function()
	local cscreen = {};
    cscreen.bg = love.graphics.newImage("images/menus/photocontrols.png");
    cscreen.selectors = {
        love.graphics.newImage("images/menus/outline_up.png"),
        love.graphics.newImage("images/menus/outline_right.png"),
        love.graphics.newImage("images/menus/outline_down.png"),
        love.graphics.newImage("images/menus/outline_left.png"),
        love.graphics.newImage("images/menus/outline_confirm.png"),
        love.graphics.newImage("images/menus/outline_cancel.png"),
        love.graphics.newImage("images/menus/outline_leftTab.png"),
        love.graphics.newImage("images/menus/outline_rightTab.png"),
        love.graphics.newImage("images/menus/outline_menu.png"),
        love.graphics.newImage("images/menus/outline_reset.png")
    };
    cscreen.purposes = {
        "moving up.",
        "moving right.",
        "moving down.",
        "moving left.",
        "interacting with things and confirming most choices.",
        "cancelling and exiting things, plus disabling/enabling evidence.",
        "going left in the hypothesis, plus casting Lightningbolt Mind.",
        "going right in the hypothesis, plus casting Lightningbolt Mind.",
        "calling up the menu and confirming choices in some options screens."
    };
    cscreen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
    cscreen.mode = "NAVIGATE";
    cscreen.pos = 5;
    --the number at your position's index is the position you move to if you're at the corresponding button.
    cscreen.posIDs = {"up","right","down","left","action","cancel","leftTab","rightTab","menu"};
    cscreen.ups = {3,1,2,1,7,8,5,6,10,9,3,5,9};
    cscreen.downs = {4,3,1,3,7,8,5,6,10,9,1,7,10};
    cscreen.lefts = {4,4,4,4,2,5,1,7,6,8,12,13,13};
    cscreen.rights = {7,5,2,2,6,9,8,10,9,10,11,11,12};
    cscreen.acceptInput = function(text)
        local invalidCharsPattern = "[%$%<%>\\%^%@%_%`]";
        local same = keyControls[cscreen.posIDs[cscreen.pos]][1] == text;
        local already = false;
        for i=1,#(cscreen.posIDs),1 do
            local controls = keyControls[cscreen.posIDs[i]];
            for j=1,#controls,1 do
                if text == controls[j] then
                    already = true;
                end
            end
        end
        if text:find(invalidCharsPattern) or (already and not same) then 
            sound.play("invalid");
        else
            keyControls[cscreen.posIDs[cscreen.pos]] = {text};
            cscreen.mode = "WAITING";
            scriptools.wait(0.2,function()
                cscreen.mode = "NAVIGATE";
            end);
        end
    end
    cscreen.update = function()
        if cscreen.mode == "NAVIGATE" then
            local bbuttonPressed = false;
            if activeJoystick then 
                bbuttonPressed = activeJoystick:isGamepadDown("b");
            end
            if objectiveArrowsPressed.up then 
                cscreen.pos = cscreen.ups[cscreen.pos];
                sound.play("evidenceScroll");
            elseif objectiveArrowsPressed.down then 
                cscreen.pos = cscreen.downs[cscreen.pos];
                sound.play("evidenceScroll");
            elseif objectiveArrowsPressed.left then 
                cscreen.pos = cscreen.lefts[cscreen.pos];
                sound.play("evidenceScroll");
            elseif objectiveArrowsPressed.right then 
                cscreen.pos = cscreen.rights[cscreen.pos];
                sound.play("evidenceScroll");
            elseif objectiveArrowsPressed.space then
                if (cscreen.pos >= 1) and (cscreen.pos < 10) then
                    cscreen.mode = "ENTRY";
                elseif cscreen.pos == 10 then
                    for i=1,#(cscreen.posIDs),1 do
                        keyControls[cscreen.posIDs[i]] = defaultKeyControls[cscreen.posIDs[i]];
                    end
                end
            elseif objectiveArrowsPressed.x or bbuttonPressed then
                --save and quit
                saveOptions();
                
                local ccanv = love.graphics.newCanvas(gamewidth,gameheight);
                love.graphics.pushCanvas(ccanv);
                cscreen.draw();
                love.graphics.popCanvas();
                local ocanv = love.graphics.newCanvas(gamewidth,gameheight);
                love.graphics.pushCanvas(ocanv);
                game.titleOptions.draw();
                love.graphics.popCanvas();
                transitionMenuScreens(ccanv,ocanv,game.titleOptions,true);
            end
        end
	end
	cscreen.draw = function()
		love.graphics.pushCanvas(cscreen.canvas);
        pushColor();
			love.graphics.draw(cscreen.bg,0,0);
            love.graphics.draw(cscreen.selectors[cscreen.pos],0,0);
            love.graphics.setShader(textColorShader);
            love.graphics.setFont(loadedFonts["InlineTiny"]);
            love.graphics.setColor(255,255,255);
            love.graphics.printf(keyControls.up[1],58,56,30,"center");
            love.graphics.printf(keyControls.right[1],81,81,30,"center");
            love.graphics.printf(keyControls.down[1],59,106,30,"center");
            love.graphics.printf(keyControls.left[1],35,81,30,"center");
            love.graphics.setFont(loadedFonts["OpenDyslexic"]);
            love.graphics.setColor(0,0,0);
            local spacey = keyControls.action[1];
            if #spacey <= 1 then 
                spacey = spacey:upper();
            end
            love.graphics.printf(spacey,121,97,52,"center");
            love.graphics.setColor(255,255,255);
            local spacey = keyControls.cancel[1];
            if #spacey <= 1 then 
                spacey = spacey:upper();
            end
            love.graphics.printf(spacey:upper(),162,97,50,"center");
            love.graphics.printf(keyControls.leftTab[1]:upper(),124,54,40,"center");
            love.graphics.printf(keyControls.rightTab[1]:upper(),170,54,40,"center");
            --love.graphics.setFont(loadedFonts["OpenDyslexicBold"]);
            local entery = keyControls.menu[1];
            if entery == "return" then
                entery = "enter";
            end
            love.graphics.setColor(255,255,255);
            love.graphics.printf(entery,229,97,58,"center");
            love.graphics.setColor(255,255,255);
            love.graphics.printf(entery,229,96,58,"center");
            love.graphics.setColor(0,0,0);
            love.graphics.printf(entery,228,96,58,"center");
            if cscreen.mode == "ENTRY" then
                love.graphics.setShader();
                love.graphics.setColor(0,0,0,158);
                love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
                love.graphics.setShader(textColorShader);
                love.graphics.setColor(255,255,255);
                love.graphics.printf("Press the key for " .. cscreen.purposes[cscreen.pos],50,70,200,"center");
            end
            love.graphics.setShader();
            love.graphics.setColor(0,0,0,128);
            love.graphics.rectangle("fill",0,135,230,24);
            love.graphics.setShader(textColorShader);
            love.graphics.setColor(255,255,255);
            love.graphics.setFont(loadedFonts["InlineTiny"]);
            love.graphics.printf("Note: in-game button prompts will not reflect changes. Remember your settings.",2,136,240,"left");
            love.graphics.setShader();
            
        popColor();
		love.graphics.popCanvas();
		love.graphics.draw(cscreen.canvas,0,0);
    end
    return cscreen;
end