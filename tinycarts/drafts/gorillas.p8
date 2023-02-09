pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--[[ gorillas.pico
a game by caranha 

--]]

function _init()
	t = 0
	start_bldg()
	start_gorilla()
	start_clouds()
	switch_side()
end

function _update()
	t += 1/30
	update_cam()
	update_ctrl()
	update_banana()
	update_explosion()
	update_clouds()
end

function _draw()
	camera(cam.x)

	cls(12)
	draw_clouds()
	draw_bldg()
	draw_gorilla()
	draw_ctrl()
	draw_banana()
	draw_explosion()
end
-->8
-- drawables

bldg = {}
holes = {}
explosion = {}
clouds = {}
cam = {x = 0, t = 0}

function start_bldg()
	local x = 0
	while (x < 256) do
		x = x + 16 + rnd(24)
		local y = 20 + rnd(60)
		local c = rnd(3)+13
		add(bldg,{x,y,c})
	end
end

function start_clouds()
	local xc = 0
	for i = 1,15 do
		xc += rnd(30)+10
		add(clouds,{
							x = xc,
							y = rnd(20)
		    }
		   )
	end
end

function update_clouds()
	for c in all(clouds) do
		c.x = (c.x + wind) % 300
	end
end

function draw_clouds()
	for c in all(clouds) do
		circfill(c.x - 20, c.y+5,10,7)
	end
end


function draw_bldg()
	local x0 = 0
	for b in all(bldg) do
		rectfill(x0,127,b[1],127-b[2],b[3])
		rect(x0,128,b[1],127-b[2],0)
		-- windows
		local wt = 1
		for yi = 127-b[2]+3, 137, 10 do
			for xi = x0 + 3, b[1] - 4, 6 do
				rectfill(xi,yi,xi+3,yi+7,(wt%13 == 0 and 7 or 2))
				wt += 1
			end
	 end
		x0 = b[1]+1
	end
	for h in all(holes) do
		circfill(h.x,h.y,h.r,12)
	end
end

function update_cam()
	cam.x = min(128,max(0,cam.x+(cam.t-cam.x)*0.3))
end

function add_explosion(x,y,s)
	add(explosion,{x = x, y = y, r = s*1.3, a = 0.5, dx = 0, dy = 0, dr = -1, c = 6})
	for i = .5,s-0.5,.3 do
		local tt = rnd()
		add(explosion,
						{ x = x-3+rnd(6), y = y-3+rnd(6),
								dx = cos(tt)*(i/4), dy = sin(tt)*(i/4),
								dr = 0, r = (s-i)/2,
								c = 5 + rnd(3),
								a = rnd(s/15)
						})
	end
end

function update_explosion()
	for e in all(explosion) do
		if (e.a < 0) del(explosion,e)
		e.a -= 1/30
		e.x += e.dx
		e.y += e.dy
		e.r += e.dr
	end
end

function draw_explosion()
	for e in all(explosion) do
		circfill(e.x,e.y,e.r,e.c)
	end
end
-->8
-- gorilla

gorilla = {}

