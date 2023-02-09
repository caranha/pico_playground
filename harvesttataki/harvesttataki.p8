pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- harvest tataki:whac-a-carrot
-- for ludum dare 52
-- by @caranha

-- more music tutorial

--[[
todo:
		    
- polish
  - farm
  - hit rate
  - other cute things

- version 1 complete?

- submit to itch?
		
]]--
-->8
-- game stuff

function game_init()
	t=0
	music(2)
	gameover_cd=0

	hole = {
		{x=20, y=90, f = "⬅️", p=-1, j=nil},
		{x=90, y=90, f = "➡️", p=-1, j=nil},
		{x=55, y=70, f = "⬆️", p=-1, j=nil},
		{x=55, y=110, f = "⬇️", p=-1, j=nil},
	}

	jumpsize=20
	flying_carrots={}
	
	-- difficulty scaling
	diff = 1
	cchance = {{1,1,1,1,3},
												{1,1,1,1,3},
												{1,1,3},
												{1,1,1,3,3},
												{1,3}}
	speed = {{0.6},
										{0.6,0.8},
										{0.8,1},
										{0.8,1,1.2},
										{1,1.2}}
	freq = {0.06,
									0.08, 
									0.1, 
									0.12,
									0.15}

	pushes = 0
	lives = 4
end

function game_update()
	t+=1/30
	local dusk = {
		{110,0,0},
		{95,1,9},
		{75,2,9},
		{50,13,10}
	}
	
	for d in all(dusk) do
		if t > d[1] then
		 pal(12,d[2],1)
		 pal(10,d[3],1)
		 if (d[2] == 0 and gameover_cd == 0) gameover_cd = t
		 break
		end
	end
	
	if gameover_cd > 0 and t-gameover_cd > 2 then
		music(-1)
		init_over()
		_update = update_over
		_draw = draw_over
		return
	end
	
	for i=1,#hole do
		local h = hole[i]
		if btnp(i-1) and gameover_cd == 0 then
		 h.p = t
		 pushes += 1
		 h.rst = check_hit(i,h.p)
		 if h.rst == "good" then
		  sfx(0)
		  -- make carrot fly
		  add(flying_carrots,{
		  	x=h.x,
		  	y=h.y+sin((t-h.j.t)*h.j.sp)*jumpsize,
		  	t=h.p,
		  	d=rnd({-1,1})
		  	})
		  if #flying_carrots%10==0 then
		   diff += 1
		   sfx(13)
		  end
		  h.j = nil
		 elseif h.rst == "bad" then 
		 	sfx(2)
		 	lives -= 1
		 	h.j.s=5
		 	if (lives < 1) gameover_cd = t
		 else
		 	sfx(1)
		 end
		end
		if h.j != nil and (t - h.j.t)*h.j.sp > .75 then
			h.j = nil -- finish jump
		end
	end 
	jump_something()
end

