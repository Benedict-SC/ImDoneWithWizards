sfx = {};
sfx.play = function(clip)
	clip:stop();
	clip:play();
end
sfx.playRandomPitch = function (clip, width)
	local rand = math.random();
	
	local pitch = 1 - (width/2) + (rand*width);
	love.graphics.print(""..pitch);
	clip:stop();
	clip:setPitch(pitch);
	clip:play();
end
sfx.playBGM = function(bgm)
	if sfx.bgm then
		sfx.bgm:stop();
	end
	sfx.bgm = bgm;
	sfx.bgm:play();
end
sfx.fragmentWhoosh = love.audio.newSource("sfx/fragment_whoosh.ogg");
sfx.questionBeep = love.audio.newSource("sfx/floomp.ogg");
sfx.questionBeep:setVolume(0.3);
sfx.questionBeep:setPitch(1.5);
sfx.evidenceScroll = love.audio.newSource("sfx/question_beep.ogg");
sfx.evidenceScroll:setPitch(1.5);
sfx.evidenceOpen = love.audio.newSource("sfx/vocal_whish.ogg");
sfx.evidenceOpen:setVolume(0.5);
sfx.evidenceClose = love.audio.newSource("sfx/vocal_whoosh.ogg");
sfx.evidenceClose:setVolume(0.5);
sfx.invalid = love.audio.newSource("sfx/vocal_nuhuh.ogg");
sfx.invalid:setVolume(0.5);
sfx.hypothesisUpdated = love.audio.newSource("sfx/hypothesisupdate.ogg");
sfx.hypothesisUpdated:setVolume(0.7);

sfx.bgmDemo = love.audio.newSource("sfx/bgm_demo.ogg");
if not (sfx.bgmDemo) then error("failed to load bgm"); end
sfx.bgmDemo:setLooping(true);
