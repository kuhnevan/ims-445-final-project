pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
sfx(2)
-- global variables
mode = 0

level = 0
mapwidth = 16
mapheight = 16
z = 1

time_t = 0

cellwidth = 8

player = 0
dogtype = 1
spidertype = 2
rattype = 3
-----------------------------------------------

-- the starting position of the player for each level
roomstart = {}
roomstart["x"] = 1 * cellwidth
roomstart["y"] = 2 * cellwidth

level1start = {}
level1start["x"] = 24 * cellwidth
level1start["y"] = 0 * cellwidth

level2start = {}
level2start["x"] = 32 * cellwidth
level2start["y"] = 6 * cellwidth

level3start = {}
level3start["x"] = 48 * cellwidth
level3start["y"] = 9 * cellwidth

level4start = {}
level4start["x"] = 65 * cellwidth
level4start["y"] = 11 * cellwidth

level5start = {}
level5start["x"] = 95 * cellwidth
level5start["y"] = 9 * cellwidth

level6start = {}
level6start["x"] = 102 * cellwidth
level6start["y"] = 14 * cellwidth

levelstarts = {roomstart, level1start, level2start, level3start, level4start, level5start,
                level6start}
-----------------------------------------------
-- actor initializations

-- initializes the player
p1 = {
    x = roomstart.x,
    y = roomstart.y,
    isalive = true,
    hasbat = false,
    health = 10,
    sprindex = 9,
    width = 2,
    height = 2,
    speed = 1,
    is_flipped = false, -- false = facing right; true = facing left
    isenemy = false,
    level = 100, -- just a placeholder to prevent a nil value - p1.level won't ever be compared 
    speechbubble = "",
    gotmilk = false
}

-- hallway 1 enemies ---------------------------------------------
spider1 = {
    x = 24 * cellwidth,
    y = 4 * cellwidth,
    isalive = true,
    health = 3,
    sprindex = 5,
    width = 2,
    height = 2,
    speed = .3,
    is_flipped = false,
    level = 1, -- the level that the enemy appears in
    isenemy = true
}

-- initializes the dog
dog = {
    x = 2 * cellwidth,
    y = 4 * cellwidth,
    isalive = true,
    health = 1000,
    sprindex = 7,
    width = 2,
    height = 2,
    speed = 1,
    is_flipped = false,
    isenemy = false,
    level = 0, -- just a placeholder to prevent a nil value - dog.level won't ever be compared
    speechbubble = ""
}

rat1 = {
    x = 45 * cellwidth,
    y = 6 * cellwidth,
    isalive = true,
    health = 1,
    sprindex = 2,
    width = 2,
    height = 1,
    speed = 1,
    is_flipped = false,
    level = 2, -- the level that the enemy appears in
    isenemy = true
}

actors = {p1, dog, spider1, rat1}
-----------------------------------------------
-- functions

function attack()
 dealdamage()
 attackanim()
end

-- when the player has hit an enemy, this function subtracts from that character's health
function dealdamage()
 for actor in all(actors) do
  if actor.isenemy and actor.level == level then
   if abs(p1.x - actor.x) < 7 and abs(p1.y - actor.y) < 10 then
    actor.health -= 1
   end
   if actor.health <= 0 then
    actor.isalive = false
   end
  end
 end
end

--
function attackanim() 
	p1.sprindex = 13
	_draw()
    for i = 1,3 do flip() end
    p1.sprindex = 43
    _draw()
    for i = 1,3 do flip() end
    p1.sprindex = 11
    _draw()
end

function interact()
 if abs(p1.x - dog.x) < 10 and abs(p1.y - dog.y) < 10 then
  dogtalk()
 elseif abs(p1.x - 10) < 10 and abs(p1.y - 10) < 10 then
  if p1.gotmilk then
   mode = 3
  else
   p1.sprindex = 11
  end
 elseif abs(p1.x - (74 * cellwidth)) < 10 and abs(p1.y - (2 * cellwidth)) < 10 then -- if p1 gets milk
  p1talk()
  p1.speed += 1 -- that milk gave him strength
  p1.gotmilk = true
 end
end

function dogtalk()
 notext = ""
 text1 = "hey, it's dangerous out there."
 text2 = "you won't last long like that."
 text3 = "try checking under the bed"
 text4 = "you might find something useful."
 if dog.speechbubble == notext then
  dog.speechbubble = text1
 elseif dog.speechbubble == text1 then
  dog.speechbubble = text2
 elseif dog.speechbubble == text2 then
  dog.speechbubble = text3
 elseif dog.speechbubble == text3 then
  dog.speechbubble = text4
 else
  dog.speechbubble = ""
 end
