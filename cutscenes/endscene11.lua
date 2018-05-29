--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp11");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]

local leo = game.room.thingLookup["leo"];
local gwiz = game.room.thingLookup["gwiz"];
leo.setAnimation("shake");
scriptools.recenterCamera(0.6,{x=150,y=40});
scriptools.wait(1.2,function() 
    game.extras = {};
    game.extras.octoprog = 0;
    sound.play("ACSUD");
    game.extras.draw = function() 
        pushColor();
        love.graphics.setLineWidth(4);
        love.graphics.setLineStyle("rough");
        local prog1 = game.extras.octoprog + 0.2;
        if prog1 > 1 then prog1 = 1; end
        local prog2 = game.extras.octoprog + 0.1;
        if prog2 > 1 then prog2 = 1; end
        love.graphics.setColor(0,225,255);
        local octpoints = octagonPoints(82,97,prog1*200);
        love.graphics.polygon("line",unpack(octpoints));
        love.graphics.setColor(255,255,255);
        octpoints = octagonPoints(82,97,prog2*200);
        love.graphics.polygon("line",unpack(octpoints));
        love.graphics.setColor(0,225,255);
        octpoints = octagonPoints(82,97,game.extras.octoprog*200);
        love.graphics.polygon("line",unpack(octpoints));
        popColor();
    end        
    scriptools.doOverTime(0.7,function(percent)
        game.extras.octoprog = percent;
    end,function() 
        game.extras = {};
        game.extras.draw = function() end
        leo.setAnimation("block");
        scriptools.wait(0.4,function()
            leo.setAnimation("n");
            scriptools.wait(0.05,function()
                leo.setAnimation("ne");
                scriptools.wait(0.05,function()
                    leo.setAnimation("e");
                    scriptools.wait(0.05,function()
                        leo.setAnimation("taser");
                        sound.play("click");
                        local tasercord = Thing(leo.x+30,leo.y-40,1.1);
                        tasercord.prog = 0;
                        tasercord.prong = love.graphics.newImage("images/tasething.png");
                        tasercord.targetdiff = {x=gwiz.x - tasercord.x,y=(gwiz.y-40) - tasercord.y};
                        tasercord.draw = function()
                            pushColor();
                            love.graphics.setLineWidth(1);
                            love.graphics.setLineStyle("rough");
                            love.graphics.setColor(0,0,0);
                            local loc = {x=(tasercord.prog * tasercord.targetdiff.x)+tasercord.x,y=(tasercord.prog * tasercord.targetdiff.y)+tasercord.y};
                            love.graphics.line(tasercord.x,tasercord.y,loc.x,loc.y);
                            popColor();
                            love.graphics.draw(tasercord.prong,loc.x,loc.y-2);
                        end
                        game.room.registerThing(tasercord,"tasercord");
                        scriptools.doOverTime(0.4,function(percent) 
                            tasercord.prog = percent;
                        end,function()
                            tasercord.prog = 1;
                            sound.play("electrocute");
                            gwiz.setAnimation("zap");
                        end);
                    end);
                end);
            end);
        end);
    end);
end);