function start_gorilla()
	add(gorilla, 
	    { x = bldg[1][1]+rnd()*(bldg[2][1]-16-bldg[1][1]),
	    		y = 128-bldg[2][2]-16
	    })

	add(gorilla, 
	    { x = bldg[#bldg-2][1]+rnd()*(bldg[#bldg-1][1]-16-bldg[#bldg-2][1]),
	    		y = 128-bldg[#bldg-1][2]-16
	    })
end

function draw_gorilla()
	for i in all(gorilla) do
		spr(1,i.x,i.y,2,2,t*2%2<1)
	end
end
-->8
-- control

state = 0 -- 0 aim, 1 launch, 2 explode

side = 0
banana = {}
banana_cd = 0
cpu_cd = 2

ctrl = {d = 0.125, p = 5}
p_ctrl = {d = 0.125, p = 5}

wind = 0
maxdy = 4

function switch_side()
	side = (side == 1 and 2 or 1)
	wind = rnd(3)-1.5
	if side == 1 then -- player's turn
		ctrl.d = p_ctrl.d
		ctrl.p = p_ctrl.p
		cam.t = 0
		update_ctrl = player_ctrl
	else
		cpu_cd = 2
		p_ctrl.d = ctrl.d
		p_ctrl.p = ctrl.p
		cam.t = gorilla[2].x - 64
		update_ctrl = cpu_ctrl
	end
end


function cpu_ctrl()
	if (state == 1) return
	cpu_cd -= 1/30
	ctrl.d = mid(0.25, ctrl.d+rnd(0.02)-0.01, 0.5)
	ctrl.p = mid(0,ctrl.p+rnd(0.2)-0.1,2)
	if cpu_cd < 0 then
		state = 1
		local b = {}
		b.x = gorilla[side].x - 4
		b.y = gorilla[side].y - 2
		b.dx = cos(ctrl.d)*ctrl.p
		b.dy = sin(ctrl.d)*ctrl.p
		b.age = 0
		add(banana,b)
	end
end

function player_ctrl()
	if (state == 1) return
	if (btn(⬅️)) ctrl.d = min(0.25,ctrl.d+0.01)
	if (btn(➡️)) ctrl.d = max(0,ctrl.d-0.01)
	if (btn(⬆️)) ctrl.p = min(10,ctrl.p+0.1)
	if (btn(⬇️)) ctrl.p = max(2,ctrl.p-0.1)
	if btn(❎) then
		state = 1
		local b = {}
		b.x = gorilla[side].x + 4
		b.y = gorilla[side].y - 2
		b.dx = cos(ctrl.d)*ctrl.p
		b.dy = sin(ctrl.d)*ctrl.p
		b.age = 0
		add(banana,b)
	end
end

function draw_ctrl()
	if (state == 0) then
		local x = gorilla[side].x + 4
		local y = gorilla[side].y - 2
		local d = ctrl.d
		local p = ctrl.p
		line (x+cos(d)*5, y+sin(d)*5, x+cos(d)*(5+p*2), y+sin(d)*(5+p*2), rnd(16))				
	end
end

function draw_banana()
	for b in all(banana) do
		spr(5 + rnd(4), b.x, b.y)
	end
end 

function update_banana()
	if banana_cd > 0 then
		banana_cd -= 1/30
		if banana_cd <= 0 then
			state = 0
			switch_side()
		end
	end
	
	for b in all(banana) do
		cam.t = b.x - 64
		b.x += b.dx + wind
		b.y += b.dy
		b.dy = min(b.dy + 0.5, maxdy)
		b.age += 1
		if b.y > 128 then
			banana_cd = 0.5
			del(banana,b)
			break
		end
		if (b.y < 0) break
		if (b.age < 2) break	
		for i = 0,2 do
		 for j = 0,2 do
	 		local c = pget(b.x + i, b.y + j)	 	
	 		if (c != 10 and c != 12 and c != 7) then
	 			banana_cd = 0.5
	 			del(banana,b)
		 		add(holes,{x = b.x, y = b.y, r = 5})
		 		add_explosion(b.x,b.y,7)
		 		break
		 	end
	 	end
		end		
	end
end
__gfx__
00000000000000000000000000990000000000000a000000000000000a0000000aa0000000000000000000000000000000000000000000000000000000000000
0000000000000099990000000999009999000000a0000000a00a000000a00000a00a000000000000000000000000000000000000000000000000000000000000
0070070000000499994099400990049999400000a00000000aa0000000a000000000000000000000000000000000000000000000000000000000000000000000
00077000000094499449999009900449944900000a000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000
00077000049999999999099009900999999999400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700099999999999099009909999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099049999994099009994999999409900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099049999994099004994999999409900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099004499440999000000449944009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099009999990990000000999999009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099909999990000000000999999099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999400499000000009940049999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000099000099000000009900009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000990000009900000099000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000990000009900000099000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999000099000000099900009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000001c050000001c0501c050000001e0500000000000240500000027050290502b0502d0503105000000350503505035050320502e050280502505022050210502105000000000000000000000
