game.player.state = "NOCONTROL";
game.player.isColliding = false;
love.graphics.pushCanvas(game.room.overlaycanvas);
love.graphics.setColor(0,0,0);
love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
love.graphics.popCanvas();
sound.fadeInBGM(nil,function()
	game.convo = Convo("cutscene/gdc");
	sound.play("evidenceOpen");
	game.player.state = "TEXTBOX";
	game.convo.start();
end);