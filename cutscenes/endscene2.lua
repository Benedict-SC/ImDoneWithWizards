--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp2");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local statch = game.room.thingLookup["statue"];
scriptools.panToThing(statch,0.4,{x=10,y=20},function()
    local swiz = AnimatedThing(statch.x,statch.y-1,statch.z,"stopwiz");
    swiz.name = "stopwiz";
    swiz.filepath = "stopwiz";
    game.room.things.push(swiz);
    game.room.thingLookup[swiz.name] = swiz;
    sound.play("statuegone");
    statch.playOnceAndThen("splode",function() 
        scriptools.wait(0.7,function()
            swiz.setAnimation("se");
            game.convo = Convo("cutscene/ending3");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);