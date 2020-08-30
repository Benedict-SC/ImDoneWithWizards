require("tileset");
require("actionmaker");
Room = function (filename)
	local room = {};
	room.jsonstring = love.filesystem.read(filename .. ".json");
	room.data = json.decode(room.jsonstring);
	room.thingdata = room.data.things;
	room.h = table.getn(room.data.tiles);
	room.w = table.getn(room.data.tiles[1]);
	room.camera = {x=0,y=0};
	room.fake = {x=0,y=0,z=0};
	--create floor image
	room.floorcanvas = love.graphics.newCanvas(room.w*TILESET_SIZE,room.h*TILESET_SIZE);
	room.backcanvas = love.graphics.newCanvas(room.w*TILESET_SIZE,room.h*TILESET_SIZE);
	room.overlaycanvas = love.graphics.newCanvas(gamewidth,gameheight);
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
	room.HUDthings = Array();
	room.thingLookup = {};
	for i = 1, table.getn(room.thingdata), 1 do
		local onething = room.thingdata[i];
		local thingfunc = thingTypes[onething.thingType];
		local thing = thingfunc(onething.x,onething.y,onething.z,onething.filepath,onething.w,onething.h,onething.bw,onething.bh);
		thing.name = onething.name;
		thing.filepath = onething.filepath;
		thing.altpath = onething.altpath;
		if thing.name == "leo" then
			behaviors.makeIntoLeo(thing);
		end
		if thing.name == "hologram" then
			behaviors.makeIntoSlick(thing);
		end
		if thing.name == "bullet" then
			behaviors.makeIntoBullet(thing);
		end
		if thing.name == "table" then
			thing.liteImg = thing.img;
			if thing.filepath == "images/table3.png" then
				thing.darkImg = behaviors.darktable;
			else
				thing.darkImg = behaviors.darktableD;
			end
		end
		thing.useColliderInsteadOfSprite = onething.useColliderInsteadOfSprite;
		if onething.color then
			if onething.color.a then
				thing.color = onething.color;
			else
				thing.color = {r=onething.color.r/255,g=onething.color.g/255,b=onething.color.b/255,a=1};
			end
		end
		--thing.rawdata = onething; --just in case
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
	room.HUDthings.push(CanvasThing(0,0,100,room.overlaycanvas));
	local environmentColliders = tileset.floorColliders();
	for i = 1, #(environmentColliders), 1 do
		room.things.push(environmentColliders[i]);
		room.colliders.push(environmentColliders[i]);
	end
	room.leo = room.thingLookup["leo"];
	room.update = function()
		if room.leo then
			room.leo.leoUpdate();
		end
		if room.wrap then
			if game.player.x < room.wrap.xmin then
				game.player.x = room.wrap.xmax - 1;
			elseif game.player.x > room.wrap.xmax then
				game.player.x = room.wrap.xmin + 1;
			end
			if game.player.y < room.wrap.ymin then
				game.player.y = room.wrap.ymax - 1;
			elseif game.player.y > room.wrap.ymax then
				game.player.y = room.wrap.ymin + 1;
			end
		end
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
		love.graphics.draw(room.backcanvas,-playerOffsetX - room.camera.x + game.shake.x,-playerOffsetY - room.camera.y+ game.shake.y);
		thingsUtil.renderThings(room.HUDthings);
		--love.graphics.draw(tcanv,5,50);
	end
	room.facsimilePlayer = function()
		room.fake = ImageyCanvasThing(game.player.x,game.player.y,game.player.z,game.player.anims[game.player.currentAnim].frames[1]);
		room.things.push(room.fake);
		if contains(room.things,game.player) then
			room.things.removeElement(game.player);
		end
	end
	room.restorePlayer = function()
		room.things.push(game.player);
		local fake = room.things.removeElement(room.fake);
		if fake then 
			game.player.x = fake.x;
			game.player.y = fake.y;
			game.player.z = fake.z;
		else
			game.player.x = 339;
			game.player.y = 337;
			game.player.z = 1;
		end
	end
	room.getCollisions = function(collider)
		local collisions = Array();
		if not collider then return collisions; end
		for i = 1, #(room.colliders) do
			local collided = room.colliders[i].collider.collidesWith(collider);
			if collided then 
				collisions.push({collider = room.colliders[i].collider,zone= room.colliders[i].collider.collisionZone(collider)});
			end
		end
		return collisions;
	end
	room.registerThing = function(thing,name,hud)
		if hud then
			room.HUDthings.push(thing);	
		else
			room.things.push(thing);
		end
		room.thingLookup[name] = thing;
		if thing.collider then
			room.colliders.push(thing);
		end
	end
	room.eliminateThingByName = function(name,hud)
		local thing = room.thingLookup[name];
		if not thing then return; end
		if thing.collider then
			room.colliders.removeElement(thing);
		end
		room.thingLookup[name] = nil;
		if hud then
			room.HUDthings.removeElement(thing);
		else
			room.things.removeElement(thing);
		end
	end
	
	room.convertBackToData = function()
		local freezeData = {};
		freezeData.tileset = room.data.tileset;
		freezeData.tilesetW = room.data.tilesetW;
		freezeData.tilesetH = room.data.tilesetH;
		freezeData.tiles = room.data.tiles;
		freezeData.collisions = room.data.collisions;
		freezeData.things = {};
		local indexOffset = 0;
		for i=1,#(room.things),1 do
			local thing = room.things[i];
			if thing.name then
				local freezeThing = {};
				freezeThing.name = thing.name;
				freezeThing.filepath = thing.filepath;
				freezeThing.thingType = thing.thingType;
				freezeThing.x = thing.x;
				freezeThing.y = thing.y;
				freezeThing.z = thing.z;
				--collision
				if thing.collider then
					freezeThing.collides = true;
					freezeThing.cwidth = thing.collider.width;
					freezeThing.cheight = thing.collider.height;
					freezeThing.cXoffset = thing.collider.savedXoffset;
					freezeThing.cYoffset = thing.collider.savedYoffset;
				end
				--action
				if thing.actionCollider then
					freezeThing.action = thing.atype;
					freezeThing.awidth = thing.actionCollider.width;
					freezeThing.aheight = thing.actionCollider.height;
					freezeThing.aXoffset = thing.actionCollider.savedXoffset;
					freezeThing.aYoffset = thing.actionCollider.savedYoffset;
					freezeThing.useColliderInsteadOfSprite = thing.useColliderInsteadOfSprite;
					if thing.actionConvo then
						freezeThing.convoId = thing.actionConvo.convoId;
					end
				end
				--add it
				freezeData.things[i + indexOffset] = freezeThing;
			else
				indexOffset = indexOffset - 1;
			end
		end
		return freezeData;
	end
	room.wrapDark = function()
		room.wrap = {xmin=43,ymin=63,xmax=700,ymax=607};
	end
	
	return room;
end