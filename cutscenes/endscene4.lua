--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp4");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end);
 ]]
local gwiz = game.room.thingLookup["gwiz"];
gwiz.setAnimation("s");
sound.play("jump");
gwiz.jumpstart = gwiz.y;
scriptools.doOverTime(0.5,function(percent) 
    local xadj = (percent*6)-3;
    gwiz.y = gwiz.jumpstart - (9 - (xadj*xadj));
end,function() 
    gwiz.y = gwiz.jumpstart;
    --gwiz.setAnimation("sw");
    game.convo = Convo("cutscene/ending5");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
    scriptools.recenterCamera(0.6,{x=20,y=16});
end);