behaviors = {};
leoBound = {lx = 160,rx = 270,uy = 157,by = 225};
behaviors.makeIntoLeo = function(thing)
    thing.leoSpeed = 14;
    thing.leoTimeFunc = nil;
    thing.leoUpdate = function()
        if (game.player.state ~= "MOVING") or (game.room == game.darkroom) then --cancel wandery stuff
            if thing.leoTimeFunc then
                thing.leoTimeFunc.cancel = true;
                if thing.leoWandering then 
                    thing.leoWandering = false;
                    thing.stopMoving(); --TODO: set leoWandering directly if a script starts by setting his animation.
                end
            end
        elseif not thing.leoTimeFunc then
            thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
        elseif thing.leoTimeFunc.cancel then
            thing.leoTimeFunc = scriptools.wait(3.2 + math.random()*1.6,thing.leoChooseRandomly);
        end
    end;
    thing.stopMoving = function()
        if thing.currentAnim:find("_move") then
            thing.setAnimation((thing.currentAnim):sub(1,-6));
        end
    end
    thing.dirs = {"n","e","s","w","ne","se","sw","nw"};
    thing.leoDir = "s";
    thing.leoChooseRandomly = function()
        thing.leoWandering = true;
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
behaviors.makeIntoSlick = function(thing)
    thing.flicker = function()
        scriptools.wait((math.random() * 2)+6,function() 
            thing.playOnceAndThen("g" .. math.random(3),function()
                thing.flicker();
                thing.setAnimation("still");
            end);
        end);
    end
    thing.flicker();
end
behaviors.makeIntoBullet = function(thing)
    thing.flicker = function()
        scriptools.wait((math.random() * 2)+6,function() 
            thing.playOnceAndThen("g",function()
                thing.flicker();
                thing.setAnimation("still");
            end);
        end);
    end
    thing.flicker();
end
behaviors.darkfloor = love.graphics.newImage("images/darkfloor.png");
behaviors.darkshelf = love.graphics.newImage("images/bookshelf_shorter_dark.png");
behaviors.liteshelf = love.graphics.newImage("images/bookshelf_shorter.png");
behaviors.darktable = love.graphics.newImage("images/table3dark.png");
behaviors.darktableD = love.graphics.newImage("images/table3_drapeddark.png");
behaviors.roomflicker = function(theroom)
    theroom.flicker = function()
        local floor = theroom.thingLookup["fakefloor"];
        local btable = theroom.thingLookup["table"];
        local shelf = theroom.thingLookup["bookshelf"];
        floor.liteImg = floor.img;
        scriptools.wait((math.random() * 4)+18,function()
            floor.img = behaviors.darkfloor;
            btable.img = btable.darkImg;
            shelf.img = behaviors.darkshelf;
            scriptools.wait(0.06,function()
                floor.img = floor.liteImg;
                btable.img = btable.liteImg;
                shelf.img = behaviors.liteshelf;
                scriptools.wait(0.06,function()
                    floor.img = behaviors.darkfloor;
                    btable.img = btable.darkImg;
                    shelf.img = behaviors.darkshelf;
                    scriptools.wait(0.06,function()
                        floor.img = floor.liteImg;
                        btable.img = btable.liteImg;
                        shelf.img = behaviors.liteshelf;
                        scriptools.wait(0.06,function()
                            floor.img = behaviors.darkfloor;
                            btable.img = btable.darkImg;
                            shelf.img = behaviors.darkshelf;
                            scriptools.wait(0.8,function()
                                floor.img = floor.liteImg;
                                btable.img = btable.liteImg;
                                shelf.img = behaviors.liteshelf;
                                scriptools.wait(0.06,function()
                                    floor.img = floor.liteImg;
                                    btable.img = btable.liteImg;
                                    shelf.img = behaviors.liteshelf;
                                    scriptools.wait(0.06,function()
                                        floor.img = behaviors.darkfloor;
                                        btable.img = btable.darkImg;
                                        shelf.img = behaviors.darkshelf;
                                        scriptools.wait(0.06,function()
                                            floor.img = floor.liteImg;
                                            btable.img = btable.liteImg;
                                            shelf.img = behaviors.liteshelf;
                                            theroom.flicker();
                                        end);
                                    end);
                                end);
                            end);
                        end);
                    end);
                end);
            end);
        end);
    end
    theroom.flicker();
end