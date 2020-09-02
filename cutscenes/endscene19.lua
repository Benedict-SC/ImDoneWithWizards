game.player.setAnimation("n");
scriptools.wait(0.4,function()
    local blood = game.room.thingLookup["blood"]
    blood.x = blood.oldx;
    scriptools.wait(0.4,function()
        game.player.setAnimation("s_move");
        scriptools.moveThingOverTime(game.player,18,200,4);
        scriptools.recenterCamera(4,{x=-5,y=-90});
        scriptools.wait(3.0,function()
            scriptools.doOverTime(0.5,function(percent)
                local lightness = 1-percent;
                game.player.color = {r=lightness,g=lightness,b=lightness,1};
            end,function()
                scriptools.wait(2.5,function()
                    scriptools.moveThingOverTime(game.room.camera,-50,0,0.8,function()
                        scriptools.wait(1,function()
                            game.convo = Convo("cutscene/ending20");
                            sound.play("evidenceOpen");
                            game.player.state = "TEXTBOX";
                            game.convo.start();
                        end);
                    end);
                end);
            end);
        end);
    end);
end);