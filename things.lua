Thing = function (xp,yp,zp)
	local thing = {x=xp,y=yp,z=zp};
	thing.draw = function()
	
	end
	thing.nilFunction = function() end
	thing.deactivate = function()
		thing.drawHolder = thing.draw;
		thing.draw = thing.nilFunction;
	end
	thing.offsetDraw = function(x,y)
		thing.x = thing.x + x;
		thing.y = thing.y + y;
		thing.draw();
		thing.x = thing.x - x;
		thing.y = thing.y - y;
	end
	thing.activate = function()
		if thing.drawHolder then	
			thing.draw = thing.drawHolder;
		end
	end
	return thing;
end
BlankThing = function()
	local base = Thing(0,0,0);
	base.width = function()
		return 100;
	end
	return base;
end
CompositeThing = function(xp,yp,zp)
	local base = Thing(xp,yp,zp);
	base.things = Array();
	base.compositeCanvas = love.graphics.newCanvas(gamewidth,gameheight);
	base.add = function(thing)
		base.things.push(thing);
	end
	base.draw = function()
		thingsUtil.renderOffset(base.things,base.x,base.y);
	end
	return base;
end
ImageThing = function (xp,yp,zp,imageurl)
	local base = Thing(xp,yp,zp);
	base.img = love.graphics.newImage(imageurl);
	base.draw = function()
		love.graphics.draw(base.img,math.floor((base.x - base.img:getWidth()/2)+0.5),math.floor((base.y - base.img:getHeight())+0.5));	
	end
	base.width = function()
		return base.img:getWidth();
	end
	return base;
end

CanvasThing = function(xp,yp,zp,canvas)
	local base = Thing(xp,yp,zp);
	base.canvas = canvas;
	base.draw = function()
		love.graphics.draw(base.canvas,math.floor(base.x+0.5),math.floor(base.y+0.5));	
	end
	base.width = function()
		return base.canvas:getWidth();
	end
	return base;
end

ImageyCanvasThing = function(xp,yp,zp,canvas)
	local base = Thing(xp,yp,zp);
	base.canvas = canvas;
	base.draw = function()
		love.graphics.draw(base.canvas,math.floor(base.x - (base.canvas:getWidth()/2) +0.5),math.floor(base.y - canvas:getHeight() +0.5));	
	end
	base.width = function()
		return base.canvas:getWidth();
	end
	return base;
end

require("animation");
require("borders");

thingTypes = {};
thingTypes.Thing = Thing;
thingTypes.ImageThing = ImageThing;
thingTypes.CanvasThing = CanvasThing;
thingTypes.AnimatedThing = AnimatedThing;
thingTypes.BorderedThing = BorderedThing;

thingsUtil = {};
thingsUtil.renderThings = function(thingsArray) 
	--thingsUtil.renderOffset(thingsArray,0,0);
	if #thingsArray < 1 then return; end --don't sort empty array
	table.sort(thingsArray,function(a,b)
		if a.z == b.z then
			return a.y < b.y;
		end
		return a.z < b.z;
	end)
	for i = 1, thingsArray.size, 1 do 
		thingsArray[i].draw();
		if DEBUG_COLLIDERS and thingsArray[i].collider then
			thingsArray[i].collider.drawRect();
		end
	end
end
thingsUtil.renderOffset = function (thingsArray,x,y)
	if #thingsArray < 1 then return; end --don't sort empty array
	table.sort(thingsArray,function(a,b)
		if a.z == b.z then
			return a.y < b.y;
		end
		return a.z < b.z;
	end)
	for i = 1, thingsArray.size, 1 do 
		thingsArray[i].x = thingsArray[i].x + x;
		thingsArray[i].y = thingsArray[i].y + y;
		thingsArray[i].draw();
		thingsArray[i].x = thingsArray[i].x - x;
		thingsArray[i].y = thingsArray[i].y - y;
		if DEBUG_COLLIDERS and thingsArray[i].collider then
			thingsArray[i].collider.drawRect();
		end
	end
end