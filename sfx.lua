sfx = {};
sfx.handles = {};
sfx.play = function(clip)
	if not clip then
		return;
	end
	if sfx.handles[clip] then 
		sfx.handles[clip].cancel = true; 
	end
	clip:stop();
	clip:play();
end
sfx.mute = function()
	love.audio.setVolume(0);
end
sfx.unmute = function()
	love.audio.setVolume(1);
end
sfx.stop = function(clip) --yeah i know this is redundant. shut up.
	if not clip then
		return;
	end
	clip:stop();
end
sfx.playRandomPitch = function (clip, width)
	if not clip then
		return;
	end
	local rand = math.random();
	
	local pitch = 1 - (width/2) + (rand*width);
	love.graphics.print(""..pitch);
	clip:stop();
	clip:setPitch(pitch);
	clip:play();
end
sfx.playBGM = function(bgm)
	if sfx.handles[bgm] then 
		sfx.handles[bgm].cancel = true; 
	end
	if sfx.handles[sfx.bgm] then 
		sfx.handles[sfx.bgm].cancel = true; 
	end
	if sfx.handles[sfx.fadingInBgm] then 
		sfx.handles[sfx.fadingInBgm].cancel = true;
	end
	if sfx.bgm then
		sfx.bgm:stop();
	end
	if sfx.fadingInBgm then 
		sfx.fadingInBgm:stop();
	end
	sfx.bgm = bgm;
	sfx.fadingInBgm = nil;
	sfx.bgm:setVolume(1);
	sfx.bgm:play();
end
sfx.fade = function(clip,whenGone,secs)
	local originalVolume = clip:getVolume();
	if sfx.handles[clip] then 
		sfx.handles[clip].cancel = true; 
	end
	sfx.handles[clip] = scriptools.doOverTime(secs or 1.5,function(percent) 
		clip:setVolume((1-percent) * originalVolume);
	end,function()
		clip:stop();
		clip:setVolume(originalVolume);
		if whenGone then 
			whenGone();
		end
	end);
end
sfx.fadeBGM = function(whenGone,secs)
	secs = secs or 1.5;
	if sfx.bgm == nil then
		if whenGone then 
			whenGone();
		end
		return;
	end
	sfx.whenGone = whenGone;
	if sfx.handles[sfx.bgm] then 
		sfx.handles[sfx.bgm].cancel = true; 
	end
	local fadingBGM = sfx.bgm;
	sfx.handles[fadingBGM] = scriptools.doOverTime(secs,function(percent) 
		fadingBGM:setVolume(1-percent);
	end,function()
		fadingBGM:setVolume(1);
		fadingBGM:stop();
		if sfx.whenGone then 
			sfx.whenGone(); 
			sfx.whenGone = nil;
		end
		sfx.handles[fadingBGM] = nil;
	end);
end
sfx.fadeInNewBGM = function(secs,newbgm,whenIn)
	secs = secs or 1.5;
	local originalPercent = 0;
	local fadeInPercent = 0;
	if sfx.bgm then
		originalPercent = sfx.bgm:getVolume();
	end
	if sfx.fadingInBgm then
		fadeInPercent = sfx.fadingInBgm:getVolume();
	end
	sfx.whenIn = whenIn;
	
	--housekeeping
	if sfx.handles[sfx.bgm] then 
		sfx.handles[sfx.bgm].cancel = true;
	end
	if sfx.handles[sfx.fadingInBgm] then 
		sfx.handles[sfx.fadingInBgm].cancel = true;
	end
	if sfx.handles[newbgm] then 
		sfx.handles[newbgm].cancel = true;
	end
	--now all current bgms are cancelled, not moving
	
	if sfx.fadingInBgm and (sfx.bgm == newbgm) then --stop what you're doing and reverse fades
		--if not newbgm then error("reversing newbgm is nil"); end	
		--debug_console_string_2 = "we're fading in new bgm reversewise";
		local swap = sfx.fadingInBgm;
		sfx.fadingInBgm = sfx.bgm;
		sfx.bgm = swap;
		--fade in new
		sfx.handles[sfx.fadingInBgm] = scriptools.doOverTime(secs*originalPercent,function(percent) 
			sfx.fadingInBgm:setVolume(originalPercent + ((1-originalPercent)*percent) );
		end,function()
			sfx.bgm = sfx.fadingInBgm;
			sfx.fadingInBgm = nil;
			sfx.bgm:setVolume(1);
			if sfx.whenIn then 
				sfx.whenIn(); 
				sfx.whenIn = nil;
			end
			sfx.handles[sfx.bgm] = nil;
		end);
		--fade out old
		local oldie = sfx.bgm;
		sfx.handles[oldie] = scriptools.doOverTime(secs*fadeInPercent,function(percent) 
			oldie:setVolume(fadeInPercent - (fadeInPercent*percent) );
		end,function()
			if oldie then
				oldie:stop();
				oldie:setVolume(1);
			end
			sfx.handles[oldie] = nil;
		end);
	elseif newbgm == sfx.fadingInBgm then --you're already fading this in! don't worry
		--[[if not newbgm then
			debug_console_string_2 = "newbgm is nil!";
		else
			debug_console_string_2 = "no need to fade in new bgm";
		end]]--
		return; 
	else --fading in something that isn't either
		--if not newbgm then error("new newbgm is nil"); end
		--fade out olds
		--debug_console_string_2 = "fading out both oldies";
		local oldie1 = sfx.fadingInBgm;
		if oldie1 then
			sfx.handles[oldie1] = scriptools.doOverTime(secs*fadeInPercent,function(percent) 
				oldie1:setVolume(fadeInPercent - (fadeInPercent*percent) );
			end,function()
				if oldie1 then
					oldie1:stop();
					oldie1:setVolume(1);
				end
				sfx.handles[oldie1] = nil;
			end);
		end
		local oldie2 = sfx.bgm;
		if oldie2 then
			sfx.handles[oldie2] = scriptools.doOverTime(secs*originalPercent,function(percent) 
				oldie2:setVolume(originalPercent - (originalPercent*percent) );
			end,function()
				if oldie2 then
					oldie2:stop();
					oldie2:setVolume(1);
				end
				sfx.handles[oldie2] = nil;
			end);
		end
		--fade in new
		sfx.fadingInBgm = newbgm;
		sfx.fadingInBgm:setVolume(0);
		sfx.fadingInBgm:play();
		sfx.handles[sfx.fadingInBgm] = scriptools.doOverTime(secs,function(percent) 
			sfx.fadingInBgm:setVolume(percent);
		end,function()
			sfx.bgm = sfx.fadingInBgm;
			sfx.fadingInBgm = nil;
			sfx.bgm:setVolume(1);
			if sfx.whenIn then 
				sfx.whenIn(); 
				sfx.whenIn = nil;
			end
			sfx.handles[sfx.bgm] = nil;
		end);
	end
	
