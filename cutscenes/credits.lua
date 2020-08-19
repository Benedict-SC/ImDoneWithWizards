
--temptest
creditsThings = Array();
sound.playBGM("magicSquare");
game.player.state = "NOCONTROL";
local logo = ImageThing(gamewidth/2,gameheight,0,"images/biglogo.png");
logo.color = {r=255,g=255,b=255,a=255};
creditsThings.push(logo);
creditsThings.flash = 0;
game.extras = {};
local creditsBaseDraw = function()
    pushColor();
    love.graphics.clear(0,0,0);
    thingsUtil.renderThings(creditsThings);
    if creditsThings.flash < 0 then
        love.graphics.setColor(0,0,0,-creditsThings.flash);
    else
        love.graphics.setColor(255,255,255,creditsThings.flash);
    end
    love.graphics.rectangle("fill",0,0,gamewidth,gameheight);
    popColor();
end
game.extras.draw = function()
    creditsBaseDraw();
end
darkflash = function(length,midflash,afterflash)
    scriptools.doOverTime(length/2,function(percent) 
        creditsThings.flash = -255*percent;
    end,function()
        midflash();
        scriptools.doOverTime(length/2,function(percent)
            creditsThings.flash = -255 + (255*percent);
        end,function()
            creditsThings.flash = 0; 
            afterflash();
        end);
    end);
