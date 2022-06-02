screenwidth,screenheight=love.window.getDesktopDimensions();
gamewidth=300;
gameheight=180;
windowwidth=gamewidth;
windowheight=gameheight;
iconimg = love.graphics.newImage("haticon.png");
local iconCanvas = love.graphics.newCanvas(305,305);
love.graphics.setCanvas(iconCanvas);
love.graphics.draw(iconimg,0,0);
love.graphics.setCanvas();
love.window.setIcon(iconCanvas:newImageData());
love.window.setTitle("Star Seeker in: the Secret of the Sorcerous Standoff");
love.window.setMode(gamewidth*2,gameheight*2,{
	fullscreen=false;
	resizable=true;
	minwidth=200;
	minheight=50;
	x=screenwidth/2 - (gamewidth*2/2);
	y=screenheight/2 - (gameheight*2/2);
	
});

require("util");
require("canvas-stack");
require("thirdparty.json4lua");
require("thirdparty.tablecopy");
require("fonts");
require("scriptools");
require("sound");
require("things");
require("behaviors");
require("rectangles");
require("pronouns");
require("textformatter");
require("textbox");
require("menus");
require("achievement");
require("game");
require("room");
require("palace");
require("input");
require("lifetime");
require("save");
require("player");
require("emotes");
require("collision");
require("convo");
require("hypothesis");
require("inventory");
require("log");
require("controls");

if love.system.getOS() == 'OS X' then
	local sourceDirectory = love.filesystem.getSourceBaseDirectory()
	local cpath = package.cpath;
	package.cpath = string.format(
			"%s/ext/?.dll;%s/ext/?.so;%s",
			sourceDirectory,
			sourceDirectory,
			cpath);
	local path = package.path;
	package.path = string.format(
			"%s/ext/?.lua;%s/ext/?/init.lua;%s",
			sourceDirectory,
			sourceDirectory,
			cpath);
end

--[[Steam = require("luasteam");
local steam_active = Steam.init();
if not steam_active then 
    error("Fatal error - Steam must be running to play this game (SteamAPI_init() failed).\n");
end
Steam.userStats.requestCurrentStats();
Steam.userStats.onUserStatsReceived = function(data)
	debug_console_string_2 = "stats came back and we're ready to cheevo"
end]]--

DEBUG_COLLIDERS = false;
DEBUG_TEXTRECT = false;
DEBUG_SLOW = false;
DEBUG_CONSOLE = false;
DEBUG_MUTE = false;
DEBUG_SKIP = false;
DEBUG_STARTROOM = false;
if DEBUG_MUTE then love.audio.setVolume(0); end
debug_console_string = "";
debug_console_string_2 = "";
debug_console_string_3 = "...";

gameFPS = 80;
game = Game(gamewidth,gameheight);
--require("cutscenes.openingcutscene01");
--require("cutscenes.temp");
counter = 0;
function love.draw()
	--first: framerate limit
	local start = love.timer.getTime();
	counter = counter + 1;
	
	love.graphics.clear();
	love.graphics.pushCanvas(game.canvas);
	love.graphics.clear();
	--updates
	game.update();
	--Steam.runCallbacks();
	if DEBUG_SLOW then
		if (counter%6 == 0) then 
			input.update();
			mortalCoil.update();
		end
	else
		input.update();
		mortalCoil.update();
	end
	love.graphics.popCanvas();
	windowwidth,windowheight=love.window.getMode();
	local xoff,yoff = 0,0;
	local mult = 1;
		local xmult = math.floor(windowwidth/gamewidth);
		local ymult = math.floor(windowheight/gameheight);
		xmult = xmult > 0 and xmult or 1;
		ymult = ymult > 0 and ymult or 1;
		mult = math.min(xmult,ymult);
		
		local xspace = math.floor(windowwidth - (mult*gamewidth));
		local yspace = math.floor(windowheight - (mult*gameheight));
		xoff = math.floor(xspace/2);
		yoff = math.floor(yspace/2);
	love.graphics.draw(game.canvas,xoff,yoff,0,mult,mult);
	if DEBUG_CONSOLE then
		pushColor();
		love.graphics.setShader(textColorShader);
		love.graphics.setColor(0,0.7843,0);
		love.graphics.print("console:\n" .. debug_console_string .. "\n" .. debug_console_string_2 .. "\n" .. debug_console_string_3);
		love.graphics.setShader();
		popColor();
	end
	--finish framerate limiting
	local frametime = love.timer.getTime() - start;
	
	--debug_console_string_3 = "fps: " .. love.timer.getFPS();
	love.timer.sleep((1/gameFPS)-frametime)
end
function love.quit()
	--Steam.shutdown();
	return false;
end