end
--[[scriptools.doForever(function() 
	local bgmVol = "n/a";
	if sfx.bgm then
		bgmVol = sfx.bgm:getVolume();
	end
	local fadeinVol = "n/a";
	if sfx.fadingInBgm then
		fadeinVol = sfx.fadingInBgm:getVolume();
	end
	debug_console_string = "bgm vol: " .. bgmVol .. "\nfadein vol: " .. fadeinVol;
end);]]--
sfx.fadeParallelBGM = function(secs,bgm,whenIn)
	local position = 0;
	if sfx.bgm then
		position = sfx.bgm:tell();
	end
	sfx.fadeInNewBGM(secs,bgm,whenIn);
	sfx.fadingInBgm:seek(position);
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
sfx.phoneRing = love.audio.newSource("sfx/vocal_ring.ogg");
sfx.bang = love.audio.newSource("sfx/vocal_bang.ogg");
sfx.bang:setVolume(1.3);
sfx.siren = love.audio.newSource("sfx/police_siren.ogg");
sfx.siren:setVolume(0.2);
sfx.doorOpen = love.audio.newSource("sfx/door_open.ogg");
sfx.doorClose = love.audio.newSource("sfx/door_close.ogg");
sfx.exclaim = love.audio.newSource("sfx/exclaim.ogg");
sfx.fireAlarm = love.audio.newSource("sfx/fire_alarm.ogg");
sfx.fireAlarm:setVolume(0.3);
sfx.fireAlarm:setLooping(true);
sfx.schwing = love.audio.newSource("sfx/vocal_schwing.ogg");
sfx.save = love.audio.newSource("sfx/vocal_save_noise.ogg");

sfx.beeps = {};
sfx.beeps["Star"] = love.audio.newSource("sfx/beep1.ogg");
sfx.beeps["Starr"] = sfx.beeps["Star"];
sfx.beeps["Landlord"] = sfx.beeps["Star"];
sfx.beeps["Leo"] = love.audio.newSource("sfx/beep2.ogg");
sfx.beeps["Star"]:setLooping(true);
sfx.beeps["Star"]:setVolume(0.7);
sfx.beeps["Leo"]:setLooping(true);
sfx.beeps["Leo"]:setVolume(1.7);

sfx.bgmDemo = love.audio.newSource("sfx/Cledonomancer.ogg");
sfx.induction = love.audio.newSource("sfx/Induction_of_Justice.ogg");
sfx.magicSquare = love.audio.newSource("sfx/Magic_Square.ogg");
sfx.halfpasttwo = love.audio.newSource("sfx/Half_Past_Two.ogg");
sfx.maintheme = love.audio.newSource("sfx/WIZARD_GAME_MAIN_THEME_LOOP.ogg");
sfx.mainthemeIntro = love.audio.newSource("sfx/WIZARD_GAME_MAIN_THEME_INTRO_-_extra_tail.ogg");
sfx.wwwwwh = love.audio.newSource("sfx/WWWWWH.ogg");
sfx.hypothesisMusic = love.audio.newSource("sfx/Eliminate_The_Impossible.ogg");
if not (sfx.mainthemeIntro) then error("failed to load bgm"); end
sfx.bgmDemo:setLooping(true);
sfx.induction:setLooping(true);
sfx.magicSquare:setLooping(true);
sfx.halfpasttwo:setLooping(true);
sfx.maintheme:setLooping(true);
sfx.wwwwwh:setLooping(true);
sfx.hypothesisMusic:setLooping(true);