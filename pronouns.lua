pronouns = {};
customPronouns = {theyre = "???",they = "???", their="???",them="???",theirs="???",mx="???"};
pronouns.savedType = "nb"
pronouns.respectGenderIdentity = function(pstr)

    pstr = pstr:gsub("%%CTHEYRE%%",pronouns.ctheyre);
    pstr = pstr:gsub("%%CTHEY%%",pronouns.cthey);
    pstr = pstr:gsub("%%CTHEIR%%",pronouns.ctheir);
    pstr = pstr:gsub("%%CTHEIRS%%",pronouns.ctheirs);
    pstr = pstr:gsub("%%CTHEM%%",pronouns.cthem);
    --lowercase
    pstr = pstr:gsub("%%THEYRE%%",pronouns.theyre);
    pstr = pstr:gsub("%%THEY%%",pronouns.they);
    pstr = pstr:gsub("%%THEIR%%",pronouns.their);
    pstr = pstr:gsub("%%THEIRS%%",pronouns.theirs);
    pstr = pstr:gsub("%%THEM%%",pronouns.them);
    pstr = pstr:gsub("%%MX%%",pronouns.mx);
    return pstr;
end
pronouns.mSet = function(save)
    pronouns.ctheyre = "He's";
    pronouns.theyre = "he's";
    pronouns.cthey = "He";
    pronouns.they = "he";
    pronouns.ctheir = "His";
    pronouns.their = "his";
    pronouns.ctheirs = "His";
    pronouns.theirs = "his";
    pronouns.cthem = "Him";
    pronouns.them = "him";
    pronouns.mx = "Mr.";
    if save then
        pronouns.savedType = "m";
    end
end
pronouns.fSet = function(save)
    pronouns.ctheyre = "She's";
    pronouns.theyre = "she's";
    pronouns.cthey = "She";
    pronouns.they = "she";
    pronouns.ctheir = "Her";
    pronouns.their = "her";
    pronouns.ctheirs = "Hers";
    pronouns.theirs = "hers";
    pronouns.cthem = "Her";
    pronouns.them = "her";
    pronouns.mx = "Ms.";
    if save then
        pronouns.savedType = "f";
    end
end
pronouns.nbSet = function(save)
    pronouns.ctheyre = "They're";
    pronouns.theyre = "they're";
    pronouns.cthey = "They";
    pronouns.they = "they";
    pronouns.ctheir = "Their";
    pronouns.their = "their";
    pronouns.ctheirs = "Theirs";
    pronouns.theirs = "theirs";
    pronouns.cthem = "Them";
    pronouns.them = "them";
    pronouns.mx = "Mx.";
    if save then
        pronouns.savedType = "nb";
    end
end
pronouns.newCustomSet = function(theyre,they,their,theirs,them,mx)
    local ctheyreA = theyre:sub(1,1):upper();
    local ctheyreB = theyre:sub(2);
    pronouns.ctheyre = ctheyreA .. ctheyreB;
    pronouns.theyre = theyre;
    local ctheyA = they:sub(1,1):upper();
    local ctheyB = they:sub(2);
    pronouns.cthey = ctheyA .. ctheyB;
    pronouns.they = they;
    local ctheirA = their:sub(1,1):upper();
    local ctheirB = their:sub(2);
    pronouns.ctheir = ctheirA .. ctheirB;
    pronouns.their = their;
    local ctheirsA = theirs:sub(1,1):upper();
    local ctheirsB = theirs:sub(2);
    pronouns.ctheirs = ctheirsA .. ctheirsB;
    pronouns.theirs = theirs;
    local cthemA = them:sub(1,1):upper();
    local cthemB = them:sub(2);
    pronouns.cthem = cthemA .. cthemB;
    pronouns.them = them;
    pronouns.mx = mx;
    pronouns.savedType = "custom";
    --save custom pronouns
    customPronouns = shallowcopy(pronouns);
