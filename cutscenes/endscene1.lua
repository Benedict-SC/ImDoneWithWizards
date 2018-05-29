--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp1");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local statch = game.room.thingLookup["statue"];
scriptools.panToThing(statch,0.4,{x=10,y=20},function()
    sound.play("statuecrack");
    statch.setAnimation("shake");
    scriptools.wait(3.2,function()
        scriptools.recenterCamera(0.4,{x=0,y=20},function()
            --runlua("cutscenes/endscene5.lua");
            game.convo = Convo("cutscene/ending2");
            sound.play("evidenceOpen");
            game.player.state = "TEXTBOX";
            game.convo.start();
        end);
    end);
end);