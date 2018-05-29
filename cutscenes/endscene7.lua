--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp7");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local sud = AnimatedThing(192,260,1.2,"circle");
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
end)