function jump_something()
	if (t < 0.8 or gameover_cd > 0) return
	
	-- difficulty
	local d = min(diff,#freq)
	local ds = 1 + (diff > d and 0.05*diff or 0)

	i = rnd({1,2,3,4})
	local h = hole[i]
	if h.j == nil and 
				rnd() < freq[d] then
	 h.j = {t=t, 
	 							s=rnd(cchance[d]), 
	 							sp=rnd(speed[d])*ds}
	end
end


function check_hit(i,tim)
	-- check if a hit on hole i 
	-- at time t is a hit
	-- return "miss", "good", "bad"
	local h = hole[i]
	if (h.j == nil) return "miss"
	if (sin((tim - h.j.t)*h.j.sp) > -0.4) return "miss"
	if h.j.s == 3 then 
		return "bad"
	elseif h.j.s == 5 then
		return ""
	else
		return "good"
	end
end



-->8
-- drawing stuff

function game_draw()
	
	draw_background()
	
	for i=1,#hole do
		local h=hole[i]
		draw_hole(h.x,h.y,h.f,t-h.p<0.2)
		if h.j then
			draw_jump(h.x, h.y, h.j.s, h.j.t, h.j.sp)
		end
		if t - h.p < 0.2 then
			if (h.rst == "miss") draw_miss(h.x,h.y)
			if (h.rst == "good") draw_good(h.x,h.y)
			if (h.rst == "bad") draw_bad(h.x,h.y)
		end
	end
	draw_lives()
	draw_flying_carrots()
end

function draw_background()
	cls(12)
	local y0 = 30
	if (_update != update_menu) y0+=flr(t/15)
	circfill(15,y0,8,10)
	for x=0,128 do
		for y=0,30 do
			local a = atan2(x-15,y-y0) + t/4
			if (a%0.15 > 0.10 and x%2==0 and y%2==0) pset(x,y,10)
			if (x > 0 and y-28 > sin(x/20)*(x/20)-x/20) pset(x,y,5)
		end
	end
	rectfill(0,30,128,128,11)
	local c={3,14,8}
	for i=1,30 do
		local x = (i*311)%128
		local y = (i*199)%98+30
		circ(x,y,1,c[(i)%3+1])
	end
end

function draw_flying_carrots()
	for i= 1,#flying_carrots do
		fc = flying_carrots[i]
		local x=fc.x
		local y=fc.y
		local dt=t-fc.t
		spr(1,x+dt*90*fc.d,y+sin(dt/2)*40,2,2)
		if dt > 1.5 then
			local x=max(110+(i*2)%7,128-(dt-1)*12)
			local y=min(70-i,30-i+(dt-1)*30)
			spr(16,x,y)
		end
	end
end


function draw_hole(x,y,c,p)
	ovalfill(x,y,x+16,y+8,0)
	line(x+4,y+8,x+12,y+8,5)
	?"◆",x+6,y+12,p and 8 or 0
	?"❎",x+6,y+12,p and 8 or 0
	?c,x+5-(p and -1 or 0),y+11-(p and -1 or 0),13
end

function draw_jump(x,y,s,tim,sp)
	clip(0,0,128,y+8)
	local y0 = y + sin((t-tim)*sp)*jumpsize
	spr(s,x,y0,2,2)
	clip()
end

function draw_lives()
	for i=0,3 do
		if i < lives then
			spr(3,i*11,110+sin(t*2	+i/2)*3,2,2)
		else
			spr(5,i*11,113,2,2)
		end
	end
end


function draw_miss(x,y)
	dx = rnd(2)
	dy = rnd(2)
	?"\^w\^t?",x+dx+6,y+dy-15,5
	?"\^w\^t?",x+dx+5,y+dy-16,8
end

function draw_good(x,y)
	x0=x
	y0=y-18
	pal(10,rnd({3,3,10}))
	spr(37,x0+rnd(2),y0+rnd(2),2,2)
	pal(3,rnd({3,3,10}))
	spr(35,x0+rnd(2),y0+rnd(2),2,2)
	pal(10,10)
	pal(3,3)
end

function draw_bad(x,y)
	spr(33,x+rnd(2),y-15+rnd(2),2,2)	
end

-->8
-- game state
function _init()
	cartdata("caranha_ld52_harvest")
	highscore=dget(0)
	
	init_menu()
	_update = update_menu
	_draw = draw_menu	
end


-------   menu    ------

function init_menu()
	pal()
	music(0)
	start=-1
	t=0
end

function update_menu()
	t+=1/30
	if t>0.1 and btn()>0 and start < 0 then
		music(-1)
		sfx(3)
		t=max(t,5)
		start = t
	end
	if start > 0 and t-start > 2 then
		game_init()
		_update = game_update
		_draw = game_draw
	end
end

function draw_menu()
 draw_background()
 
 title1  = "ハ-ヘ゛スト" 
 title2 = "タタキ"
 title_en = "whac-a-carrot"
 
 for i=1,#title1 do
 	x = i*15
 	y = min(-30-i*10+t*40,50-i*2)
		?"\^w\^t"..title1[i],x+1,y+1,0
 	?"\^w\^t"..title1[i],x,y,7
 end
 if t > 3.5 then
	 for i=1,#title2 do
			?title2[i],61+i*10,56,0
	 	?title2[i],60+i*10,55,t*3%4+3+i
 	end
 end
 
 if t > 4.2 then
  rectfill(33,70,87,77,0)
 	rectfill(32,69,86,76,3)
 	for i=1,#title_en do
 		?title_en[i],30+4*i,71,0
 		?title_en[i],30+4*i,70,i<8 and 8 or 9
 	end
	end 
	
	if t > 5 then
		for i=0,7 do
			spr(1+2*(i%2),
							(18*i+t*30)%148-10,
							90+sin(t+i%3/3)*8,2,2)
		end
	
		print("a game by @caranha",56,116,0)
		print("for ludum dare 52",60,122,0)
		
		hsd = 0
		if (highscore > 9) hsd+=1
		if (highscore > 99) hsd+=1
		if (highscore > 999) hsd+=1
		-- never doubt the folly of man
		if (highscore > 9999) hsd+=1
		
		if highscore > 0 then
			local x = 60 + cos(t/3)*4
			local y = 4 + sin(t/5)*2
			
			?"★high score★",x,y+1,0
			?highscore,x+26-hsd*3,y+8,0
			?"★high score★",x,y,8+t*3%4
			?highscore,x+26-hsd*3,y+7,8+t*3%4
		end
	end
end


------- game over ------

function init_over()
	music(63)
	deatht=t
	new_highscore = false
	if #flying_carrots > highscore then
		new_highscore = true
		highscore = #flying_carrots
		dset(0,highscore)
	end
end

function update_over()
	t+=1/30
	if t>deatht+0.2 and btn() > 0 then
		init_menu()
		_update = update_menu
		_draw = draw_menu
	end
end

function draw_over()
	draw_background()
	
	print("\^w\^tgame",50,60,5)
	print("\^w\^tover",50,72,5)
	
	print("score: "..#flying_carrots,50,90,5)
	if new_highscore then
		pal(10,8+t*5%3,1)
		print("★ new high score! ★",
								22,
								42+sin(t)*4,10)
	end
	
	draw_flying_carrots()	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000003333033000000077000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000399330000000075700007570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000033999900000000075570075570000000006006000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000949900000000007577775700000000006006000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000994900000000000777777000000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000999900000000000787787000000000065665600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000099900000000000787787000000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000094400000000000777777000000000065757600000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000099400000000000779977000000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000
00099000000000009000000000000077770000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000
00999330000000009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000000088800033333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000008888800333555555333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005888800088888803335000000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000058888088888850335000000000330000000aaaa000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000588888888500335000000000003300000aaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005888888500033500000000000330000aaa55aaa0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000888885000033500000000000330000aa5000aa5000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000088888888000033500000000000330000aa5000aa5000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888885888800033500000000000330000aaa00aaa5000000000000000000000000000000000000000000000000000000000000000000000000000
000000000088888500588800335000000000003300000aaaaaa50000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008888850000588800330000000000335000000aaaa500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000588885000000588803330000000033300000000555000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000588850000000058800333000000333500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055500000000000000033333333335000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000333333500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
ccccccccccacacacacacccccccccccccccccccccccacacacacacacacacacacacacaccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccacacacacccccccccccccccccccccccacacacacacacacacacacacaccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccacacacacccccccccccccccccccccccacacacacacacacacacaccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbccccbcbcbbbccbbcbcbccccccbbccbbccbbcbbbcbbbccccbccccccccccccccc
ccccccccccacacacacccccccccccccccccccccacacacacacacacacacaccccccbbbcccbcbc0b0cb00cbcbcccccb00cb00cb0bcb0bcb00cccbbbcccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbcbbbccbccbcccbbbcccccbbbcbcccbcbcbb0cbbccbbbbbbbcccccccccccc
ccccccccccccacacacccccccccccccccccccacacacacacacacacacccccccc0bbbbb0cb0bccbccbcbcb0bccccc00bcbcccbcbcb0bcb0cc0bbbbb0cccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccb000bccbcbcbbbcbbbcbcbcccccbb0c0bbcbb0cbcbcbbbccb000bccccccccccccc
ccccccccccccacacacccccccccccccccccacacacacacacacaccccccccccccc0ccc0cc0c0c000c000c0c0ccccc00ccc00c00cc0c0c000cc0ccc0ccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccacacacccccccccccccccacacacacacacacccccccccccccccccccccccccccccccccccccccbcbcbbcccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbcbc0bcccccccccccccccccccccccccccccccccccccc
ccccccccccccacacacccccccccccccacacacacacacacccccccccccccccccccccccccccccccccccccccccbbbccbcccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00bccbcccccccccccccccccccccccccccccccccccccc
ccccccccccccacacacccccccccccacacacacacacccccccccccccccccccccccccccccccccccccccccccccccbcbbbccccccccccccccccccccccccccccccccc555c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0c000cccccccccccccccccccccccccccccccc55555
acccccccccccccacacccccccccacacacacaccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc555cccccccccccccccc55555
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc55555cccccccccccccc555555
acacccccccccccacacccccccacacacacaccccccccccccccccccccccccccccccccccccccccccccccccccc555ccccccccccccccc5555555ccccccccccccc555555
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc55555cccccccccccccc55555555ccccccccccc5555555
acacacaccccccaaaaaccccccacacaccccccccccccccccccccccccccccccccccc5555cccccccccccccc5555555cccccccccccc555555555ccccccccccc5555555
cccccccccccaaaaaaaaaccccccccccccccccccccccccccccccccccccccccccc555555cccccccccccc555555555ccccccccccc5555555555ccccccccc55555555
ccacacacacaaaaaaaaaaacacaccccccccccccccccccc5555cccccccccccccc55555555ccccccccccc5555555555ccccccccc55555555555cccccccc555555555
cccccccccaaaaaaaaaaaaacccccccccccccccccccc55555555ccccccccccc5555555555ccccccccc555555555555ccccccc5555555555555ccccccc555555555
ccccccacaaaaaaaaaaaaaaa555555cccccccccccc5555555555cccccccc5555555555555ccccccc5555555555555cccccc555555555555555ccccc5555555555
ccccccccaaaaaaaaaaaaa55555555555ccccccc55555555555555ccccc555555555555555ccccc555555555555555ccccc5555555555555555ccc55555555555
c55555555555555a5555555555555555555c5555555555555555555c5555555555555555555c5555555555555555555c5555555555555555555c555555555555
c5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb77bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7777777777bbbbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb77777777770bbbbeb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb77bb77bbbbbbbbbbbb0000000770bbbebe777777bbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb770b770bbbbbbbbbbbbbbbbbb770bbbbeb7777770bbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb7777bbbbbbb770b770bbbbbbbbbbbbbbbb77b00bbbbbb77000077bbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbb77770bbbbbb770b770bbbbbbbbbbbbbbbb770bbbbbbbb770bbb770bbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbb77b00077bbbbbb00bb00bbbbbbbbbbbbbb77770bbbbbbbb770bbbb00bbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb770bbb770bbbbbbbbbbbbbbbbbb3bbbbbb77770bbbbbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbb77bbbbbbbbbbbbbbbbbbbb77b00bbbb077bbbbbbbbbbbbbbbb3b3b7777b00077bbbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbb770bbbbbbbbbbbbbbbbbbb770bbbbbbb770bbbbbbbbbbbbbbbb3bb77770bbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bebbbbbbbbbbbbbbbbb77bbb077bbb777777bbbbbbbbbb00bbbbbbbb077bbbbbbbbbbbbbbbbbbb0000bbbb00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ebebbbbbbbbbbbbbbbb770bbb770bb7777770bbbbbbbbbbbbbbbbbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bebbbbbbbbbbbbbbbbb770bbb770bbb000000bbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb770bbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb770bbbb077bbbbbbbbbbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb770bbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbb77777bbbbb88888bbbbbbb9bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbb77b00bbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb700070bbbb800080bbbb99999bbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbb770bbbbbbb770bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7b77b70bbb8b88b80bbbbb09000bbbbbbbbbbbbb3b3bbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbb00bbbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0b0770bbbb0b0880bbbb99999bbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb77b00bbbbb88b00bbbbb09000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbbb00bbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3333333333333333333333333333333333333333333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33838383838883388333338883333339939993999399933993999330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb33838383838083800333338083333390039093909390939093090330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
b8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbb33838388838883833388838883888393339993990399039393393330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbb33888380838083833300038083000393339093909390939393393330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33888383838383088333338383333309939393939393939903393330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33000303030303300333330303333330030303030303030033303330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb33333333333333333333333333333333333333333333333333333330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebebbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbb3333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbb3333b33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb77bbbbbb77bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbb39933bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb757bbbb757bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbb339999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb75578b7557bbbbbbbbbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbb9499bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb75777757bbbbbbbbbbbb3333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbb9949bbbbbbbbbbb77bbbbbb77bbbbbbbbbbbbbbbbbbbbbbbbbbbb777777bbbbbbbbbbbb3333b33bbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbb3bbbbbbbbbbbbbbbbb9999bbbbbbbbbbb757bbbb757bbbbbbbbbbbbbbbbbbbbbbbbbbbb787787bbbbbbbbbbbbb39933bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bb3b3bbbbbbbbbbbbbbbbb999bbbbbbbbbbb7557bb7557bbbbbbbbbbbbbbbbbbbbbbbbbbbb787787bbbbbbbbbbb339999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbb3bbbbbbbbbbbbbbbbbb944bbbbbbbbbbbb75777757bbbbbbbbbbbbbbbbbbbbbbbbbbbbb777777bbbbbbbbbbbbb9499bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbb994bbbbbbbbbbbbb777777bbbbbbbbbbbbbbebbbbbbbbbbbbbbb779977bbbbbbbbbbbbb9949bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbb787787bbbbbbbbbbbbbebebbbbbbbbbbbbbbb7777bbbbbbbbbbbbbb9999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbb787787bbbbbbbbbbbbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb777777bbbbbbbbbbbb33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb944bbbbbbbbbbbbbbbb8bbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb779977bbbbbbbbbbbbb3333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb994bbbbbbbbbbbbbbb8b8bbbbbbbbbbbbb
77bbbbbb77bbbbbbbbbbbbbbbbbbbbbbbbbbbbb7777bbbbbbbbbbbbb3333b33bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbb77bbb8bb77bbbbbbbbbb
757bbbb757bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbb39933bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbb757bbbb757bbbbbbbbbb
7557bb7557bbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bbbbbbbbbbbbb339999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7557bb7557bbbbbbbbbb
b75777757bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbb9499bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb75777757bbbbbbbbbbb
bb777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9949bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbb777777bbbbbbbbbbbb
bb787787bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebebbbbbbbbbbbbb787787bbbbbbbbbbbb
bb787787bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb999bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbb787787bbbbbbbbbbbb
bb777777bbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb944bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb777777bbbbbbbbbbbb
bb779977bbbbbbbbbbbbb8b8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb994bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb779977bbbbbbbbbbbb
bbb7777bbbbbbbbbbbbbbb8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7777bbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3b3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbebebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0008bbbbb00b000b000b000bbbbb000b0b0bbbbbb0bbb00b000b000b000b00bb0b0b000b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0b0b8bbb0bbb0b0b000b0bbbbbbb0b0b0b0bbbbb0b0b0bbb0b0b0b0b0b0b0b0b0b0b0b0b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0008bbbb0bbb000b0b0b00bbbbbb00bb000bbbbb0b0b0bbb000b00bb000b0b0b000b000b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0b0bbbbb0b0b0b0b0b0b0bbbbbbb0b0bbb0bbbbb0bbb0bbb0b0b0b0b0b0b0b0b0b0b0b0b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0b0bbbbb000b0b0b0b0b000bbbbb000b000bbbbbb00bb00b0b0b0b0b03030b0b0b0b0b0b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000bb00b000bbbbb0bbb0b0b00bb0b0b000bbbbb00bb000b000b000bbbbb000b000b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbb0b0b0b0bbbbb0bbb0b0b0b0b0b0b000bbbbb0b0b0b0b0b0b0bbbbbbb0bbbbb0b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bb0b0b00bbbbbb0bbb0b0b0b0b0b0b0b0bbbbb0b0b000b00bb00bbbbbb000b000b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbb0b0b0b0bbbbb0bbb0b0b0b0b0b0b0b0bbbbb0b0b0b0b0b0b0bbbbbbbbb0b0bbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbb00bb0b0bbbbb000bb00b000bb00b0b0bbbbb000b0b0b0b0b000bbbbb000b000b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb

__sfx__
000100000505006050090500c0500e0501605021050280502e0502a05024050220500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100003c55036550285500d55007550015500155002550025500355003550035500355003550005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
0001000007660146601667009670276700a670246702f67016670126700d670316601166014660116602f66024660176600f66000600006000060000600006000060000600006000060000600006000060000600
0008000016050180501b0501f05022050270502b050330502e050330502e050330502e050330502e050330402e040330302e030330202e020330102e010330102e01030000330000f0000f000110000000000000
011000000d1730d123080000a000311230d12306000080000d1730d1230d12333000311230d1231f000180000d1730d1731300013000311230d12324000220000d1730d1230d12316000311230d1230000000000
01100000273352a3552c3752e3352e3552c3752a3352a3552e300313002e3000070012700127000070000700273352a3552c3752e3352e3552c3752a3352a3552e331313312e3350070012700127000070000700
01100000273352a3552c3752e3352e3552c3752a3352a3552e331313312e33533331353312a3352a30027335273352a3552c3752e3352e3552c3752a3352a3552e300313002e3000070012700127000070000700
01100000272152a2152c2152e215272152a2152c2152a215272152a2152c2152e2152e21533215362153821527215272152a2152c2152a2152c2152e2152a215272152a2152c2152a21527215362153821536215
011000000f325123351434516325163351434512325123350f3110f32112311143250f3131231214322163000f325123351434516325163351434512325123350f3110f32512321143121b312203251b3171b322
011000001b3251e335203452232522335203451e3251e3351b3111b3211e311203251b3131e31220322223001b3251e335203452232522335203451e3251e3351b3111b3251e321203120f312143250f3170f322
01100000273252a3352c3452e3252e3352c3452a3252a33527311273212a3112c325273132a3122c3222e300273252a3352c3452e3252e3352c3452a3252a33527311273252a3212c31233312383253331733322
011000001b1351e155201752213522155201751e1351e15522115201151e1151e1251b1251e11520115221151b1351e155201752213522155201751e1351e15522115201151e1151e12522115201151e1151e125
011000001b13522135201752213122155201751e1351e1552e2252c2252a2352a235272352a2352c2352e2351b1351e15520175221351b13522131201751e1552e2252c2252a225362353a235382352a2352a235
00040000024520245202452034520445206452094520a4520d4520f4521245215452194521c4522345229452314523b4523f45200402004000040000400004000040000400004000040000400004000040000400
__music__
01 04050744
02 04060744
00 04494a44
01 04084344
00 04094344
00 04084344
00 040a4344
00 04050744
00 04060744
00 04050744
00 04060744
00 040b0744
00 040c0744
00 040b0744
00 440c4744
02 044b0744
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
03 04494a44