end
pronouns.customSet = function(save)
    pronouns.theyre = customPronouns.theyre;
    pronouns.they = customPronouns.they;
    pronouns.their = customPronouns.their;
    pronouns.theirs = customPronouns.theirs;
    pronouns.them = customPronouns.them;
    pronouns.mx = customPronouns.mx;
    local ctheyreA = customPronouns.theyre:sub(1,1):upper();
    local ctheyreB = customPronouns.theyre:sub(2);
    pronouns.ctheyre = ctheyreA .. ctheyreB;
    local ctheyA = customPronouns.they:sub(1,1):upper();
    local ctheyB = customPronouns.they:sub(2);
    pronouns.cthey = ctheyA .. ctheyB;
    local ctheirA = customPronouns.their:sub(1,1):upper();
    local ctheirB = customPronouns.their:sub(2);
    pronouns.ctheir = ctheirA .. ctheirB;
    local ctheirsA = customPronouns.theirs:sub(1,1):upper();
    local ctheirsB = customPronouns.theirs:sub(2);
    pronouns.ctheirs = ctheirsA .. ctheirsB;
    local cthemA = customPronouns.them:sub(1,1):upper();
    local cthemB = customPronouns.them:sub(2);
    pronouns.cthem = cthemA .. cthemB;
    if save then
        pronouns.savedType = "custom";
    end
end
--pronouns.nbSet(true);
--pronouns.newCustomSet("ze's","ze","zer","zers","zem","Mx.");
--pronouns.savedType = "custom";
pronouns.set = function(id,save)
    if (id == 1) or (id == "m") then pronouns.mSet(save); end
    if (id == 2) or (id == "f") then pronouns.fSet(save); end
    if (id == 3) or (id == "nb") then pronouns.nbSet(save); end
    if (id == 4) or (id == "custom") then pronouns.customSet(save); end
end

pronouns.save = function()
    bigObj = {ptype=pronouns.savedType,cust=customPronouns};
    local pdata = json.encode(bigObj);
	pdata = pdata:gsub("\\/","/");
	local hooray, message = love.filesystem.write("pronouns.json",pdata);
		if hooray then
			debug_console_string = "pronoun save success!";
		elseif message then
			error("extreme failure!\n" .. message);		
		end
end
pronouns.load = function()
    local savefile = love.filesystem.read("pronouns.json");
    if savefile then
        local savedata = json.decode(savefile);
        customPronouns = savedata.cust;
        pronouns.savedType = savedata.ptype;
        pronouns.set(pronouns.savedType,false);
    else
        pronouns.nbSet(true);
    end
end
pronouns.load();

