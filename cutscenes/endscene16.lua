--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp16");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);
 ]]
local leo = game.room.thingLookup["leo"];
leo.setAnimation("w_move");
scriptools.moveThingOverTime(leo,-20,0,0.5,function()
    leo.setAnimation("s_move");
    scriptools.moveThingOverTime(leo,0,10,0.25,function()
        leo.setAnimation("s");
        scriptools.wait(0.7,function()
            leo.setAnimation("nw");
            scriptools.wait(0.3,function()
                game.convo = Convo("cutscene/ending16b");
                sound.play("evidenceOpen");
                game.player.state = "TEXTBOX";
                game.convo.start();
            end);
        end);
    end);
end);