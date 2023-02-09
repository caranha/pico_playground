pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
x,y=64,64
cx,cy=0,0
mc=0
circs = {}

function addcirc()
	local c = {
		x = rnd(208)+(x-104),
		y = rnd(208)+(y-104),
		s = rnd(10)+5,
		c = rnd(8)+7,
	}
	add(circs,c)
end

function _init()
	for i=1,60 do
		addcirc()
	end
end

function _update()
	local m = false
	if (btn(⬅️)) x-=1m=true
	if (btn(➡️)) x+=1m=true
	if (btn(⬆️)) y-=1m=true
	if (btn(⬇️)) y+=1m=true
	if(m) mc = (mc+1)%8
	while (#circs > 100) del(circs,circs[1])
	for i=1,5 do
		addcirc()
	end
	for c in all(circs) do
		c.s+=0.1
	end
end

function _draw()
	cls(3)
	
	if (x-50 < cx) cx = x-50
	if (x > cx+80) cx = x-80
	if (y-50 < cy) cy = y-50
	if (y > cy+80) cy = y-80
	
	camera(cx,cy)
	for i=#circs,1,-1 do
		local c = circs[i]
		circfill(c.x,c.y,c.s,c.c)
	end

	for hx = x-104,x+104,16 do
	 for hy = y-104,y+104,16 do
	 	local hhx = hx - hx%16
	 	local hhy = hy - hy%16
	 	if (2*hhx%3+hhy%7)%5==0 then
		 	?"웃",hhx,hhy+sin(t()*4+hy/100+hx/100)*1.5,2
		 end
	 end
	end

	local r1 = 30
	clip(x-cx-r1,y-cy-r1,r1*2,r1*2)	
	rectfill(x-r1,y-r1,x+r1,y+r1,4)
	for i=#circs,1,-1 do
		local c = circs[i]
		circfill(c.x,c.y,c.s,c.c%2+5)
	end
	
	for hx = x-104,x+104,16 do
	 for hy = y-104,y+104,16 do
	 	local hhx = hx - hx%16
	 	local hhy = hy - hy%16
	 	if (2*hhx%3+hhy%7)%5==0 then
		 	?"웃",hhx,hhy+sin(t()*4+hy/100+hx/100)*1.5,7
		 end
	 end
	end
	
	local r2 = 15
	clip(x-cx-r2,y-cy-r2,r2*2,r2*2)	
	rectfill(x-r2,y-r2,x+r2,y+r2,0)
	for i=#circs,1,-1 do
		local c = circs[i]
		circ(c.x,c.y,c.s,1)
	end
	?"웃",x-4,y-4+sin(mc/8),6
	clip()

end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
