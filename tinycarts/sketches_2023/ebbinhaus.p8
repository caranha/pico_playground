pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
circs={}
for i = 1,30 do
	add(circs,{rnd(220),rnd(128),5+rnd(10)})
end

function _draw()
	cls(6)

	camera(60+cos(t()/8)*30,0)
	
	for i in all(circs) do
		circfill(i[1],i[2],i[3],7)
	end

	camera(60+cos(t()/8)*60,0)
		
	circfill(64,64,10,9)	
	s = 4
	for i=1,8 do
		d = i/8
		x = 64+cos(d)*(10+s*2)
		y = 64+sin(d)*(10+s*2)
		circfill(x,y,s,13)
	end

	s = 20	
	circfill(164,64,10,9)	
	for i=1,6 do
		d = i/6
		x = 164+cos(d)*(10+s*2)
		y = 64+sin(d)*(10+s*2)
		circfill(x,y,s+3,13)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
