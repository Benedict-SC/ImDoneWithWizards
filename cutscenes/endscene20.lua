game.extras.circlerad = 300;
game.extras.draw = function()
    pushColor();
    love.graphics.setColor(0,0,0);
    love.graphics.pushCanvas(game.room.overlaycanvas);
    love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
    love.graphics.setBlendMode("replace");
    love.graphics.setColor(255,255,255,0);
    love.graphics.ellipse("fill",71,106,game.extras.circlerad,game.extras.circlerad);
    love.graphics.setBlendMode("alpha","alphamultiply");
    love.graphics.popCanvas();
    popColor();
end;
scriptools.doOverTime(2,function(percent)  
    game.extras.circlerad = 300 - (300*percent);
end,function() 
    sound.fadeInBGM(nil,function()
        scriptools.wait(1,function()
        
        end);
    end);
end);