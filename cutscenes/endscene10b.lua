--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/ending11");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
game.player.setAnimation("careenfront");
game.player.vx = 0;
game.player.vy = 0;
game.player.ax = 0;
game.player.ay = 0;
local orbitcenter = {x=210,y=180,z=20};
local orbitrad = {x=160,y=85};
local endpoint = {x=50,y=187};
local lastpass = false;
local careendone = false;
game.player.getMoving = function(duration,cb)
    scriptools.doOverTime(duration,function(percent) 
        game.player.vx = game.player.vx + game.player.ax;
        game.player.vy = game.player.vy + game.player.ay;
        game.player.x = game.player.x + game.player.vx;
        game.player.y = game.player.y + game.player.vy;
        debug_console_string = "x:" .. game.player.x .. ", y:" .. game.player.y;
        if lastpass then
            if game.player.x < endpoint.x then
                game.player.x = endpoint.x;
                game.player.y = endpoint.y;
                if not careendone then
                    sound.play("pow");
                end
                careendone = true;
            end
        end
    end,cb);
end
local moveAlongEllipseSegment = function(time,mover,startPercent,endPercent,center,radii,slowstart,cb)
    scriptools.doOverTime(time,function(percent)
        local sPercent = percent;
        if slowstart then sPercent = percent*percent; end
        if sPercent > 1 then sPercent = 1; end
        local radmove = sPercent * (endPercent - startPercent) * (math.pi*2);
        local rads = (math.pi*0.5 + (startPercent * math.pi * 2)) + radmove;
        if rads % (math.pi*2) > math.pi then
            game.player.setAnimation("careenback")
        else
            game.player.setAnimation("careenfront");
        end
        local xy = {x=center.x + (radii.x*math.cos(rads)),y=center.y + (radii.y*math.sin(rads))};
        mover.x = xy.x;
        mover.y = xy.y;
    end,cb);
end
local aPP = {x=game.player.x - orbitcenter.x,y=game.player.y-orbitcenter.y}; --player point adjusted to match origin
local denominator = (orbitrad.x * orbitrad.x * aPP.y * aPP.y) + (orbitrad.y * orbitrad.y * aPP.x * aPP.x);
local colinearFactor = (orbitrad.x * orbitrad.y) / math.sqrt(denominator);
local colinearPoint = {x=(colinearFactor*aPP.x) + orbitcenter.x,y=(colinearFactor*aPP.y) + orbitcenter.y,z=4};
local initcenter = {x=(colinearPoint.x + game.player.x)/2,y=(colinearPoint.y + game.player.y)/2,z=3};
local radfactor = distance(initcenter,colinearPoint)/distance(orbitcenter,colinearPoint);
local initrad = {x=orbitrad.x*radfactor,y=orbitrad.y*radfactor};
moveAlongEllipseSegment(1,game.player,0.6,1.1,initcenter,initrad,true,function()
    moveAlongEllipseSegment(6,game.player,1.06,3.1,orbitcenter,orbitrad,false,function()
        lastpass = true;
        local wallvector = {x=endpoint.x-game.player.x,y=endpoint.y-game.player.y};
        local wvmag= math.sqrt((wallvector.x * wallvector.x)+(wallvector.y*wallvector.y));
        local factor = 5/wvmag;
        game.player.vx = wallvector.x * factor;
        game.player.vy = wallvector.y * factor;
        game.player.getMoving(2,function()
            game.player.playOnceAndThen("falling",function()
                game.player.setAnimation("fallen");
                sound.play("whumph");
                game.room.eliminateThingByName("sud");
                game.player.z = 1;
                scriptools.wait(0.6,function()
                    scriptools.recenterCamera(0.4,{x=200,y=40},function()
                        game.convo = Convo("cutscene/ending11");
                        sound.play("evidenceOpen");
                        game.player.state = "TEXTBOX";
                        game.convo.start();
                    end);
                end);
            end);
        end);
    end);
end);
--[[ 
game.player.getMoving(8,function()
    game.player.playOnceAndThen("falling",function()
        game.player.setAnimation("fallen");
        sound.play("whumph");
        game.room.eliminateThingByName("sud");
        game.player.z = 1;
        scriptools.wait(0.6,function()
            scriptools.recenterCamera(0.4,{x=200,y=40},function()
                game.convo = Convo("cutscene/ending11");
                sound.play("evidenceOpen");
                game.player.state = "TEXTBOX";
                game.convo.start();
            end);
        end);
    end);
end);
scriptools.wait(1,function()
    scriptools.doOverTime(6.0,function(percent)
        game.player.ax = (orbitcenter.x - game.player.x)/740;
        game.player.ay = (orbitcenter.y -game.player.y)/740;
        if game.player.vx <= 0 then
            game.player.setAnimation("careenfront");
        else
            game.player.setAnimation("careenback");
        end
    end,function()
        game.player.ax = 0;
        game.player.ay = 0;
        local speed = math.sqrt((game.player.vx * game.player.vx)+(game.player.vy*game.player.vy));
        local wallvector = {x=endpoint.x-game.player.x,y=endpoint.y-game.player.y};
        local wvmag= math.sqrt((wallvector.x * wallvector.x)+(wallvector.y*wallvector.y));
        local factor = speed/wvmag;
        game.player.vx = wallvector.x * factor;
        game.player.vy = wallvector.y * factor;
        lastpass = true;
    end);
end); ]]
scriptools.wait(1.4,function() sound.play("whumph"); end);
scriptools.wait(2.0,function() sound.play("whumph"); end);
scriptools.wait(2.8,function() sound.play("whumph"); end);
scriptools.wait(4.2,function() sound.play("whumph"); end);
scriptools.wait(4.8,function() sound.play("whumph"); end);
scriptools.wait(5.6,function() sound.play("whumph"); end);