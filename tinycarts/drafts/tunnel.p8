pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
adv = 0
front = {{0,0},{0,0},{0,0},{0,0}}
c1 = {{0,0},{0,0},{0,0},{0,0}}
c2 = {{0,0},{0,0},{0,0},{0,0}}
back = {{0,0},{128,0},{0,128},{128,128}}

function _update()
	adv += 1
	local o1, o2 = 64,64
	for i = 1,4 do
		front[i][1] = o1+10*cos(t()/10)+10*cos(0*adv/60 + i*0.25)
		front[i][2] = o2+10*sin(t()/10)+10*sin(0*adv/60 + i*0.25)
		c1[i][1] = o1+40*cos(0*adv/60 + i*0.25+0.05)
		c1[i][2] = o2+40*sin(0*adv/60 + i*0.25+0.05)
		c2[i][1] = o1+80*cos(0*adv/60 + i*0.25+0.1)
		c2[i][2] = o2+80*sin(0*adv/60 + i*0.25+0.1)
		back[i][1] = o1+120*cos(0*adv/60 + i*0.25+0.15)
		back[i][2] = o2+120*sin(0*adv/60 + i*0.25+0.15)
	end
end

function _draw()
	cls()
	local n = 15
	
	for i = 1,4 do
		ox, oy = bezier(front[i],c1[i],c2[i],back[i],0)
		for j = 1, n do
			nx, ny = bezier(front[i],c1[i],c2[i],back[i],j/n)
			line(ox,oy,nx,ny,j)
			ox, oy = nx, ny
		end
	end	

	for j = 1,n do
		ox, oy = bezier(front[1],c1[1],c2[1],back[1],(j/n+adv/90)%1)
		for i = 1, 4 do
			nx, ny = bezier(front[i%4+1],c1[i%4+1],c2[i%4+1],back[i%4+1],(j/n+adv/90)%1)
			line(ox,oy,nx,ny,7)
			ox, oy = nx, ny
		end
	end
end


function bezier(a,b,c,d,t)
	local u = 1-t
	local x = u^3 * a[1] +
											3*u^2*t * b[1] +
											3*u*t^2 * c[1] +
											t^3 * d[1]
	local y = u^3 * a[2] +
											3*u^2*t * b[2] +
											3*u*t^2 * c[2] +
											t^3 * d[2]
	return x,y
end
__sfx__
011400201875500000187550000018755187550000018755187001875500000187500000000000187551870518755000001875500000187551875500000187550000018750000000000000000000000000000000
011400201d755110001d755110001d7551d7551d0001d7551d7001d7551d0001d7501d0001d0001d7551d7051d7551d0001d7551d0001d7551d7551d0001d7551d0001d750110001100011000110001100011000
01140020187550000018755000001875518755000001875518700187550000018750000000000018755187051875500000187550000018755187550000018755000001d750000000000000000000000000000000
011000201873518735187351873518735187351873518735187351873518735187351873518735187351873518735187351873518735187351873518735187351873518735187351873518735187351873518735