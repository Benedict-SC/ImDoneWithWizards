--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp9");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
game.room.thingLookup["sud"].setAnimation("spark");
sound.play("sparky");
scriptools.wait(1.2,function()
    game.convo = Convo("cutscene/ending10");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);