end

function p1talk()
 notext = ""
 text1 = "the milk!"
 text2 = "*gulp gulp gulp*"
 text3 = "i feel...stronger"
 text4 = "well, i better\nget back to bed"
 if p1.speechbubble == notext then
  p1.speechbubble = text1
 elseif p1.speechbubble == text1 then
  p1.speechbubble = text2
 elseif p1.speechbubble == text2 then
  p1.speechbubble = text3
 elseif p1.speechbubble == text3 then
  p1.speechbubble = text4
 else
  p1.speechbubble = notext
 end
end

function checkifalive()
 if p1.health <= 0 then
  playerdies()
 end
end

function playerdies()
 p1.sprindex = 74
end

function checkenemycollsion(actor)
  xdiff = p1.x - actor.x
  ydiff = p1.y - actor.y
  if abs(xdiff) < 5 and abs(ydiff) < 10 then
   p1.health -= 1
   if abs(xdiff) < abs(ydiff) then -- attack from left or right
    if xdiff > 0 then -- attack from left
     moveright(p1)
    else -- attack from right
     moveleft(p1)
    end
   else -- attack from above or below
    if ydiff > 0 then -- attack from above
     movedown(p1)
    else -- attack from below
     moveup(p1)
    end
   end
   checkifalive()
  end
end

function move_enemy()
 for actor in all(actors) do
  if actor.isenemy and actor.level == level and actor.isalive then
   if actor.x - p1.x > 0 then
    moveleft(actor)
   else
    moveright(actor)
   end
   if actor.y - p1.y > 0 then
    moveup(actor)
   else
    movedown(actor)
   end
   checkenemycollsion(actor)
  end
 end
end

function moveleft(actor)
 if nothingleft(actor) then
  actor.x = actor.x - actor.speed
 end
 if actor.isenemy then
  actor.is_flipped = false
 else
  actor.is_flipped = true
 end
end

function moveright(actor)
 if nothingright(actor) then
  actor.x = actor.x + actor.speed
 end
 if actor.isenemy then
  actor.is_flipped = true
 else
  actor.is_flipped = false
 end
end

function moveup(actor)
 if nothingabove(actor) then
  actor.y = actor.y - actor.speed
 end
end

function movedown(actor)
 if nothingbelow(actor) then
  actor.y = actor.y + p1.speed
 end
end

-- check for objects left of the actor
-- returns true if no immediate object
function nothingleft(actor)
 if actor.x % 8 != 0 then
  return true
 else
  sprindexheadlevel = mget((actor.x / 8) - 1, actor.y / 8)
   oneortwoblocksbelow = 1
  if actor.y %8 != 0 then -- if the upperbody is not completely on one and onely one cell
   oneortwoblocksbelow = 2 -- go one cell lower to account for a partially filled cell
  end
  sprindexfeetlevel = mget((actor.x / 8) - 1, (actor.y / 8) + oneortwoblocksbelow)
  clearheadlevel = not fget(sprindexheadlevel, 0) -- head and feet occupy two different cells
  clearfeetlevel = not fget(sprindexfeetlevel, 0) -- check for both
  return clearheadlevel and clearfeetlevel
 end
end

-- check for objects right of the actor
-- returns true if no immediate object
function nothingright(actor)
 if actor.x % 8 != 0 then
  return true
 else
  sprindexheadlevel = mget((actor.x / 8) + 2, actor.y / 8)
  oneortwoblocksbelow = 1
  if actor.y %8 != 0 then -- if the upperbody is not completely on one and onely one cell
   oneortwoblocksbelow = 2 -- go one cell lower to account for a partially filled cell
  end
  sprindexfeetlevel = mget((actor.x / 8) + 1, (actor.y / 8) + oneortwoblocksbelow)
  clearheadlevel = not fget(sprindexheadlevel, 0) -- head and feet occupy two different cells
  clearfeetlevel = not fget(sprindexfeetlevel, 0) -- check for both
  return clearheadlevel and clearfeetlevel
 end
end

-- check for objects above the actor
-- returns true if no immediate object
function nothingabove(actor)
 if actor.y % 8 != 0 then
  return true
 else
  sprindex = mget(actor.x / 8, (actor.y / 8) - 1)
  return not fget(sprindex, 0)
 end
end

-- check for objects below the actor
-- returns true if no immediate object
function nothingbelow(actor)
 if actor.y % 8 != 0 then
  return true
 else
  sprindex = mget(actor.x / 8, (actor.y / 8) + 2)
  return not fget(sprindex, 0)
 end
