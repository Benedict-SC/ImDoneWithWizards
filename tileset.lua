TILESET_SIZE = 32;
SOLID_COLLIDER_CODE = 1;
Tileset = function (filename,wp,hp,colls)
	tileset = {};
	tileset.w = wp;
	tileset.h = hp;
	tileset.colls = colls;
	tileset.sheet = love.graphics.newImage("images/tilesets/" .. filename);
	tileset.drawTile = function(code,drawx,drawy)
		if not code or code == 0 then return; end -- null tiles
		code = code - 1;
		local cx = math.floor(code%tileset.w);
		local cy = math.floor(code/tileset.w);
		local quad = love.graphics.newQuad(cx*TILESET_SIZE,cy*TILESET_SIZE,TILESET_SIZE,TILESET_SIZE,tileset.sheet:getWidth(),tileset.sheet:getHeight());
		love.graphics.draw(tileset.sheet,quad,drawx,drawy);
	end
	tileset.floorColliders = function()
		floorcolls = Array();
		for i = 1, #(tileset.colls), 1 do
			for j = 1, #(tileset.colls[i]), 1 do --grow rectangle out in each direction one step at a time
				local checkThisCell = tileset.colls[i][j] == SOLID_COLLIDER_CODE;
				if checkThisCell then
					local smallrect = Rect(j,i,1,1);
					tileset.colls[i][j] = -1; --mark self
					local dir = 1;
					local dirsDone = {false,false,false,false};
					--local times = 0;
					while not dirsDone[1] or not dirsDone[2] or not dirsDone[3] or not dirsDone[4] do
						--[[if times > 300 then 
							local origs = "\noriginal x/y: "..j.."/"..i;
							local stats = "uh oh, infinite loop"..origs.."\nx: " .. smallrect.x .. "\ny: " .. smallrect.y .. "\nw: " .. smallrect.w .. "\nh: " .. smallrect.h .. "\ndirs: " .. (dirsDone[1] and 1 or 0) .."/".. (dirsDone[2] and 1 or 0) .."/".. (dirsDone[3] and 1 or 0) .."/".. (dirsDone[4] and 1 or 0);
							local map = "";
							for ii = 1, #(tileset.colls), 1 do
								map = map.."[";
								for jj = 1, #(tileset.colls[i]), 1 do
									local ccode = tileset.colls[ii][jj];
									map = map..(ccode >= 0 and " " or "")..ccode..", ";
								end
								map = map.."]\n";
							end
							error(stats.."\n"..map);
						end
						times = times + 1;--]]
						local checkThisDir = not dirsDone[dir]; --skip directions we've already run into obstacles in
						
						if checkThisDir then
							local allSolid = true;
							if dir == 1 then --look right
								local xpos = smallrect.x + smallrect.w;
								for ypos = smallrect.y, smallrect.y + smallrect.h - 1, 1 do
									local row = tileset.colls[ypos];
									if not row then 
										dirsDone[dir] = true;
										allSolid = false;
										break; 
									end
									local cell = row[xpos];
									if not (cell == SOLID_COLLIDER_CODE) then
										dirsDone[dir] = true;
										allSolid = false;
										break;
									end
								end
								if allSolid then
									for ypos = smallrect.y, smallrect.y + smallrect.h - 1, 1 do --mark all the cells
										tileset.colls[ypos][xpos] = -1; --negative one is marked cell
									end
									smallrect.w = smallrect.w + 1;
								end
							elseif dir == 2 then --look down
								local ypos = smallrect.y + smallrect.h;
								for xpos = smallrect.x, smallrect.x + smallrect.w - 1, 1 do
									local row = tileset.colls[ypos];
									if not row then 
										dirsDone[dir] = true;
										allSolid = false;
										break; 
									end
									local cell = row[xpos];
									if not (cell == SOLID_COLLIDER_CODE) then
										dirsDone[dir] = true;
										allSolid = false;
										break;
									end
								end
								if allSolid then
									for xpos = smallrect.x, smallrect.x + smallrect.w - 1, 1 do --mark all the cells
										tileset.colls[ypos][xpos] = -1; --negative one is marked cell
									end
									smallrect.h = smallrect.h + 1;
								end
							elseif dir == 3 then --look left
								local xpos = smallrect.x - 1;
								for ypos = smallrect.y, smallrect.y + smallrect.h - 1, 1 do
									local row = tileset.colls[ypos];
									if not row then 
										dirsDone[dir] = true;
										allSolid = false;
										break; 
									end
									local cell = row[xpos];
									if not (cell == SOLID_COLLIDER_CODE) then
										dirsDone[dir] = true;
										allSolid = false;
										break;
									end
								end
								if allSolid then
									for ypos = smallrect.y, smallrect.y + smallrect.h - 1, 1 do --mark all the cells
										tileset.colls[ypos][xpos] = -1; --negative one is marked cell
									end
									smallrect.x = smallrect.x - 1;
									smallrect.w = smallrect.w + 1;
								end
							elseif dir == 4 then --look up
								local ypos = smallrect.y - 1;
								for xpos = smallrect.x, smallrect.x + smallrect.w - 1, 1 do
									local row = tileset.colls[ypos];
									if not row then 
										dirsDone[dir] = true;
										allSolid = false;
										break; 
									end
									local cell = row[xpos];
									if not (cell == SOLID_COLLIDER_CODE) then
										dirsDone[dir] = true;
										allSolid = false;
										break;
									end
								end
								if allSolid then
									for xpos = smallrect.x, smallrect.x + smallrect.w - 1, 1 do --mark all the cells
										tileset.colls[ypos][xpos] = -1; --negative one is marked cell
									end
									smallrect.y = smallrect.y - 1;
									smallrect.h = smallrect.h + 1;
								end
							else
								error("no other directions exist");
							end
						end
						dir = (dir%4) + 1; --move to next direction
					end
					--we have a rect defining a region now- let's turn it into an actual thing
					local collider = Thing((smallrect.x-1) * TILESET_SIZE,(smallrect.y-1)*TILESET_SIZE,0.1);
					collision.giveExplicitCollider(collider,0,0,smallrect.w*TILESET_SIZE,smallrect.h*TILESET_SIZE);
					floorcolls.push(collider);
				end
			end
		end	
		return floorcolls;
	end
	return tileset;
end