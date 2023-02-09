pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
	p_init()
	w_init()
	bg_init()
end

function _update()
	dx,dy = p_update()
	bg_update(dx,dy)
	pjet_update()	
	g_update()
	w_update()
end

function _draw()
	cls()
	bg_draw()

	camera(p.x-64,p.y-64)
	pjet_draw()
	w_draw()	
	g_draw()
	p_draw()

	
	camera(0,0)
	print(stat(0),0,0,7)
	print(stat(1),0,7,7)
end

function col_rect(r1,r2)
	if r1[1] - r1[3] < r2[1] + r2[3] and
 	  r2[1] - r2[3] < r1[1] + r1[3] and
 	  r1[2] - r1[4] < r2[2] + r2[4] and
 	  r2[2] - r2[4] < r1[2] + r1[4] then
 	  return true
	end
	return false
end

function col_dir(r,r2)
	local pt = p_in_r({r[1],r[2]-r[4]},r2)
	local pb = p_in_r({r[1],r[2]+r[4]},r2)
	local pl = p_in_r({r[1]-r[3],r[2]},r2)
	local pr = p_in_r({r[1]+r[3],r[2]},r2)
	
	local xcol = pl or pr
	local ycol = pt or pb
	local ret = {xcol, ycol}

	return ret	
end

function p_in_r(p,r)
	local x = (p[1] >= r[1] - r[3]) and (p[1] < r[1]+r[3])
 local y = (p[2] >= r[2] - r[4]) and (p[2] < r[2]+r[4])
 return x and y
end
-->8
-- background

bg1 = {}
bg2 = {}

function bg_init()
	bg1_cam = {0,0}
	bg2_cam = {0,0}
	
	local bg_n = 50
	local xmin,xmax = wall_x[1]/4-50,wall_x[2]/4+50
	local ymin,ymax = wall_y[1]/4-50,wall_y[2]/4+50
	local w,h = 30,60
	
	for i = 1,bg_n do
		add(bg1,{rnd(xmax-xmin)*2+xmin,
											rnd(ymax-ymin)*2+ymin,
											rnd(w),rnd(h)})
		add(bg1,{rnd(xmax-xmin)*2+xmin,
											rnd(ymax-ymin)*2+ymin,
											rnd(w),rnd(h)})
	 add(bg2,{rnd(xmax-xmin)+xmin,
											rnd(ymax-ymin)+ymin,
											rnd(w),rnd(h)})
	end
	
end

function bg_update(dx,dy)
	bg1_cam[1] += dx/2
	bg1_cam[2] += dy/2
	bg2_cam[1] += dx/4
	bg2_cam[2] += dy/4
end

function bg_draw() 
	
	camera(bg2_cam[1],bg2_cam[2])
	for i,b in pairs(bg2) do
		rectfill(b[1],b[2],
											b[1]+b[3],b[2]+b[4],
											1)
	end

	camera(bg1_cam[1],bg1_cam[2])
	for i,b in pairs(bg1) do
		rectfill(b[1],b[2],
											b[1]+b[3],b[2]+b[4],
											13)
	end
end

-->8
-- player

p = {}
pjet = {}

function p_init() 
	p.x, p.y = 64,64
	p.s = 3
	p.dx, p.dy = 0,0
	p.dm = 4
	p.acc = 0.3
	p.alive = true
	
	pjet_init()
end

function p_update()
	if (not p.alive) return
	if (btn(⬆️)) p.dy = max(-p.dm,p.dy-p.acc) pjet_add({x = p.x+rnd(2)-1, y = p.y+p.s+2, dx = p.dx+rnd(2)-1, dy = p.dy/2+2+rnd(0.3), s=.7, a=7+rnd(4), c=10})
	if (btn(⬇️)) p.dy = min(p.dm,p.dy+p.acc) pjet_add({x = p.x+rnd(2)-1, y = p.y-p.s-2, dx = p.dx+rnd(2)-1, dy = p.dy/2-2-rnd(0.3), s=.7, a=7+rnd(4), c=10})
	if (btn(⬅️)) p.dx = max(-p.dm,p.dx-p.acc) pjet_add({y = p.y+rnd(2)-1, x = p.x+p.s+2, dy = p.dy+rnd(2)-1, dx = p.dx/2+2+rnd(0.3), s=.7, a=7+rnd(4), c=10})
	if (btn(➡️)) p.dx = min(p.dm,p.dx+p.acc) pjet_add({y = p.y+rnd(2)-1, x = p.x-p.s-2, dy = p.dy+rnd(2)-1, dx = p.dx/2-2-rnd(0.3), s=.7, a=7+rnd(4), c=10})

	local pr = {p.x, p.y, p.s, p.s}

	local cfinal = {false, false, false}
	
	local idx = flr(pr[1]/20)
	for i = 1,#wcidx[idx] do
		if col_rect(pr,wcidx[idx][i]) then
			cfinal[3] = true
			local cdir = col_dir(pr,wcidx[idx][i])
			cfinal[1] = cfinal[1] or cdir[1]
			cfinal[2] = cfinal[2] or cdir[2]
		end		
	end

	if (cfinal[1] or (cfinal[3] and not cfinal[2])) p.dx *= -1 p.x += p.dx
	if (cfinal[2] or (cfinal[3] and not cfinal[1])) p.dy *= -1 p.y += p.dy

	p.x += p.dx
	p.y += p.dy

	return p.dx, p.dy
