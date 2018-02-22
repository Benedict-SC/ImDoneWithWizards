scriptools.movePlayerOverTime(0,-10,0.5,function()
    game.convo = Convo("cutscene/LMtut3");
    sfx.play(sfx.evidenceOpen);
    game.player.state = "TEXTBOX";
    game.convo.start();
end);