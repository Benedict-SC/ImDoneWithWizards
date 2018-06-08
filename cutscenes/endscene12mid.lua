game.player.setAnimation("e");
sound.play("jump");
game.player.jumpstart = game.player.y;
scriptools.doOverTime(0.5,function(percent) 
    local xadj = (percent*6)-3;
    game.player.y = game.player.jumpstart - (9 - (xadj*xadj));
end,function() 
    game.player.y = game.player.jumpstart;
end);