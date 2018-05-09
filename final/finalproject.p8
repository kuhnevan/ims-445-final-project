pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
x = 64
y = 64
level = 0
mapwidth = 16
mapheight = 16
z = 1

time_t = 0

cellwidth = 8

-- initializes the player
p1 = {
    x = 6 * cellwidth,
    y = 4 * cellwidth,
    hasbat = false,
    damage = 0,
    health = 10,
    sprindex = 11,
    width = 2,
    height = 2,
    speed = 1,
    is_flipped = false
}

-- hallway 1 enemies ---------------------------------------------
spider = {
    x = 24 * cellwidth,
    y = 4 * cellwidth,
    health = 5,
    sprindex = 5,
    width = 2,
    height = 2,
    speed = .5,
    is_flipped = false
}

-- initializes the dog
dog = {
    x = 2 * cellwidth,
    y = 4 * cellwidth,
    health = 1000,
    sprindex = 7,
    width = 2,
    height = 2,
    speed = 1,
    is_flipped = false
}

actors = {p1, dog}




-- when the player has hit an enemy, this function subtracts from that character's health
function dealdamage(dam)

end

--
function attackanim() 
	p1.sprindex = 13
	_draw()
    for i = 1,10 do flip() end
    p1.sprindex = 43
    _draw()
    for i = 1, 10 do flip() end
    p1.sprindex = 11
    _draw()
end

function moveleft(actor)
 if nothingleft(actor) then
  actor.x = actor.x - actor.speed
 end
 actor.is_flipped = true
end

function moveright(actor)
 if nothingright(actor) then
  actor.x = actor.x + actor.speed
 end
 actor.is_flipped = false
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

function nothingabove(actor)
 if actor.y % 8 != 0 then
  return true
 else
  sprindex = mget(actor.x / 8, (actor.y / 8) - 1)
  return not fget(sprindex, 0)
 end
end

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
     spr(actor.sprindex, actor.x, actor.y, actor.width, actor.height, actor.is_flipped)
    end
end

function movecam()
    camera(level * 128, 0)
    map(0,0,0,0,128,16)
end 

function checkloc()
 if (fget(mget(p1.x/8, p1.y /8) + 2, 3)) level+=1
end


function _update()
 checkloc()
 if (btn(0)) then moveleft(p1) end
 if (btn(1)) then moveright(p1) end
 if (btn(2)) then moveup(p1) end
 if (btn(3)) then movedown(p1) end
 if (btnp(4)) then 
    if (level <= 5) then level+=1
    else level = 0 end
 	if (p1.sprindex == 11) then	attackanim() end
 end
 moveright(dog)
end



function _draw()
 movecam() 
 drawactors()
end














__gfx__
000000004444444400500000000000004444444400000000000000000000999009990000000000eeee000000000000eeee000000000000eeee00a00000000000
0000000044444444058555555eeee00044444444000000000000000000009e9009e9000000000eeeeee0000000000eeeeee0000000000eeeeee00a0000000000
007007000f0ff0f0555555555000ee000f0ff0f00000000000000000000000999900000000000eeeeee0000000000eeeeee0000000000eeeeee000f000000000
000770000ffffff00005555500000ee0affffff000000000000000000000009c9c00000000000efcfc00000000000efcfc00000000000efcfc00020000000000
00077000000ff0000005000500000000a00ff00000000000000000000000099999900000000000ffff000000000000ffff000000000000ffff00200000000000
00700700003333000000000000000000a0333300000000000000000000000999599000000000000ff00000000000000ff00000000000000ff002000000000000
00000000033333300000000000000000a03333000000000000000000000000099000000000000226622000000000022662200000000002266220000000000000
00000000300330030000000000000000a03333000000000000000000009900099000000000000226622000000000022662200000000002266200000000000000
00000000300330030000000000000000a03330000000000000000000000900999900000000000226622000000000022662200000000002266200000000000000
00000000000550000000000000000000f33330000000005555000000000999999900000000000222622000000000022262200000000002226200000000000000
00000000000110000000000000000000000550000000055555500000000099999900000000000f2222f0000000000f2222faaaaa00000f222200000000000000
00000000000110000000000000000000000110000000085558500000000099999900000000000022220000000000002222000000000000222200000000000000
00000000000110000000000000000000000110000055558585555500000090900900000000000022220000000000002222000000000000222200000000000000
00000000000000000000000000000000000110000550055555500550000090900900000000000022220000000000002222000000000000222200000000000000
00000000000000000000000000000000000000005500550000550055000000000000000000000022220000000000002222000000000000222200000000000000
000000000000000000000000000000000000000050005000000500050000000000000000000000ff0ff00000000000ff0ff00000000000ff0ff0000000000000
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
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488858885888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488555555588440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488858885888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488555555588440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488858885888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488555555588440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44488888888888440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
