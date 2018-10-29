scriptools.recenterCamera(0.6,{x=0,y=60},function()
    game.player.setAnimation("se");
    game.convo = Convo("cutscene/LMtut4");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);
--[[         
        game.convo = Convo("cutscene/LMtut4");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start(); ]]