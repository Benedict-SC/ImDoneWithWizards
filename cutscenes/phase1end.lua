local lastIndex = game.hypothesis.addFragment("F00a");
game.hypothesis.activeFragment = lastIndex;
game.hypothesis.show();
game.player.updateSprite(0,0);
game.player.state = "HYPOTHESIS";