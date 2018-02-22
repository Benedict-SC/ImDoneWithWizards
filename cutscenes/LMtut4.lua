scriptools.movePlayerOverTime(24,24,0.5,function()
    scriptools.movePlayerOverTime(90,0,1.2,function()
        game.player.setAnimation("se");
        game.convo = Convo("cutscene/LMtut4");
        sfx.play(sfx.evidenceOpen);
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
end);