end

function p_draw()
	if (not p.alive) return
	rectfill(p.x-p.s,p.y-p.s,p.x+p.s,p.y+p.s,8)
	rectfill(p.x-(p.s+1),p.y-1,p.x+(p.s+1),p.y+1,2)	
	rectfill(p.x-1,p.y-(p.s+1),p.x+1,p.y+(p.s+1),2)
end



function pjet_add(p)
	add(pjet,p)
end

function pjet_init()
	pjet = {}
end

function pjet_update()
	pjet_xmax, pjet_xmin = p.x,p.x
	pjet_ymax, pjet_ymin = p.y,p.y
	for pt in all(pjet) do
		pt.x += pt.dx
		pt.y += pt.dy
		pjet_xmax = max(pjet_xmax,pt.x)
		pjet_xmin = min(pjet_xmin,pt.x)
		pjet_ymax = max(pjet_ymax,pt.y)
		pjet_ymin = min(pjet_ymin,pt.y)
		pt.a -= 1
		if (pt.a <= 0) del(pjet,pt)
	end
end

function pjet_draw()
	for i,p in pairs(pjet) do
		rectfill(p.x-p.s,p.y-p.s,p.x+p.s,p.y+p.s,p.c)
	end
	--rect(ptc_xmin,ptc_ymin,ptc_xmax,ptc_ymax,7)
end
-->8
-- enemies


-->8
-- walls

floors = {}
walls = {}
wall_x = {}
wall_y = {}

wcidx = {}

function w_init()
	-- generate floors
	local fx, fy, fw, fh = 64,64,0,0

	for i=1,30 do
		fx = fx+fw
		fy = fy+fh*sgn(rnd()-0.5)
		fw = 50+rnd(50)
		fh = max(fw/(rnd()+2),40)
		if rnd() < 0.5 then
			fw,fh = fh,fw
		end
		
		wall_x = {min(fx, wall_x[1]), max(fx,wall_x[2])}
		wall_y = {min(fy, wall_y[1]), max(fy,wall_y[2])}
		add(floors,{fx,fy,fw,fh})
	end

	g_init(fx,fy)
	
	-- generate walls
	for i = 1,#floors do
		local f = floors[i]
			for j = 1,10 do			
				add(walls,
								{f[1]-f[3],
									f[2]-f[4]+j*f[4]/5-2,
									5,
									f[4]/5+1,
									7}
							)
				add(walls,
								{f[1]+f[3],
									f[2]-f[4]+j*f[4]/5-2,
									5,
									f[4]/5+1,
									7}
							)
				add(walls,
								{f[1]-f[3]+j*f[3]/5-2,
									f[2]-f[4],
									f[3]/5+1,
									5,
									7}
							)
				add(walls,
								{f[1]-f[3]+j*f[3]/5-2,
									f[2]+f[4],
									f[3]/5+1,
									5,
									7}
							)
			end
	end

	for j in all(floors) do
		j[3] = j[3]-4
		j[4] = j[4]-4
	end
	
	for i in all(walls) do
		local c = 0
		for j in all(floors) do
			if (col_rect(i,j)) c += 1
		end
		if c > 1 then 
			del(walls,i)
		else
			local lw,hi = flr((i[1]-i[3])/20),flr((i[1]+i[3])/20)
			if (wcidx[lw]==nil) wcidx[lw] = {}
			if (wcidx[hi]==nil) wcidx[hi] = {}
			add(wcidx[lw],i)
			add(wcidx[hi],i)		
		end
	end		
end

function w_update()
end

function w_draw()
	for f in all(floors) do
		rect(f[1]-f[3],f[2]-f[4],f[1]+f[3],f[2]+f[4],5)
	end
	for f in all(walls) do
		rectfill(f[1]-f[3],f[2]-f[4],
											f[1]+f[3],f[2]+f[4],
											f[5])		
	end
end
-->8
-- goal

function g_init(x,y)
	gx, gy = x, y	
end

function g_update()
end

function g_draw()
	if abs(gx-p.x) < 64 and abs(gy-p.y) < 64 then
		rectfill(gx-8,gy-8,gx+8,gy+8,3)
		rect(gx-6,gy-6,gx+6,gy+6,11+(t()*2)%2)
	elseif (t()*2%2 < 1) then
		local d = atan2(gx-p.x,gy-p.y)
		local cx = mid(p.x-60,p.x+60,p.x+100*cos(d))
		local cy = mid(p.y-60,p.y+60,p.y+100*sin(d))
		rectfill(cx-3,cy-3,cx+3,cy+3,3)
		rect(cx-2,cy-2,cx+2,cy+2,11)		
	end
end
