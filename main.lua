require("util");
require("canvas-stack");
require("thirdparty.json4lua");
require("thirdparty.tablecopy");
require("sfx");
require("things");
require("rectangles");
require("textformatter");
require("textbox");
require("game");
require("room");
require("input");
require("lifetime");
require("player");
require("collision");
require("convo");
require("hypothesis");
require("inventory");

DEBUG_COLLIDERS = false;
DEBUG_TEXTRECT = false;
DEBUG_SLOW = false;

screenwidth,screenheight=love.window.getDesktopDimensions();
gamewidth=900;
gameheight=550;
love.window.setTitle("A wizard dead is");
love.window.setMode(gamewidth,gameheight,{
	fullscreen=false;
	resizable=true;
	minwidth=300;
	minheight=50;
	x=screenwidth/2 - (gamewidth/2);
	y=screenheight/2 - (gameheight/2);
	
});
game = Game(gameheight,gamewidth);
counter = 0;
function love.draw()
	counter = counter + 1;
	
	love.graphics.clear();
	love.graphics.setCanvas(game.canvas);
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
	love.graphics.setCanvas();
	love.graphics.draw(game.canvas);
end