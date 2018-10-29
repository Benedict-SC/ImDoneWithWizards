scriptools.movePlayerOverTime(24,24,0.5,function()
    scriptools.movePlayerOverTime(90,0,1.2,function()
        game.player.setAnimation("ne");
        scriptools.recenterCamera(0.6,{x=20,y=10},function()
            game.convo = Convo("cutscene/LMtut3point5");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);