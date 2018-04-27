game.player.setAnimation("s");
scriptools.wait(0.5,function()
    --game.player.playOnceAndThen("s_laugh",function(){
    scriptools.recenterCamera(1,{x=0,y=40});
    scriptools.wait(1,function()
        game.convo = Convo("cutscene/LMtut1");
        sound.play("evidenceOpen");
        game.player.state = "TEXTBOX";
        game.convo.start();
    end);
    sound.play("gehehe");

end);