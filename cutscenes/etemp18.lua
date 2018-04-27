scriptools.wait(1,function()
    game.convo = Convo("cutscene/ending19");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);