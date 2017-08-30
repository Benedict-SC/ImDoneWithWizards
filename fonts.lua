loadedFonts = {};

loadedFonts["OpenDyslexic"] = love.graphics.newImageFont("fonts/image_OpenDyslexic_12.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "1234567890.,!?-+/():;%&`'*#=[]\"");
loadedFonts["OpenDyslexicBold"] = love.graphics.newImageFont("fonts/image_OpenDyslexic_12_Bold.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "1234567890.,!?-+/():;%&`'*#=[]\"");
loadedFonts["OpenDyslexicItalic"] = love.graphics.newImageFont("fonts/image_OpenDyslexic_12_Italic.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "1234567890.,!?-+/():;%&`'*#=[]\"",-.5);
loadedFonts["OpenDyslexicSmall"] = love.graphics.newImageFont("fonts/image_OpenDyslexic_8.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "1234567890.,!?-+/():;%&`'*#=[]\"");
loadedFonts["EvidenceBubbleName"] = love.graphics.newImageFont("fonts/image_EvidenceName_12.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "1234567890.,!?-+/():;%&`'*#=[]\"");
loadedFonts["TitleOption"] = love.graphics.newImageFont("fonts/image_EvidenceName_15.png",
    " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
    "abcdefghijklmnopqrstuvwxyz" ..
    "1234567890.,!?-+/():;%&`'*#=[]\"");
	
textColorShader = love.graphics.newShader[[
        vec4 effect( vec4 color, Image texture, vec2 texpoint, vec2 screenpoint){
			vec4 pixel = Texel(texture, texpoint);
			if(pixel.r == 0 && pixel.g == 0 && pixel.b == 0 && pixel.a != 0){
				return color;
			}else{
				return pixel;
			}
		}
    ]]