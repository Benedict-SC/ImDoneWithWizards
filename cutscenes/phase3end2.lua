scriptools.doOverTime(0.8,function(percent)
    love.graphics.pushCanvas(game.room.overlaycanvas);
    love.graphics.clear();
    love.graphics.setColor(0,0,0,math.floor(percent*255));
    love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
    love.graphics.popCanvas();
end,function()
    local leo = game.room.thingLookup["leo"];
    local opal = game.room.thingLookup["opal"];
    leo.x = savedLeo.x;
    leo.y = savedLeo.y;
    opal.x = savedOpal.x;
    opal.y = savedOpal.y;
    game.player.x = savedStar.x;
    game.player.y = savedStar.y;
    leo.setAnimation("s");
    game.player.setAnimation("s");
    scriptools.recenterCamera(0.1,{x=0,y=20});
    scriptools.doOverTime(0.8,function(percent)
        love.graphics.pushCanvas(game.room.overlaycanvas);
        love.graphics.clear();
        love.graphics.setColor(0,0,0,255-math.floor(percent*255));
        love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
        love.graphics.popCanvas();
    end,function()
        scriptools.wait(0.4,function()
            game.player.state = "MOVING";
        end);
    end);
end);