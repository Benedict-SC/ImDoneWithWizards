Thing = function (xp,yp,zp)
	local thing = {x=xp,y=yp,z=zp};
	thing.thingType = "Thing";
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
	thing.heldDraw = thing.draw;
	thing.disableDraw = function()
		if thing.draw == nil then
			return;
		end
		thing.heldDraw = thing.draw;
		thing.draw = function() 
		
		end
	end
	thing.enableDraw = function()
		thing.draw = thing.heldDraw;
	end
	return thing;
end
BlankThing = function()
	local base = Thing(0,0,0);
	base.thingType = "BlankThing";
	base.width = function()
		return 100;
	end
	base.height = function()
		return 100;
	end
	return base;
end
CompositeThing = function(xp,yp,zp,width,height)
	local base = Thing(xp,yp,zp);
	base.thingType = "CompositeThing";
	base.things = Array();
	base.compositeCanvas = love.graphics.newCanvas(width or gamewidth,height or gameheight);
	base.add = function(thing)
		base.things.push(thing);
	end
	base.draw = function()
		love.graphics.pushCanvas(base.compositeCanvas);
		love.graphics.clear();
		thingsUtil.renderOffset(base.things,base.width()/2,base.height());
		love.graphics.popCanvas();
		love.graphics.draw(base.compositeCanvas,math.floor((base.x - (base.width()/2))+0.5),math.floor((base.y-base.height())+0.5));
	end
	base.width = function()
		return base.compositeCanvas:getWidth();
	end
	base.height = function()
		return base.compositeCanvas:getHeight();
	end
	return base;
end
ImageThing = function (xp,yp,zp,imageurl)
	local base = Thing(xp,yp,zp);
	base.thingType = "ImageThing";
	base.img = love.graphics.newImage(imageurl);
	base.draw = function()
		love.graphics.draw(base.img,math.floor((base.x - base.img:getWidth()/2)+0.5),math.floor((base.y - base.img:getHeight())+0.5));	
	end
	base.width = function()
		return base.img:getWidth();
	end
	base.height = function()
		return base.img:getHeight();
	end
	return base;
end

CanvasThing = function(xp,yp,zp,canvas)
	local base = Thing(xp,yp,zp);
	base.thingType = "CanvasThing";
	base.canvas = canvas;
	base.draw = function()
		love.graphics.setBlendMode("alpha","premultiplied");
		love.graphics.draw(base.canvas,math.floor(base.x+0.5),math.floor(base.y+0.5));	
		love.graphics.setBlendMode("alpha","alphamultiply");
	end
	base.width = function()
		return base.canvas:getWidth();
	end
	base.height = function()
		return base.canvas:getHeight();
	end
	return base;
end

ImageyCanvasThing = function(xp,yp,zp,canvas)
	local base = Thing(xp,yp,zp);
	base.thingType = "ImageyCanvasThing";
	base.canvas = canvas;
	base.draw = function()
		love.graphics.draw(base.canvas,math.floor(base.x - (base.canvas:getWidth()/2) +0.5),math.floor(base.y - canvas:getHeight() +0.5));	
	end
	base.width = function()
		return base.canvas:getWidth();
	end
	base.height = function()
		return base.canvas:getHeight();
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
	
	for i = 1, #thingsArray, 1 do 
		local thing = thingsArray[i];
			if thing then
			if thing.shader then
				love.graphics.setShader(thing.shader);
			end
			pushColor();
			if thing.color then
				love.graphics.setColor(thing.color.r,thing.color.g,thing.color.b,thing.color.a);
			end
			thing.draw();
			popColor();
			love.graphics.setShader();
			if DEBUG_COLLIDERS and thing.collider then
				thing.collider.drawRect();
			end
		end
	end
	if DEBUG_COLLIDERS then
		pushColor();
		love.graphics.setColor(255,255,255);
		love.graphics.rectangle("line",leoBound.lx,leoBound.uy,leoBound.rx-leoBound.lx,leoBound.by-leoBound.uy);
		popColor();
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
	for i = 1, #thingsArray, 1 do 
		local thing = thingsArray[i];
		if thing.shader then
			love.graphics.setShader(thing.shader);
		end
		thingsArray[i].x = thingsArray[i].x + x;
		thingsArray[i].y = thingsArray[i].y + y;
		pushColor();
		if thing.color then
			love.graphics.setColor(thing.color.r,thing.color.g,thing.color.b,thing.color.a);
		end
		thingsArray[i].draw();
		popColor();
		thingsArray[i].x = thingsArray[i].x - x;
		thingsArray[i].y = thingsArray[i].y - y;
		love.graphics.setShader();
		if DEBUG_COLLIDERS and thingsArray[i].collider then
			thingsArray[i].collider.drawRect();
		end
	end
end