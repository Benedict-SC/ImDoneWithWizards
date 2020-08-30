--[[ scriptools.wait(1,function()
    game.convo = Convo("cutscene/etemp5");
    sound.play("evidenceOpen");
    game.player.state = "TEXTBOX";
    game.convo.start();
end); ]]
game.player.playOnceAndThen("rise",function() 
    game.player.setAnimation("hover");
    game.player.z = 1.3;
    scriptools.wait(1,function() 
        game.extras = {};
        game.extras.star = love.graphics.newImage("images/starcutin0.png");
        game.extras.star2 = love.graphics.newImage("images/starcutin.png");
        game.extras.swooshy = AnimatedThing(150,180,0,"swooshy");
        game.extras.swooshing = false;
        game.extras.starx = 300;
        game.extras.overlayA = 0;
        game.extras.backpoints = {130,180,150,180,150,180,130,180};
        game.extras.backpointsSource = {130,180,150,180,150,180,130,180};
        game.extras.backpointsTarget = {130,180,150,180,70,0,40,0};
        game.extras.frontpoints = {250,180,270,180,270,180,250,180};
        game.extras.frontpointsSource = {250,180,270,180,270,180,250,180};
        game.extras.frontpointsTarget = {250,180,270,180,250,0,220,0};
        game.extras.bgpoints = {150,180,250,180,250,180,150,180};
        game.extras.bgpointsSource = {150,180,250,180,250,180,150,180};
        game.extras.bgpointsTarget = {150,180,250,180,220,0,70,0};
        game.extras.endTarget = {200,180,201,180,146,0,145,0};
        game.extras.whiteA = 0;
        game.extras.draw = function()
            pushColor();
            love.graphics.setColor(0,0,0,game.extras.overlayA);
            love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
            love.graphics.setColor(0.6706,0,0.6157);
            love.graphics.polygon("fill",unpack(game.extras.bgpoints));
            love.graphics.setColor(1,1,1);
            if game.extras.swooshing then
                game.extras.swooshy.draw();
            end
            love.graphics.polygon("fill",unpack(game.extras.backpoints));
            love.graphics.draw(game.extras.star,game.extras.starx,0);
            love.graphics.setScissor( 250, 0, 50, 180 );
            game.room.render();
            love.graphics.setColor(0,0,0,game.extras.overlayA);
            love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
            love.graphics.setScissor();
            love.graphics.setColor(1,1,1);
            love.graphics.polygon("fill",unpack(game.extras.frontpoints));
            love.graphics.setColor(1,1,1,game.extras.whiteA);
            love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
            popColor();
        end
        scriptools.doOverTime(0.2,function(percent)
            game.extras.overlayA = 0.5*percent;
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
            scriptools.doOverTime(0.3,function(percent) 
                game.extras.starx = 300 - math.floor(percent*300);
            end,function()
                scriptools.wait(0.6, function()
                    game.extras.star = game.extras.star2; 
                    game.extras.swooshing = true;
                    sound.play("newACSUD");
                end);
                scriptools.wait(0.5,function() --white flash
                    scriptools.doOverTime(0.1,function(percent) 
                        game.extras.whiteA = percent;
                    end, function() 
                        game.extras.whiteA = 0;
                        scriptools.wait(2,function() 
                            scriptools.doOverTime(0.3,function(percent) 
                                game.extras.starx = 0 - math.floor(percent*300);
                            end);
                            scriptools.doOverTime(0.6,function(percent)
                                game.extras.overlayA = 0.5-(0.5*percent);
                                game.extras.swooshy.sx = 1-percent;
                                game.extras.swooshy.kx = 0.3*percent / (1-percent);
                                game.extras.swooshy.x = 150 + (155*percent);
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

                                game.convo = Convo("cutscene/ending6");
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
