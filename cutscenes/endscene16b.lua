--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp16b");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local leo = game.room.thingLookup["leo"];
scriptools.recenterCamera(2,{x=30,y=75});
leo.setAnimation("s_move");
scriptools.moveThingOverTime(leo,0,80,1.8);
scriptools.doOverTime(1.5,function(percent)
    local lightness = 255-math.floor(percent * 255);
    leo.color = {r=lightness,g=lightness,b=lightness,255};
end);
scriptools.wait(2.5,function()
    scriptools.recenterCamera(1,{x=0,y=20},function()
        game.player.setAnimation("e_move");
        scriptools.moveThingOverTime(game.player,56,0,1.1,function()
            game.player.setAnimation("s");
            scriptools.wait(1,function()
                game.player.setAnimation("sw");
                scriptools.wait(0.1,function()
                    game.player.setAnimation("w");
                    scriptools.wait(1.2,function()
                        game.player.setAnimation("sw");
                        scriptools.wait(0.1,function()
                            game.player.setAnimation("s");
                            scriptools.wait(0.1,function()
                                game.player.setAnimation("se");
                                scriptools.wait(0.1,function()
                                    game.player.setAnimation("e");
                                    scriptools.wait(1.2,function()
                                        game.player.setAnimation("s");
                                        game.room.eliminateThingByName("leo");
                                        game.convo = Convo("cutscene/ending17");
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
        end);
    end);
end);