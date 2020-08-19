--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp7");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local sud = AnimatedThing(200,258,0.5,"circle");
game.room.things.push(sud);
game.room.thingLookup["sud"] = sud; 
sud.playOnceAndThen("draw",function() 
    sud.setAnimation("wiggly");
    scriptools.wait(0.6,function() 
        game.convo = Convo("cutscene/ending8");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end)
end);
local sud_o = AnimatedThing(200,258,1.2,"circle");
game.room.things.push(sud_o);
game.room.thingLookup["sud_o"] = sud_o; 
sud_o.playOnceAndThen("draw_overlay",function() 
    sud_o.setAnimation("wiggly_overlay");
end);
scriptools.wait(1.5,function()
    local tabley = AnimatedThing(338,229,1.2,"circletable");
    game.room.things.push(tabley);
    game.room.thingLookup["tabley"] = tabley;
    tabley.playOnceAndThen("draw",function()
        tabley.setAnimation("drawn");
    end)
end);