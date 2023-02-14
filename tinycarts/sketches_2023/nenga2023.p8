pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _draw()
⧗=t()
cls(12)

	-- sky/sun
	cx,cy=20,70
	circfill(cx,cy,10,10)
	for x=-20,108,2 do
		for y=-70,0,2 do
			a=atan2(y,x)+⧗/6
			if (a%0.1<0.02) pset(x+cx, y+cy, 10)
		end
	end

	-- green field
	rectfill(0,69,128,128,11)
	c={3,14,8}
	for i=1,20 do
		x = (i*23)%128
		y = (i*34)%60+68
		circ(x,y,1,c[i%3+1])
	end

	-- rabbits
	for i=0,2 do
		x=20+i*40
		y=95+(-i)%3*10
		ovalfill(x-15,y-6,x+15,y+6,0)
		line(x-5,y+6,x+5,y+6,11)
		clip(0,0,128,y+6)
		y+= 10+sin(⧗+i/5)*20
		circfill(x,y,8,7)
		ovalfill(x-7,y-15,x-2,y,7)
		ovalfill(x+2,y-15,x+7,y,7)
		?"●●",x-8,y,8
		clip()
	end

	-- mountains
	for j=0,4 do	
		x=60+j*15
		y=45-sin(0.2+j/8)*5
		for i=0,25+sin(0.2+j/8)*5 do
			c = y+i < 58-j*3 and 7 or 5
			line(x-i*1.3/(2+j%2),y+i,x+i*1.6/(2+j%2),y+i,c)
		end
	end
	
	-- letters
	♥ = "happy   new   year!"
	for i=1,#♥ do
		x=(168-(⧗*60)%460) + 10*i
		y=20+sin(x/64)*10
		?"\^w\^t"..♥[i],x+1,y+1,0
		?"\^w\^t"..♥[i],x,y,8
	end


end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000