end
nametime = 5;
creditsdelay = 3;
scriptools.doOverTime(nametime,function(percent)
	logo.color.a = math.floor(255*percent);
end,function()
    logo.color.a = 255;
    scriptools.wait(1,function()
        scriptools.doOverTime(nametime-1,function(percent)
            logo.y = gameheight - (gameheight*percent);
        end,function()
            local agameby = TextThing(gamewidth,29,0,"A game by","TitleOption",{r=255,g=255,b=255});
            creditsThings.push(agameby);
            scriptools.doOverTime(0.8,function(percent)
                agameby.x = gamewidth - (190*percent);
            end,function()
                agameby.x = 110;
                scriptools.wait(0.5,function()
                    scriptools.doOverTime(0.3,function(percent) 
                        creditsThings.flash = 255*percent;
                    end,function()
                        local bene = ImageThing(gamewidth/2,gameheight,0,"images/credits/bene.png");
                        creditsThings.push(bene);
                        scriptools.doOverTime(0.3,function(percent) 
                            creditsThings.flash = 255- 255*percent;
                        end,function()
                            creditsThings.flash = 0;         
                            local benecreds = TextThing(180,gameheight,0,"programming\nwriting\ncharacter design\ncharacter portraits\nmore programming\nUI design\ngoat wrangling\nSFX\nproduction\nprogramming again\nall the stuff that\n other people didn't do","OpenDyslexic",{r=255,g=255,b=255});
                            creditsThings.push(benecreds);
                            scriptools.doOverTime(5,function(percent) 
                                benecreds.y = math.floor(gameheight - (percent*320) + 0.5);
                            end,function()
                                benecreds.y = -140;     
                                darkflash(0.8,function() 
                                    bene.inactive = true;
                                    benecreds.inactive = true;
                                    agameby.inactive = true;
                                    creditsThings.zero = ImageThing(gamewidth/2,gameheight,0,"images/credits/zero.png");
                                    creditsThings.zerocreds = TextThing(20,20,1,"Environment art",
                                    "TitleOption",{r=255,g=255,b=255});
                                    creditsThings.zerolink = TextThing(6,164,1,"artstation.com/drazelic","OpenDyslexicBold",{r=255,g=255,b=255});
                                    creditsThings.push(creditsThings.zero);
                                    creditsThings.push(creditsThings.zerocreds);
                                    creditsThings.push(creditsThings.zerolink);
                                end,function() 
                                    scriptools.wait(creditsdelay,function()
                                        darkflash(0.8,function() 
                                            creditsThings.zero.inactive = true;
                                            creditsThings.zerocreds.inactive = true;
                                            creditsThings.zerolink.inactive = true;
                                            creditsThings.kyle = ImageThing(gamewidth/2,gameheight,0,"images/credits/kyle.png");
                                            creditsThings.kylecreds = TextThing(120,20,1,"Evidence art","TitleOption",{r=255,g=255,b=255});
                                            creditsThings.kylelink = TextThing(176,164,1,"kjtpixel.weebly.com","OpenDyslexicBold",{r=255,g=255,b=255});
                                            creditsThings.push(creditsThings.kyle);
                                            creditsThings.push(creditsThings.kylecreds);
                                            creditsThings.push(creditsThings.kylelink);
                                        end,function() 
                                            scriptools.wait(creditsdelay,function()
                                                darkflash(0.8,function() 
                                                    creditsThings.kyle.inactive = true;
                                                    creditsThings.kylecreds.inactive = true;
                                                    creditsThings.kylelink.inactive = true;
                                                    creditsThings.maxie = ImageThing(gamewidth/2,gameheight,0,"images/credits/maxie.png");
                                                    creditsThings.maxiecreds = TextThing(20,20,0,"Soundtrack composer","TitleOption",{r=255,g=255,b=255});
                                                    creditsThings.maxieLink = TextThing(6,164,1,"maxiesatan.carrd.co","OpenDyslexicBold",{r=255,g=255,b=255});
                                                    creditsThings.push(creditsThings.maxie);
                                                    creditsThings.push(creditsThings.maxiecreds);
                                                    creditsThings.push(creditsThings.maxieLink);
                                                end,function() 
                                                    scriptools.wait(creditsdelay,function()
                                                        darkflash(0.8,function() 
                                                            creditsThings.maxie.inactive = true;
                                                            creditsThings.maxiecreds.inactive = true;
                                                            creditsThings.maxieLink.inactive = true;
                                                            creditsThings.malky = ImageThing(gamewidth/2,gameheight,0,"images/credits/malk.png");
                                                            creditsThings.malkycreds = TextThing(130,20,0,"Script consultant","TitleOption",{r=255,g=255,b=255});
                                                            creditsThings.malkycreds2 = TextThing(140,37,0,"+video editing, QA","OpenDyslexic",{r=255,g=255,b=255});
                                                            creditsThings.push(creditsThings.malky);
                                                            creditsThings.push(creditsThings.malkycreds);
                                                            creditsThings.push(creditsThings.malkycreds2);
                                                        end,function() 
                                                            scriptools.wait(creditsdelay,function()
                                                                darkflash(0.8,function() 
                                                                    creditsThings.malky.inactive = true;
                                                                    creditsThings.malkycreds.inactive = true;
                                                                    creditsThings.malkycreds2.inactive = true;
                                                                    --let's do some cleanup
                                                                    creditsThings = Array();
                                                                    creditsThings.flash = -255;
                                                                    --okay where were we
                                                                    creditsThings.qalabel = TextThing(20,20,0,"QA Team","TitleOption",{r=255,g=255,b=255});
                                                                    creditsThings.push(creditsThings.qalabel);
                                                                    creditsThings.qalist = TextThing(25,40,0,"GrayGriffin\nKeltena\nMalkyTop\nYumAntimatter\n\nCryptovexillologist\nFarn\nKelardry\nQuaetam","OpenDyslexic",{r=255,g=255,b=255});
                                                                    creditsThings.push(creditsThings.qalist);
                                                                end,function() 
                                                                    scriptools.wait(creditsdelay,function()
                                                                        darkflash(0.8,function() 
                                                                            creditsThings.qalabel.inactive = true;
                                                                            creditsThings.qalist.inactive = true;
                                                                            creditsThings.titleg = TextThing(20,20,0,"Title graphic","TitleOption",{r=255,g=255,b=255});
                                                                            creditsThings.push(creditsThings.titleg);
                                                                            creditsThings.titlist = TextThing(25,38,0,"Sabrina Carballo\nJunnior Ocopio","OpenDyslexic",{r=255,g=255,b=255});
                                                                            creditsThings.push(creditsThings.titlist);
                                                                            creditsThings.soundy = TextThing(123,55,0,"Free sound effects","TitleOption",{r=255,g=255,b=255});
                                                                            creditsThings.push(creditsThings.soundy);
                                                                            creditsThings.soundpeeps = TextThing(123,75,0,"Mike Koenig (soundbible.com)\nJoe DeShon (freesound.org)\nAcclivity (freesound.org)\nRichard Frohlich (freesound.org)\nInspectorJ (freesound.org)","OpenDyslexic",{r=255,g=255,b=255});
                                                                            creditsThings.push(creditsThings.soundpeeps);
                                                                            creditsThings.doodlet = TextThing(20,142,0,"Additional character designs","TitleOption",{r=255,g=255,b=255});
                                                                            creditsThings.push(creditsThings.doodlet);
                                                                            creditsThings.doodle = TextThing(25,160,0,"David Oneacre (davidoneacre.com)","OpenDyslexic",{r=255,g=255,b=255});
                                                                            creditsThings.push(creditsThings.doodle);
                                                                        end,function() 
                                                                            scriptools.wait(creditsdelay,function()
                                                                                darkflash(0.8,function() 
                                                                                    creditsThings.titleg.inactive = true;
                                                                                    creditsThings.titlist.inactive = true;
                                                                                    creditsThings.soundy.inactive = true;
                                                                                    creditsThings.soundpeeps.inactive = true;
                                                                                    creditsThings.doodlet.inactive = true;
                                                                                    creditsThings.doodle.inactive = true;
                                                                                end,function()
                                                                                    sound.fadeInBGM(); 
                                                                                    scriptools.wait(1.5,function()
                                                                                        game.extras = {};
                                                                                        game.extras.draw = function() end
                                                                                        creditsThings = nil;
                                                                                        game.menuMode = true;
                                                                                        game.menu = game.title;
                                                                                        sound.playBGM("maintheme");
                                                                                    end);
                                                                                end);
                                                                            end);
                                                                        end);
                                                                    end);
                                                                end);
                                                            end);
                                                        end);
                                                    end);
                                                end);
                                            end);
                                        end);
                                    end);
                                end);                                               
                            end);               
                        end);
                    end);
                end);
            end);
        end);
    end);
end);