behaviors = {};
leoBound = {lx = 160,rx = 270,uy = 147,by = 225};
behaviors.makeIntoLeo = function(thing)
    thing.leoSpeed = 14;
    thing.leoTimeFunc = nil;
    thing.leoUpdate = function()
        if game.player.state ~= "MOVING" then --cancel wandery stuff
            if thing.leoTimeFunc then
                thing.leoTimeFunc.cancel = true;
            end
        elseif not thing.leoTimeFunc then
            thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
        elseif thing.leoTimeFunc.cancel then
            thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
        end
    end;
    thing.dirs = {"n","e","s","w","ne","se","sw","nw"};
    thing.leoDir = "s";
    thing.leoChooseRandomly = function()
        local decision = 3;--math.random(3);
        if decision == 1 then --do nothing
            --debug_console_string = "sitting there.";
            thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
        elseif decision == 2 then --turn in a random direction
            thing.leoDir = thing.dirs[math.random(8)];
            thing.setAnimation(thing.leoDir);
            --debug_console_string = "turning " .. thing.leoDir;
            thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
        elseif decision == 3 then --pick a target and walk
            local vector = thing.leoPickTarget();
            thing.leoDir = thing.dirs[vector.dir];
            --debug_console_string = "moving " .. thing.leoDir;
            thing.setAnimation(thing.leoDir .. "_move");
            thing.leoTimeFunc = scriptools.moveAtSpeedOverDistance(thing,thing.leoSpeed,vector.x,vector.y,true,function()
                thing.setAnimation(thing.leoDir);
                thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
            end);
        end        
    end
    thing.leoPickTarget = function()
        local distance = 15 + math.random()*10;
        local ymult = 0;
        local xmult = 0;
        local dir = math.random(4);
        if dir == 1 then --n
            ymult = -1;
        elseif dir == 2 then --e
            xmult = 1;
        elseif dir == 3 then --s
            ymult = 1;
        elseif dir == 4 then --w
            xmult = -1;
        end 
        local vector = {dir=dir,x=distance*xmult,y=distance*ymult};
        if      thing.x + vector.x < leoBound.lx then --check bounds
            vector.x = leoBound.lx - thing.x;
        elseif  thing.x + vector.x > leoBound.rx then
            vector.x = leoBound.rx - thing.x;
        elseif  thing.y + vector.y < leoBound.uy then
            vector.y = leoBound.uy - thing.y;
        elseif  thing.y + vector.y > leoBound.by then
            vector.y = leoBound.by - thing.y;
        end
        return vector;
    end
    thing.leoChooseRandomly();
end