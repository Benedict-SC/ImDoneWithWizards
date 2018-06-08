--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp18");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]

sound.play("doorKnock");
scriptools.recenterCamera(0.5,{x=0,y=50});
scriptools.wait(0.2,function()
    emotes.exclaim(game.player,{x=0,y=5});
    game.player.setAnimation("s");
    scriptools.wait(1.1,function()
        game.convo = Convo("cutscene/ending19");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
end);