PronounsScreen = function()
    local screen = {};
	screen.canvas = love.graphics.newCanvas(gamewidth,gameheight);
	screen.bg = love.graphics.newImage("images/menus/genderscreen.png");
	screen.boxes = love.graphics.newImage("images/menus/genderBoxes.png");
    screen.selector = {x=0,y=18,img=love.graphics.newImage("images/menus/genderSelector.png")};
    screen.textrect = {x=0,y=0,img=love.graphics.newImage("images/menus/pronounSelector.png")};
    screen.selectorPositions = {69,108,148,190};
    screen.selTextXs = {16,108,200,16,108,200};
    screen.selTextYs = {70,70,70,130,130,130};
    screen.color = {255,255,255};
    screen.font = "OpenDyslexicBold";
    screen.mode = "SELECT"; --SELECT, TEXT
    screen.updateTexts = function()
        screen.texts = {
            they={x=22,y=83,word=pronouns.they},
            them={x=116,y=83,word=pronouns.them},
            theyre={x=208,y=83,word=pronouns.theyre},
            their={x=22,y=143,word=pronouns.their},
            theirs={x=116,y=143,word=pronouns.theirs},
            mx={x=208,y=143,word=pronouns.mx}
        };
    end
    screen.updateTexts();
    screen.lookup = {"m","f","nb","custom",m=1,f=2,nb=3,custom=4};
    screen.nouns = {"they","them","theyre","their","theirs","mx",they=1,them=2,theyre=3,their=4,theirs=5,mx=6};
    screen.draw = function()
        love.graphics.pushCanvas(screen.canvas);
			love.graphics.draw(screen.bg,0,0);
            love.graphics.draw(screen.boxes,0,0);
            love.graphics.draw(screen.selector.img,screen.selector.x,screen.selector.y);
            if screen.mode == "TEXT" then
                love.graphics.draw(screen.textrect.img,screen.textrect.x,screen.textrect.y);
            end
            pushColor();
			love.graphics.setShader(textColorShader);
			    love.graphics.setFont(loadedFonts[screen.font]);
                love.graphics.setColor(screen.color);
                for i=1,#(screen.nouns) do
                    local noun = screen.nouns[i];
                    love.graphics.print(screen.texts[noun].word,screen.texts[noun].x,screen.texts[noun].y);
                end
            popColor();
			love.graphics.setShader();
		love.graphics.popCanvas();
		love.graphics.draw(screen.canvas,0,0);
    end
    screen.init = function()
        for i=1,#(screen.nouns) do
            local noun = screen.nouns[i];
            screen.texts[noun].word = pronouns[noun];
        end
        screen.selected = screen.lookup[pronouns.savedType];
        screen.selText = 3;
        pronouns.set(screen.selected,false);
    end
    screen.update = function()
        screen.selector.x = screen.selectorPositions[screen.selected];
        if screen.mode == "SELECT" then
            if pressedThisFrame.right then
                screen.selected = screen.selected + 1;
                if screen.selected > 4 then 
                    screen.selected = 1; 
                end 
                sfx.play(sfx.evidenceScroll);
                pronouns.set(screen.selected,false);
                screen.updateTexts();
            elseif pressedThisFrame.left then
                screen.selected = screen.selected - 1;
                if screen.selected < 1 then 
                    screen.selected = 4; 
                end 
                sfx.play(sfx.evidenceScroll);
                pronouns.set(screen.selected,false);
                screen.updateTexts();
            elseif pressedThisFrame.menu or pressedThisFrame.action then
                if screen.selected == 4 then
                    screen.mode = "TEXT";
                    screen.textrect.x = screen.selTextXs[screen.selText];
                    screen.textrect.y = screen.selTextYs[screen.selText];
                else
                    pronouns.set(screen.selected,true);
                    pronouns.save();
                    sfx.play(sfx.save);
                end
            elseif pressedThisFrame.cancel then 
                screen.exit();
            end
            if screen.selected ~= screen.lookup[pronouns.savedType] then --color the text to indicate it's temporary
                if screen.selected == 1 then
                    screen.color = {50,150,255};
                elseif screen.selected == 2 then
                    screen.color = {255,50,200};
                elseif screen.selected == 3 then
                    screen.color = {180,50,200};
                elseif screen.selected == 4 then
                    screen.color = {50,255,50};
                end
                screen.font = "OpenDyslexic";
            else
                screen.color = {255,255,255};
                screen.font = "OpenDyslexicBold";
            end
        elseif screen.mode == "TEXT" then
            screen.textrect.x = screen.selTextXs[screen.selText];
            screen.textrect.y = screen.selTextYs[screen.selText];
            if love.keyboard.isDown("return") then
                screen.mode = "SELECT";
                pronouns.newCustomSet(screen.texts["theyre"].word,screen.texts["they"].word,screen.texts["their"].word,screen.texts["theirs"].word,screen.texts["them"].word,screen.texts["mx"].word);
                pronouns.savedType = "custom";
                pronouns.save();
                sfx.play(sfx.save);
            elseif objectiveArrowsPressed.left then
                screen.selText = screen.selText - 1;
                if screen.selText == 0 then
                    screen.selText = 3;
                elseif screen.selText == 3 then
                    screen.selText = 6;
                end
            elseif objectiveArrowsPressed.right then
                screen.selText = screen.selText + 1;
                if screen.selText == 4 then
                    screen.selText = 1;
                elseif screen.selText == 7 then
                    screen.selText = 4;
                end
            elseif objectiveArrowsPressed.up then
                screen.selText = screen.selText - 3;
                if screen.selText < 1 then screen.selText = screen.selText + 6; end
            elseif objectiveArrowsPressed.down then
                screen.selText = screen.selText + 3;
                if screen.selText > 6 then screen.selText = screen.selText - 6; end
            end
        end
    end
    screen.acceptInput = function(text)
        local noun = screen.nouns[screen.selText];
        local appendTo = screen.texts[noun].word;
        if text == "backspace" then
            screen.texts[noun].word = appendTo:sub(1,-2);
        elseif #appendTo < 12 then
            if not (text:match("[^%a%-'%.%s]")) then
                screen.texts[noun].word = appendTo .. text;
            end
        end
    end
    screen.exit = function()
        pronouns.set(pronouns.savedType,true);
        game.menuMode = true;
        game.pronounsMode = false;
    end

    return screen;
end