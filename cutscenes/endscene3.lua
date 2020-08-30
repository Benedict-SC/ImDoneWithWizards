--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp3");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local gobody = game.room.thingLookup["gocorpse"];
local gwiz = AnimatedThing(gobody.x,gobody.y,gobody.z,"gowiz");
game.room.things.push(gwiz);
game.room.thingLookup["gwiz"] = gwiz;
game.room.eliminateThingByName("gocorpse");
game.room.eliminateThingByName("goarm");
game.room.eliminateThingByName("gotop");
scriptools.panToThing(gwiz,0.6,{x=-10,y=20},function() 
    gwiz.setAnimation("twitch");
    scriptools.wait(1.2,function() 
        game.extras = {};
        game.extras.octoprog = 0;
        sound.play("ACSUD");
        game.extras.draw = function() 
            pushColor();
            love.graphics.setLineWidth(4);
            love.graphics.setLineStyle("rough");
            local prog1 = game.extras.octoprog + 0.2;
            if prog1 > 1 then prog1 = 1; end
            local prog2 = game.extras.octoprog + 0.1;
            if prog2 > 1 then prog2 = 1; end
            love.graphics.setColor(0,0.8823,1);
            local octpoints = octagonPoints(165,87,prog1*200);
            love.graphics.polygon("line",unpack(octpoints));
            love.graphics.setColor(1,1,1);
            octpoints = octagonPoints(165,87,prog2*200);
            love.graphics.polygon("line",unpack(octpoints));
            love.graphics.setColor(0,0.8823,1);
            octpoints = octagonPoints(165,87,game.extras.octoprog*200);
            love.graphics.polygon("line",unpack(octpoints));
            popColor();
        end        
        scriptools.doOverTime(0.7,function(percent)
            game.extras.octoprog = percent;
        end,function() 
            game.extras = {};
            game.extras.draw = function() end
            game.convo = Convo("cutscene/ending4");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);