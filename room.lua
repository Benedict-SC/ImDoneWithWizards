require("tileset");
require("actionmaker");
Room = function (filename)
	local room = {};
	room.jsonstring = love.filesystem.read("json/" .. filename .. ".json");
	room.data = json.decode(room.jsonstring);
	room.thingdata = room.data.things;
	room.h = table.getn(room.data.tiles);
	room.w = table.getn(room.data.tiles[1]);
	room.fake = {x=0,y=0,z=0};
	--create floor image
	room.floorcanvas = love.graphics.newCanvas(room.w*TILESET_SIZE,room.h*TILESET_SIZE);
	room.backcanvas = love.graphics.newCanvas(room.w*TILESET_SIZE,room.h*TILESET_SIZE);
	love.graphics.pushCanvas(room.floorcanvas);
	local tileset = Tileset(room.data.tileset,room.data.tilesetW,room.data.tilesetH,room.data.collisions);
	for i = 1, room.h, 1 do
		for j = 1, room.w, 1 do
			local code = room.data.tiles[i][j];
			--love.graphics.print("" .. code,7+16*j,7+16*i);
			tileset.drawTile(code,(j-1)*TILESET_SIZE,(i-1)*TILESET_SIZE);
		end
	end
	love.graphics.popCanvas();
	--populate things
	room.things = Array();
	room.colliders = Array();
	room.thingLookup = {};
	for i = 1, table.getn(room.thingdata), 1 do
		local onething = room.thingdata[i];
		local thingfunc = thingTypes[onething.thingType];
		local thing = thingfunc(onething.x,onething.y,onething.z,onething.filepath,onething.w,onething.h,onething.bw,onething.bh);
		thing.name = onething.name;
		if onething.collides then 
			collision.giveColliderBasedOnSprite(thing);
			thing.collider.offsetGeneratedSpriteCollider(onething.cXoffset,onething.cYoffset,onething.cwidth,onething.cheight);
			room.colliders.push(thing);
		end
		if onething.action then 
			configureAction(thing,onething);
		end
		room.things.push(thing);
		room.thingLookup[onething.name] = thing;
	end
	room.things.push(CanvasThing(0,0,0,room.floorcanvas));
	local environmentColliders = tileset.floorColliders();
	for i = 1, #(environmentColliders), 1 do
		room.things.push(environmentColliders[i]);
		room.colliders.push(environmentColliders[i]);
	end
	room.render = function()
		love.graphics.pushCanvas(room.backcanvas);
			love.graphics.clear();
			thingsUtil.renderThings(room.things);
		love.graphics.popCanvas();
		local playerX = room == game.room and game.player.x or room.fake.x; --don't take direct player coords if we're crossfaded out
		local playerY = room == game.room and game.player.y or room.fake.y;
		--calculate bounds and offsets
		local xmin, xmax = 0,room.backcanvas:getWidth()-(gamewidth);
		local ymin, ymax = 0,room.backcanvas:getHeight()-(gameheight);
		local playerOffsetX = playerX - (gamewidth/2);
		--if playerOffsetX < xmin then playerOffsetX = xmin end;
		--if playerOffsetX > xmax then playerOffsetX = xmax end;
		playerOffsetX = math.floor(playerOffsetX+0.5);
		local playerOffsetY = playerY - (gameheight/2);
		--if playerOffsetY < ymin then playerOffsetY = ymin end;
		--if playerOffsetY > ymax then playerOffsetY = ymax end;
		playerOffsetY = math.floor(playerOffsetY+0.5);
		love.graphics.draw(room.backcanvas,-playerOffsetX,-playerOffsetY);
		--love.graphics.draw(tcanv,5,50);
	end
	room.facsimilePlayer = function()
		room.fake = ImageyCanvasThing(game.player.x,game.player.y,game.player.z,game.player.anims[game.player.currentAnim].frames[1]);
		room.things.push(room.fake);
		if contains(room.things,game.player) then
			room.things.removeElement(game.player);
		end
		if contains(room.things,game.player) then
			error("hwo even")
		end;
	end
	room.restorePlayer = function()
		room.things.push(game.player);
		local fake = room.things.removeElement(room.fake);
		if fake then 
			game.player.x = fake.x;
			game.player.y = fake.y;
			game.player.z = fake.z;
		else
			game.player.x = 480;
			game.player.y = 295;
			game.player.z = 1;
		end
	end
	room.getCollisions = function(collider)
		local collisions = Array();
		for i = 1, #(room.colliders) do
			local collided = room.colliders[i].collider.collidesWith(collider);
			if collided then 
				collisions.push({collider = room.colliders[i].collider,zone= room.colliders[i].collider.collisionZone(collider)});
			end
		end
		return collisions;
	end
	
	return room;
end