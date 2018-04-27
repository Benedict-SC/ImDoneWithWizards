scriptools.wait(1,function()
    game.convo = Convo("cutscene/ending11");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);