end

function drawactors()
    for actor in all(actors) do
     if actor.isalive then
      spr(actor.sprindex, actor.x, actor.y, actor.width, actor.height, actor.is_flipped)
     end
    end
end

function movecam()
    camera(level * 128, 0)
    map(0,0,0,0,128,16)
end 

------------------------------------- deprecated
function checkloc()
 if (fget(mget(p1.x/8, p1.y /8) + 2, 3)) level+=1
end
----------------------------------------------------

function changearea() -- changes the area when the player steps on the pink mat
 sprindexfeetlevel = mget(p1.x / 8, (p1.y / 8) + 1)
 if sprindexfeetlevel == 51 then
  if level < 6 then
   level += 1
  else
   level = 0 -- level zero is the bedroom
  end
  p1.x = levelstarts[level + 1].x -- +1 offset because lua starts indexes at 1
  p1.y = levelstarts[level + 1].y -- +1 offset because lua starts indexes at 1
 end
end

function titleupdate()
 if (btnp(4)) then
  mode = 1
 end
end

function gameupdate()
 if (btn(0)) then moveleft(p1) end
 if (btn(1)) then moveright(p1) end
 if (btn(2)) then moveup(p1) end
 if (btn(3)) then movedown(p1) end
 if (btnp(4)) then 
  if (p1.sprindex == 11) then attack() end
 end
 if (btnp(5)) then interact() end
 changearea()
 move_enemy()
end

function _update()
 if mode == 0 then
  titleupdate()
 elseif mode == 1 then
  gameupdate()
 end
end

function titledraw()
 map(0, 56, 20, 0, 8, 8)
end

function gamedraw()
 movecam() 
 drawactors()
 print(dog.speechbubble, 0, 80)
 print(p1.speechbubble, p1.x - 50, 40)
end

function _draw()
 if mode == 0 then
  titledraw()
 else
  gamedraw()
 end
end














