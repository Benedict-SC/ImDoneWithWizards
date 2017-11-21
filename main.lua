screenwidth,screenheight=love.window.getDesktopDimensions();
gamewidth=300;
gameheight=180;
windowwidth=gamewidth;
windowheight=gameheight;

require("util");
require("canvas-stack");
require("thirdparty.json4lua");
require("thirdparty.tablecopy");
require("fonts");
require("scriptools");
require("sfx");
require("things");
require("rectangles");
require("textformatter");
require("textbox");
require("menus");
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

DEBUG_COLLIDERS = false;
DEBUG_TEXTRECT = false;
DEBUG_SLOW = false;
DEBUG_CONSOLE = false;
DEBUG_MUTE = false;
debug_console_string = "";
debug_console_string_2 = "";

love.window.setTitle("arcane scene investigation??? idk");
love.window.setMode(gamewidth*2,gameheight*2,{
	fullscreen=false;
	resizable=true;
	minwidth=200;
	minheight=50;
	x=screenwidth/2 - (gamewidth*2/2);
	y=screenheight/2 - (gameheight*2/2);
	
});
game = Game(gamewidth,gameheight);
--require("cutscenes.openingcutscene01");
--require("cutscenes.temp");
counter = 0;
function love.draw()
	counter = counter + 1;
	
	love.graphics.clear();
	love.graphics.pushCanvas(game.canvas);
	love.graphics.clear();
	--updates
	game.update();
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
		love.graphics.setColor(255,255,255);
		love.graphics.print("console:\n" .. debug_console_string .. "\n" .. debug_console_string_2);
		love.graphics.setShader();
		popColor();
	end
end