scriptools.wait(0.4,function() 
    game.room.thingLookup["FireAt235"].toggleLights();
    scriptools.wait(0.8,function() 
        game.convo = Convo("cutscene/LMtut5");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
end);