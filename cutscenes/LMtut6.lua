scriptools.wait(0.4,function() 
    game.room.thingLookup["FireAt235"].toggleLights();
    scriptools.wait(0.8,function() 
        scriptools.recenterCamera(1,{x=0,y=20});
        game.convo = Convo("cutscene/LMtut6");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
end);