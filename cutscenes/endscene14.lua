--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp14");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local leo = game.room.thingLookup["leo"];
    leo.setAnimation("n_move");
    scriptools.moveThingOverTime(leo,0,-70,1.8,function()
        leo.setAnimation("n");
        game.convo = Convo("cutscene/ending15");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
    scriptools.doOverTime(1.5,function(percent)
        leo.color = {r=percent,g=percent,b=percent,1};
    end,function()
        leo.color = nil;
    end);