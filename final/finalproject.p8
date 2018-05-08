pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
x = 64
y = 64

z = 1

time_t = 0

cellwidth = 8

p1 = {
    x = 6 * cellwidth,
    y = 7 * cellwidth,
    hasbat = false,
    damage = 0,
    health = 10,
    sprindex = 4,
    width = 1,
    height = 2,
    speed = 1
}


function dealdamage(dam)

end


function wait() 
	p1.sprindex = 4
	p1.width = 1
	a = 0
end

function p1:moveleft()
 if p1:nothingleft() then
  self.x = self.x - p1.speed
 end
end

function p1:moveright()
 if p1:nothingright() then
  self.x = self.x + p1.speed
 end
end

function p1:moveup()
 if p1:nothingabove() then
  self.y = self.y - p1.speed
 end
end

function p1:movedown()
 if p1:nothingbelow() then
  self.y = self.y + p1.speed
 end
end

function p1:nothingleft()
 if self.x % 8 != 0 then
  return true
 else
  sprindexheadlevel = mget((self.x / 8) - 1, self.y / 8)
   oneortwoblocksbelow = 1
  if self.y %8 != 0 then -- if the upperbody is not completely on one and onely one cell
   oneortwoblocksbelow = 2 -- go one cell lower to account for a partially filled cell
  end
  sprindexfeetlevel = mget((self.x / 8) - 1, (self.y / 8) + oneortwoblocksbelow)
  clearheadlevel = not fget(sprindexheadlevel, 0) -- head and feet occupy two different cells
  clearfeetlevel = not fget(sprindexfeetlevel, 0) -- check for both
  return clearheadlevel and clearfeetlevel
 end
end

function p1:nothingright()
 if self.x % 8 != 0 then
  return true
 else
  sprindexheadlevel = mget((self.x / 8) + 1, self.y / 8)
  oneortwoblocksbelow = 1
  if self.y %8 != 0 then -- if the upperbody is not completely on one and onely one cell
   oneortwoblocksbelow = 2 -- go one cell lower to account for a partially filled cell
  end
  sprindexfeetlevel = mget((self.x / 8) + 1, (self.y / 8) + oneortwoblocksbelow)
  clearheadlevel = not fget(sprindexheadlevel, 0) -- head and feet occupy two different cells
  clearfeetlevel = not fget(sprindexfeetlevel, 0) -- check for both
  return clearheadlevel and clearfeetlevel
 end
end

function p1:nothingabove()
 if self.y % 8 != 0 then
  return true
 else
  sprindex = mget(self.x / 8, (self.y / 8) - 1)
  return not fget(sprindex, 0)
 end
end

function p1:nothingbelow()
 if self.y % 8 != 0 then
  return true
 else
  sprindex = mget(self.x / 8, (self.y / 8) + 2)
  return not fget(sprindex, 0)
 end
end

function _update()
	wait()
 if (btn(0)) then p1:moveleft() end
 if (btn(1)) then p1:moveright() end
 if (btn(2)) then p1:moveup() end
 if (btn(3)) then p1:movedown() end
 if (btn(4)) then 
 	p1.sprindex = 5
 	p1.width = 2
 end
end



function _draw()
 map(0,0,0,0,16,16)
-- map(0,0,0,64,16,8)
 spr(p1.sprindex, p1.x, p1.y, p1.width, p1.height)
end














__gfx__
00000000444444440050000000000000444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044444444058555555eeeee00444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000fcffcf055555555500000000fcffcf00fcffcf000000aa0000000000000000000000000000000000000000000000000000000000000000000000000
000770000ffffff00005555500000000affffff00ffffff00000aaa0000000000000000000000000000000000000000000000000000000000000000000000000
00077000000ff0000005000500000000a00ff000000ff000000aaa00000000000000000000000000000000000000000000000000000000000000000000000000
00700700003333000000000000000000a03333000033330000aaa000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033333300000000000000000a03333000033333000aa0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000300330030000000000000000a0333300003333333f000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000300330030000000000000000a033300000033333f0000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000550000000000000000000f33330000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000000000000000000550000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000000000000000000110000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000000000000000000110000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000110000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444445555555544444444eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3131313131313131313131313131313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3132323232323232323232323232323100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313131313131313131313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434343434343434343434343434343434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0034343434000000000000000000000034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
