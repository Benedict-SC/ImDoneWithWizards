--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp15");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
local leo = game.room.thingLookup["leo"];
local opal = game.room.thingLookup["opal"];
opal.setAnimation("s_move");
opal.starty = opal.y;
scriptools.doOverTime(1.1,function(percent) 
    local curved = logistic(percent,10);
    debug_console_string = "opalpercent: " .. curved;
    opal.y = opal.starty + (40*curved);
end,function() 
    opal.y = opal.starty + 40;
    game.player.setAnimation("se");
    opal.setAnimation("se");
    scriptools.wait(0.6,function()
        opal.setAnimation("nw");
        scriptools.wait(0.9,function()
            opal.setAnimation("se");
            scriptools.wait(0.7,function()
                opal.setAnimation("s_move");
                opal.starty = opal.y;
                scriptools.recenterCamera(1,{x=30,y=75});
                scriptools.doOverTime(2.1,function(percent) 
                    local curved = logistic(percent,10);
                    debug_console_string = "opalpercent: " .. curved;
                    opal.y = opal.starty + (120*curved);
                end,function() 
                    opal.y = opal.starty + 120;
                end);
                scriptools.wait(0.8,function()
                    sound.play("pow");
                    leo.setAnimation("w");
                    scriptools.moveThingOverTime(leo,20,0,0.3,function()
                        leo.setAnimation("sw");
                    end);  
                    scriptools.wait(2.1,function()
                        leo.setAnimation("nw");
                        game.room.eliminateThingByName("opal");
                        game.convo = Convo("cutscene/ending16");
                        sound.play("evidenceOpen");
                        game.player.state = "TEXTBOX";
                        game.convo.start();
                    end);              
                end);
                scriptools.wait(1,function()
                    scriptools.doOverTime(0.5,function(percent)
                        local lightness = 1-percent;
                        opal.color = {r=lightness,g=lightness,b=lightness,1};
                    end);
                end);
            end);
        end);
    end);
end);