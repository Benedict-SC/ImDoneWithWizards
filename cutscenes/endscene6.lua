--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp6");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]

    game.extras = {};
    game.extras.leo = love.graphics.newImage("images/leocutin.png");
    game.extras.star = love.graphics.newImage("images/starsil.png");
    game.extras.leox = -413;
    game.extras.stary = 180;
    game.extras.overlayA = 0;
    game.extras.backpoints = {170,180,150,180,150,180,170,180};
    game.extras.backpointsSource = {170,180,150,180,150,180,170,180};
    game.extras.backpointsTarget = {170,180,150,180,230,0,260,0};
    game.extras.frontpoints = {50,180,30,180,30,180,50,180};
    game.extras.frontpointsSource = {50,180,30,180,30,180,50,180};
    game.extras.frontpointsTarget = {50,180,30,180,50,0,80,0};
    game.extras.bgpoints = {150,180,50,180,50,180,150,180};
    game.extras.bgpointsSource = {150,180,50,180,50,180,150,180};
    game.extras.bgpointsTarget = {150,180,50,180,80,0,230,0};
    game.extras.endTarget = {100,180,99,180,154,0,155,0};
    game.extras.whiteA = 0;
    game.extras.octoprog = 0;
    game.extras.octofade = 1;
    game.extras.draw = function()
        pushColor();
        love.graphics.setColor(0,0,0,game.extras.overlayA);
        love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
        love.graphics.setColor(0.8588,0.2627,0.1059);
        love.graphics.polygon("fill",unpack(game.extras.bgpoints));
        love.graphics.setColor(1,1,1);
        love.graphics.draw(game.extras.star,0,game.extras.stary);
        love.graphics.setColor(0.3922,0.3922,0.3922);
        love.graphics.polygon("fill",unpack(game.extras.backpoints));
        love.graphics.setColor(1,1,1);
        love.graphics.draw(game.extras.leo,game.extras.leox,0);
        love.graphics.setScissor( 0, 0, 50, 180 );
        game.room.render();
        love.graphics.setColor(0,0,0,game.extras.overlayA);
        love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
        love.graphics.setScissor();
        love.graphics.setColor(0.3922,0.3922,0.3922);
        love.graphics.polygon("fill",unpack(game.extras.frontpoints));
        love.graphics.setColor(1,1,1,game.extras.whiteA);
        love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
        love.graphics.setLineWidth(4);
        love.graphics.setLineStyle("rough");
        local prog1 = game.extras.octoprog + 0.2;
        if prog1 > 1 then prog1 = 1; end
        local prog2 = game.extras.octoprog + 0.1;
        if prog2 > 1 then prog2 = 1; end
        love.graphics.setColor(0,1,1,game.extras.octofade);
        local octpoints = octagonPoints(140,60,200- prog1*160);
        love.graphics.polygon("line",unpack(octpoints));
        love.graphics.setColor(1,1,1,game.extras.octofade);
        octpoints = octagonPoints(140,60,200- prog2*160);
        love.graphics.polygon("line",unpack(octpoints));
        love.graphics.setColor(0,1,1,game.extras.octofade);
        octpoints = octagonPoints(140,60,200-(game.extras.octoprog*160));
        love.graphics.polygon("line",unpack(octpoints));
        popColor();
    end
    scriptools.doOverTime(0.2,function(percent)
        game.extras.overlayA = 0.5*percent;
        game.extras.stary = 180- (94*percent);
        game.extras.backpoints = {  game.extras.backpointsSource[1],game.extras.backpointsSource[2],
                                    game.extras.backpointsSource[3],game.extras.backpointsSource[4],
                                    ((game.extras.backpointsSource[5] * (1-percent)) + (game.extras.backpointsTarget[5] * percent)),
                                    ((game.extras.backpointsSource[6] * (1-percent)) + (game.extras.backpointsTarget[6] * percent)),
                                    ((game.extras.backpointsSource[7] * (1-percent)) + (game.extras.backpointsTarget[7] * percent)),
                                    ((game.extras.backpointsSource[8] * (1-percent)) + (game.extras.backpointsTarget[8] * percent))
                                };
        game.extras.frontpoints = {  game.extras.frontpointsSource[1],game.extras.frontpointsSource[2],
                                    game.extras.frontpointsSource[3],game.extras.frontpointsSource[4],
                                    ((game.extras.frontpointsSource[5] * (1-percent)) + (game.extras.frontpointsTarget[5] * percent)),
                                    ((game.extras.frontpointsSource[6] * (1-percent)) + (game.extras.frontpointsTarget[6] * percent)),
                                    ((game.extras.frontpointsSource[7] * (1-percent)) + (game.extras.frontpointsTarget[7] * percent)),
                                    ((game.extras.frontpointsSource[8] * (1-percent)) + (game.extras.frontpointsTarget[8] * percent))
                                };
        game.extras.bgpoints = {  game.extras.bgpointsSource[1],game.extras.bgpointsSource[2],
                                game.extras.bgpointsSource[3],game.extras.bgpointsSource[4],
                                ((game.extras.bgpointsSource[5] * (1-percent)) + (game.extras.bgpointsTarget[5] * percent)),
                                ((game.extras.bgpointsSource[6] * (1-percent)) + (game.extras.bgpointsTarget[6] * percent)),
                                ((game.extras.bgpointsSource[7] * (1-percent)) + (game.extras.bgpointsTarget[7] * percent)),
                                ((game.extras.bgpointsSource[8] * (1-percent)) + (game.extras.bgpointsTarget[8] * percent))
                            };
    end,function()
        game.extras.stary = 86;
        scriptools.wait(0.8,function()
            scriptools.doOverTime(0.3,function(percent) 
                game.extras.leox = math.floor(percent*350) - 413;
            end,function()
                scriptools.wait(0.5,function() --octagon effect
                    scriptools.doOverTime(0.5,function(percent) --make octagons come in
                        game.extras.octoprog = percent;
                    end,function()
                        sound.play("ACSUD");
                        scriptools.doOverTime(0.1,function(percent) --fade flash
                            game.extras.whiteA = percent;
                        end, function() game.extras.whiteA = 0; end);
                        scriptools.doOverTime(0.3,function(percent) --fade octagons
                            game.extras.octofade = 1 - percent;
                        end, function() 
                            scriptools.wait(2,function() 
                                scriptools.doOverTime(0.2,function(percent) 
                                    game.extras.leox = -63+math.floor(percent*470);
                                    game.extras.stary = 86+ (94*percent);
                                end);
                                scriptools.doOverTime(0.5,function(percent)
                                    game.extras.overlayA = 0.5-(0.5*percent);
                                    game.extras.backpoints = {  
                                                ((game.extras.backpointsTarget[1] * (1-percent)) + (game.extras.endTarget[1] * percent)),
                                                ((game.extras.backpointsTarget[2] * (1-percent)) + (game.extras.endTarget[2] * percent)),
                                                ((game.extras.backpointsTarget[3] * (1-percent)) + (game.extras.endTarget[3] * percent)),
                                                ((game.extras.backpointsTarget[4] * (1-percent)) + (game.extras.endTarget[4] * percent)),
                                                ((game.extras.backpointsTarget[5] * (1-percent)) + (game.extras.endTarget[5] * percent)),
                                                ((game.extras.backpointsTarget[6] * (1-percent)) + (game.extras.endTarget[6] * percent)),
                                                ((game.extras.backpointsTarget[7] * (1-percent)) + (game.extras.endTarget[7] * percent)),
                                                ((game.extras.backpointsTarget[8] * (1-percent)) + (game.extras.endTarget[8] * percent))
                                                            };
                                    game.extras.frontpoints = {  
                                                ((game.extras.frontpointsTarget[1] * (1-percent)) + (game.extras.endTarget[1] * percent)),
                                                ((game.extras.frontpointsTarget[2] * (1-percent)) + (game.extras.endTarget[2] * percent)),
                                                ((game.extras.frontpointsTarget[3] * (1-percent)) + (game.extras.endTarget[3] * percent)),
                                                ((game.extras.frontpointsTarget[4] * (1-percent)) + (game.extras.endTarget[4] * percent)),
                                                ((game.extras.frontpointsTarget[5] * (1-percent)) + (game.extras.endTarget[5] * percent)),
                                                ((game.extras.frontpointsTarget[6] * (1-percent)) + (game.extras.endTarget[6] * percent)),
                                                ((game.extras.frontpointsTarget[7] * (1-percent)) + (game.extras.endTarget[7] * percent)),
                                                ((game.extras.frontpointsTarget[8] * (1-percent)) + (game.extras.endTarget[8] * percent))
                                                    };
                                    game.extras.bgpoints = {  
                                        ((game.extras.bgpointsTarget[1] * (1-percent)) + (game.extras.endTarget[1] * percent)),
                                        ((game.extras.bgpointsTarget[2] * (1-percent)) + (game.extras.endTarget[2] * percent)),
                                        ((game.extras.bgpointsTarget[3] * (1-percent)) + (game.extras.endTarget[3] * percent)),
                                        ((game.extras.bgpointsTarget[4] * (1-percent)) + (game.extras.endTarget[4] * percent)),
                                        ((game.extras.bgpointsTarget[5] * (1-percent)) + (game.extras.endTarget[5] * percent)),
                                        ((game.extras.bgpointsTarget[6] * (1-percent)) + (game.extras.endTarget[6] * percent)),
                                        ((game.extras.bgpointsTarget[7] * (1-percent)) + (game.extras.endTarget[7] * percent)),
                                        ((game.extras.bgpointsTarget[8] * (1-percent)) + (game.extras.endTarget[8] * percent))
                                            };
                                end,function()--end of cutin
                                    game.extras = {};
                                    game.extras.draw = function() end
        
                                    game.convo = Convo("cutscene/ending7");
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

    --sprite movement
    local leo = game.room.thingLookup["leo"];
    local leostartxy = {leo.x,leo.y};
    leo.setAnimation("block");
    scriptools.doOverTime(0.6,function(percent) 
        leo.x = leostartxy[1] - percent*87;
        leo.y = leostartxy[2] + percent*10;
    end,function() 
    
    end);