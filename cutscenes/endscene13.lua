--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp13");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local leo = game.room.thingLookup["leo"];
scriptools.recenterCamera(2,{x=30,y=75});
scriptools.wait(0.5,function()
    game.player.setAnimation("se");
end);
leo.setAnimation("s_move");
scriptools.moveThingOverTime(leo,0,22,0.7,function()
    leo.setAnimation("e_move");
    scriptools.moveThingOverTime(leo,94,0,2,function()
        game.player.setAnimation("e_move");
        scriptools.moveThingOverTime(game.player,80,6,2,function() game.player.setAnimation("e"); end);
        leo.setAnimation("s_move");
        scriptools.moveThingOverTime(leo,0,120,2.5,function()
            leo.setAnimation("s");
            game.convo = Convo("cutscene/ending14");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
        game.room.thingLookup["opal"].setAnimation("w");
        scriptools.recenterCamera(0.5,{x=30,y=55});
        scriptools.wait(1,function()
            scriptools.doOverTime(1.5,function(percent)
                local lightness = 1 - percent;
                leo.color = {r=lightness,g=lightness,b=lightness,1};
            end);
        end);
    end);
end);
