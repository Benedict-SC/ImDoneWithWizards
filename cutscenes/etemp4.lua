scriptools.wait(1,function()
    game.convo = Convo("cutscene/ending5");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);