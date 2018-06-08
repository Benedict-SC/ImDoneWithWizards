starports = {"neutral","satisfied","weirded","despair","exhausted","evil","laughing","pointing","convicted","embarrassed","obviously","pensive","shocked"};
leoports = {"octagon","gruff","crossed","nervous","questioning","unsure","taptap","threatening","facepalm","radio","radiocalm","smiley"};
opalports = {"interrupting","guarded","firefury","weasely","uncomfortable","dark","closed","confused","panicked"};
Log = function()
    local log = ImageThing(520,280,1,"images/log.png");
    collision.giveColliderBasedOnSprite(log);
    log.collider.height = log.collider.height - 40;
    log.collider.offsetGeneratedSpriteCollider(0,40);
    configureAction(log,{action="log"});
    log.lineCache = Array();
    log.addLine = function(text,character)
        log.lineCache.push({text=text,character=character});
        if #(log.lineCache) > 100 then --clear the cache to one with only 20 entries
            local oldCache = log.lineCache;
            log.lineCache = Array();
            for i=(#oldCache - 19),#oldCache,1 do
                log.lineCache.push(oldCache[i]);
            end
        end
    end
    log.convoFromCache = function()
        local lineslist = Array();
        if #(log.lineCache) < 20 then
            for i=1,#(log.lineCache),1 do
                local liney = {text=log.lineCache[i].text,character=log.lineCache[i].character};
                lineslist.push(liney);
            end
        else
            for i=(#(log.lineCache) - 19),#(log.lineCache),1 do
                local liney = {text=log.lineCache[i].text,character=log.lineCache[i].character};
                lineslist.push(liney);
            end
        end
        for i=1,#lineslist,1 do
            if (lineslist[i].character == "Star") or (lineslist[i].character == "Starr") then
                lineslist[i].portrait = "logstar";
            elseif lineslist[i].character == "Leo" then
                lineslist[i].portrait = "logleo";
            elseif lineslist[i].character == "Opal" then
                lineslist[i].portrait = "logopal";
            else
                lineslist[i].portrait = "logother";
            end
        end
        local logconv = CustomConvo({lines=lineslist});
        logconv.loggy = true;
        return logconv;
    end
    return log;
end