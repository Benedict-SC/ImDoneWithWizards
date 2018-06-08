--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp17");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
game.player.setAnimation("n_move");
scriptools.moveThingOverTime(game.player,4,-29,0.6,function()
    scriptools.wait(0.4,function()
        sound.play("evidenceClose");
        local blood = game.room.thingLookup["blood"]
        blood.oldx = blood.x;
        blood.x = 1000;
        scriptools.wait(1.2,function()
            game.convo = Convo("cutscene/ending18");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);