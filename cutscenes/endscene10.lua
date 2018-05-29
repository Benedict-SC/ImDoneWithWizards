--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/ending11");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
game.player.setAnimation("careenfront");
game.player.vx = -0.8;
game.player.vy = 2.7;
game.player.ax = -0.038;
game.player.ay = -0.10;
local orbitcenter = {x=210,y=170,z=20};
local endpoint = {x=45,y=187};
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
end);
scriptools.wait(0.9,function() sound.play("whumph"); end);
scriptools.wait(1.5,function() sound.play("whumph"); end);
scriptools.wait(2.4,function() sound.play("whumph"); end);
scriptools.wait(3.8,function() sound.play("whumph"); end);
scriptools.wait(4.7,function() sound.play("whumph"); end);
scriptools.wait(5.6,function() sound.play("whumph"); end);