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
                        game.convo = Convo("cutscene/LMtut2");
                        sound.play("evidenceOpen");
                        game.player.state = "TEXTBOX";
                        game.convo.start();
                    end);
                end);
            end);
        end);
    end);
end);