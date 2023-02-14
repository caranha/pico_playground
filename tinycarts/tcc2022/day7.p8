pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
h="♥happy♥2023"
c=circfill
o=ovalfill
s=sin
pal({0,5,1,6,7})

function _draw()
	⧗=t()
	cls()
	
	for x=0,128,2 do
	for y=0,128,2 do
		j= s((x+sin(⧗/10)*40)/70) + s((y+⧗*40)/100)
		pset(x,y,(j+⧗)%4)
	end
	end

	for i=1,#h do
		r=58+s(⧗)*3
		x=64-cos(i/#h-⧗/6)*r
		y=64+s(i/#h-⧗/6)*r
		?h[i],x,y,8+(⧗*9+i)%3
	end
	for i=0,3 do
		x=64+cos(i/4-⧗/3)*30
		y=64+s(i/4-⧗/3)*30+s(⧗*2+i/4)*5
		c(x,y,8,7)
		o(x-7,y-15,x-2,y,7)
		o(x+2,y-15,x+7,y,7)
		c(x-4,y+2,2,8)
		c(x+4,y+2,2,8)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000