__gfx__
000000004444444400500000000000004444444400000055550000000000999009990000000000eeee000000000000eeee000000000000eeee00a00000000000
0000000044444444058555555eeee00044444444000005555550000000009e9009e9000000000eeeeee0000000000eeeeee0000000000eeeeee00a0000000000
007007000f0ff0f0555555555000ee000f0ff0f00000085558500000000000999900000000000eeeeee0000000000eeeeee0000000000eeeeee000f000000000
000770000ffffff00005555500000ee0affffff000555585855555000000009c9c00000000000efcfc00000000000efcfc00000000000efcfc00020000000000
00077000000ff0000005000500000000a00ff00005500555555005500000099999900000000000ffff000000000000ffff000000000000ffff00200000000000
00700700003333000000000000000000a0333300550055000055005500000999599000000000000ff00000000000000ff00000000000000ff002000000000000
00000000033333300000000000000000a03333005000500000050005000000099000000000000226622000000000022662200000000002266220000000000000
00000000300330030000000000000000a03333000000000000000000009900099000000000000226622000000000022662200000000002266200000000000000
00000000300330030000000000000000a03330000000000000000000000900999900000000000226622000000000022662200000000002266200000000000000
00000000000550000000000000000000f33330000000000000000000000999999900000000000222622000000000022262200000000002226200000000000000
00000000000110000000000000000000000550000000000000000000000099999900000000000f2222f0000000000f2222faaaaa00000f222200000000000000
00000000000110000000000000000000000110000000000000000000000099999900000000000022220000000000002222000000000000222200000000000000
00000000000110000000000000000000000110000000000000000000000090900900000000000022220000000000002222000000000000222200000000000000
00000000000000000000000000000000000110000000000000000000000090900900000000000022220000000000002222000000000000222200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000022220000000000002222000000000000222200000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000ff0ff00000000000ff0ff00000000000ff0ff0000000000000
0000000000000000000000000000000000000000444444444444444444444444444444444444477744444444000000eeee000000444444444444444400000000
000000000000000000000000000000000000000044444444444444444444444444444444444477777744444400000eeeeee00000444444444444444400000000
000000000000000000000000000000000000000044444444444444444444444444444444444677777664444400000eeeeee00000444444444444444400000000
000000000000000000000000000000000000000044444444444444444444444444444444444767766774444400000efcfc000000444444444444444400000000
0000000000000000000000000000000000000000444444444444444444444444444444444447766777744444000000ffff000000444444444444444400000000
000000000000000000000000000000000000000044444444dd444444666888888888888444477677777444440000000ff0000000444444444444444400000000
00000000000000000000000000000000000000004444444ddd444444777888888888888844477677777444440000022662200000444455555554444400000000
0000000000000000000000000000000000000000444444dddd44444477788888888888884447767777744444000002266202000a444555555555444400000000
444444445555555544444444eeeeeeee11111111444444dddd4444447778888888888888444776767774444400000226620020a0444545555555444400000000
444444445555555544444444eeeeeeee11111111444444dddd444444777888888888888844477676777444440000022262000f00444545444545444400000000
444444445555555544444444eeeeeeee11111111444444ddddddd4447778888888888888444776767774444400000f2222000000444545444545444400000000
444444445555555544444444eeeeeeee11111111444444dddddd4444666888888888888844477676777444440000002222000000444545444545444400000000
444444445555555544444444eeeeeeee11111111444444ddddd44444454488888888888844477677777444440000002222000000444445444445444400000000
444444445555555544444444eeeeeeee111111114444444464444444454444444444445444477677777444440000002222000000444445444445444400000000
444444445555555544444444eeeeeeee111111114444446666644444444444444444445444447677744444440000002222000000444444444444444400000000
444444445555555544444444eeeeeeee11111111444446464646444444444444444444444444467444444444000000ff0ff00000444444444444444400000000
44444444444444445555555555555555555555555555555555555555555555555555555555555555000000eeee00000000000000000000000000000000000000
4444444444444444555555555555555555555555555555555555555555555555555555555555555500000eeeeee0000000000055550000000000000000000000
4448888888888844555555555555555555555555555555555555555555555555555555555555555500000eeeeee0000000000555555000000000000000000000
4448885888588844555555555555555555555555555555555555555555555555555555555555555500000e8c8c00000000000855585000000000000000000000
44488888888888445555555555555555555555555555555555555555555555555555555555555555000000888800000000555585855555000000000000000000
44488555555588445555555555555555555555555555555555555555555555555555555555555555000000088000000005500555555005500000000000000000
44488888888888445555555555555555555555555555555555555555555555555555555555555555000002266220000055005500005500550000000000000000
44488858885888445555555555555555555555555555555555555555555555555555555555555555000002266220000050005000000500050000000000000000
44488888888888445555555555555555555555555555555555555555555555555555555555555555000002266220000044444444444444440000000000000000
44488555555588445555555555555555555555555555555555555555555555555555555555555555000002226220000044444444444444440000005555000000
44488888888888445555555555555555555555555555555555555555555555555555555555555555000008222280000044444444444444440000055555500000
44488858885888445555555555555555555555555555555555555555555555555555555555555555000000222200000044444444444444440000085558500000
44488888888888445555555555555555555555555555555555555555555555555555555555555555000000222200000044444444444444440055558585555500
44488555555588445555555555555575555555555555555555555555555555555555555555555555000000222200000044444444dd4444440550055555500550
4448888888888844555555555555557555755555555555555555555555555555555555555555555500000022220000004444444ddd4444445500550000550055
444444444444444455555555555555755775555555555555555555555555555555557555555555550000008808800000444444dddd4444445000500000050005
00000000000000005555555555555575577555555555555575555555555555555555755555575555000000000000000000000000000000000000000000000000
00000000000000005555555555555575577555575555555575555555555555555555755555575555000000000000000000000000000000000000000000000000
00000000000000005555555555555775777555555555555575555555575555555555755555575555000000000000000000000000000000000000000000000000
00000000000000005555555555555775757555575555555575755555555557777555755555575555000000000000000000000000000000000000000000000000
00000000000000005555555555557777757555575555777775755555555557557755775555777775000000000000000000000000000000000000000000000000
00000000000000005555555555557577557555557555755575777775575557555755775555557555000000000000000000000000000000000000000000000000
00000000000000005555555555577577557555557557755575775575575557555755777755557555000000000000000000000000000000000000000000000000
00000000000000005555555555775555557755557557555775775575575557555775777775557555000000000000000000000000000000000000000000000000
00000000000000005555555555755555555755557557777755755575575557557775775575557555000000000000000000000000000000000000000000000000
00000000000000005555555557555555555775555555555555555555555555777775575577557555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555577555555555555555555555555555755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555557755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555557555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555575555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555575755555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555577755555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555755555555555555555555555555555775555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555755575555555555555555555555555777555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555755775555555555555755555555555757555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555755775555555555755755555555555755755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555755775555555555755755557555555755755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555557757775555575555755755577555555755575555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555557757575555555555755755575555555755775555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555577777575555775555755755775555555757755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555575775575555575555755777755555555757755555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555775775575555575555755757555555555755775555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557755555577555575555755757555555555755575575575777755000000000000000000000000000000000000000000000000
00000000000000005555555555557555555557555557555755755755555555755575575575775755000000000000000000000000000000000000000000000000
00000000000000005555555555575555555557755557555755755775555555755557575575775575000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555775555555755755577555555755557575575755575000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555557557775755575000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555775555555555555555555555555555555555577555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557755555555555555555555555555555555555557755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557555577755555555555555555555577777755555755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557555575575555577757775777555555555755555755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557555575575555575757555755555555577555555755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557555577775777577757775777555555755555555755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557555575555755575555575557555557555555555755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555557755575555755577757775777555557777775557755555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555775555555555555555555555555555555555577555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000
00000000000000005555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24344454647484940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25354555657585950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
26364656667686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
27374757677787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
28384858687888980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
29394959697989990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2a3a4a5a6a7a8a9a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b3b4b5b6b7b8b9b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000020000020001010000000000000000000000000000010100000000000000000000000001000100010000000000000001000400000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3131313131313131313131313131313131313131313131313434313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131333331313131313100000000000000000000000000000000
312728323232323232323232292a323131313131313132323232313131313131313131313131313131313131313131313132323232323232323232323232313131313131323232323232292a32323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
313738323232323232323232393a323131313131313132323232313131313131313131313131313131313131313131313132323232323232323232323232313131313131323232323232393a32323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
3132323232323232323232323232323131313131313132323232313131313131313131313131313131313131313131313132323232322526323232323232313131313131323232323232323232323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
313232323232323232323232323232313131313131312d2e3232313131313131313131313131313131313131313131313132323232323536323232323232313131313131323232323232323232323231313131313131313131313131313131313131313131312d2e323231313131313100000000000000000000000000000000
313232323232323232323232323232313131313131313d3e3232313131313131313131313131313131313131313131313132323225262d2e252632323232313131313131323232323232323232323231313131313131313131313131313131313131313131313d3e323231313131313100000000000000000000000000000000
312526322d2e3232404132323232323131313131313132323232313131313131343232323232322d2e323232323232313132323235363d3e353632323232313131313131323232323232323232323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
313536323d3e3232505132323232323131313131313132323232313131313131343232323232323d3e323232323232313132323232322526323232323232313131313131313131313132323232323231333232323232322d2e323232323232313131313131313232323231313131313100000000000000000000000000000000
3131313131313131313131313133333131313131313132323232313131313131313232323232323232323232323232313132323232323536323232323232313131313131313131313132323232323231333232323232323d3e323232323232313131313131313232323231313131313100000000000000000000000000000000
313131313131313131313131313131313131313131312d2e3232313131313131312d2e3232323232322d2e32323232333432323232323232323232323232313131313131313131313132323232323231312d2e3232323232322d2e32323232343131313131312d2e323231313131313100000000000000000000000000000000
313131313131313131313131313131313131313131313d3e3232313131313131313d3e3232323232323d3e32323232333432323232323232323232323232323333323232323232323232323232323231313d3e3232323232323d3e32323232343131313131313d3e323231313131313100000000000000000000000000000000
3131313131313131313131313131313131313131313132323232313131313131313131313131313131313131313131313132323232323232323232323232323333323232323232323232323232323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
3131313131313131313131313131313131313131313132323232313131313131313131313131313131313131313131313132323232323232323232323232323333323232323232323232323232323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
3131313131313131313131313131313131313131313132323232313131313131313131313131313131313131313131313132323232323232323232323232323333323232323232323232323232323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
3131313131313131313131313131313131313131313132323232313131313131313131313131313131313131313131313132323232323232323232323232323333323232323232323232323232323231313131313131313131313131313131313131313131313232323231313131313100000000000000000000000000000000
3131313131313131313131313131313131313131313133333131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313434313131313131313100000000000000000000000000000000
3131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313131313100000000000000000000000000000000
0034343434000000000000000000000034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0101041c10850000000000000000000002c05000000000002d0502f05032060320603405036060370503905039050330502c050280502805028050260503a0503b0503a050390500000000000000000000000000
01110000108501c8501c8500f85000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600140084315903179031890324e13189030ce130a903008430a903089030890324e130a9030ce130a903008430a9030a9030000324e13000030ce13000030084300003000030000324e13000030ce1300003
01100018200531b0002400000000220500000000000000002305000000000000000024050000000000000000280500000000000000001c0500000000000000001905000000000000000029050000000000000000
__music__
03 01024344

