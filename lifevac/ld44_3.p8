pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- basic

function _init()
	init_board()
	user_init()
	start_simulation()
end

function _update()
	update_interface()
end

function _draw()
	cls(0)
	draw_board(boardpos[1],boardpos[2])
	draw_interface()

	draw_log()
	
	continue_simulation()
end

log = {}
function draw_log()
	local count = 8
	print(stat(1),100,128-count,10)
	for i in all(log) do
		count += 8
		print(i,100,128-count,10)
	end
end
-->8
-- simulation

function init_board()
	boardpos = {62,20}
	board = {}
	bpop = 0
	bsize = 60
	bocolor = {7,6}
	bcolor = {4,9,10,7}
	randomize_board(500)
end

function randomize_board(count)
	board = {}
	for i = 1,count do
		board[flr(rnd()*bsize) + flr(rnd()*bsize)*bsize] = bcolor[1]
	end
end

function add_random(x,y,r,count)
	for i = 1,count do
		local xo = flr(x + rnd()*r)
		local yo = flr(y + rnd()*r)
		local idx = xo + yo*bsize
		board[idx] = bcolor[1]
	end
	start_simulation()
end

function add_stamp(x,y,st)
	sx = (st%16)*8
	sy = (flr(st/16))*8
	for i = 0,16 do
		for j = 0,16 do
			local idx = x+i + (y+j)*bsize
			if (sget(sx+i,sy+j) != 0) board[idx] = bcolor[1]
		end
	end
	start_simulation()
end


function start_simulation()
	bup = cocreate(simulate)
end

function continue_simulation()
	if (costatus(bup) == "dead") bup = cocreate(simulate)
	assert(coresume(bup))
end


function simulate()
	local new_board = {}
	for k=0,bsize*bsize do
		local sum = 0
		local mage = 0
		for xi=0,2 do
		 for yi=0,2 do
		 	if xi*yi != 1 and board[k+(xi-1)+(yi-1)*bsize] != nil then
		 	 sum += 1
		 	 mage = max(mage,board[k+(xi-1)+(yi-1)*bsize])
		 	end
		 end
		end
		if board[k] != nil then
			if (sum > 1 and sum < 4) new_board[k] = max(1,board[k]-1)
		else
			if (sum == 3) new_board[k] = mage+1
		end
	end
	board = new_board
end

function draw_board(x,y)
	draw_edge(x,y)
	local clife = 0
	for k,i in pairs(board) do
		pset(x+k%bsize,y+flr(k/bsize),bcolor[min(flr(i/4)+1,#bcolor)])
		clife += 1
	end
	bpop = clife
	--draw_bar(x,y+bsize+2,clife)
end

function draw_edge(x,y)
	rectfill(x-1,y-1,x+bsize,y+bsize,bocolor[1])
	rectfill(x,y,x-1+bsize,y-1+bsize,bocolor[2])
end

--function draw_bar(x,y,fill)
--	rectfill(x-1,y,x+(fill/(bsize*sqrt(bsize)))*bsize,y+5,8)
--	rect(x-1,y,x+bsize,y+5,bocolor[1])
--end

function board_harvest(b,str)
	local ret = {}
	for k,i in pairs(b) do
		if rnd() < str then
			b[k] = nil
			add(ret,{x=k%bsize+boardpos[1], y=flr(k/bsize)+boardpos[2],s=i})
		end
	end
	start_simulation()
	return ret
end


-->8
-- user interface

function user_init()
	life_stored = 0
	action_state = 0
	
	suck_power = 0
	suck_pos = {boardpos[1],boardpos[2]-12}
	suck_pt = {}

	adder_pos = {0,0}
	menutiles = {3,5,7,9,11,13,35}
	menuwidth = 3
	menu_pos = 0
end

function update_interface()

	update_sucker()
	update_action()
end


function draw_interface()
	draw_sucker(suck_pos[1],suck_pos[2])
	draw_adder(adder_pos[1],adder_pos[2])
	draw_menu(0,0)
	draw_score(boardpos[1]+bsize/3,boardpos[2]+bsize+3)
end

function draw_score(x,y)
	print("♥",x,y,8)
	print(flr(life_stored),x+8,y,8)
end

function draw_sucker(x,y)
	-- draw sucklings
	for i in all(suck_pt) do
		pset(i.x,i.y,12)
	end

	if (suck_power > 0) then
		x += rnd()*2
		y += rnd()*2
	end

	-- draw sucker
	rectfill(x+16,y,x+bsize-17,y+8,5)
	rectfill(x+6,y+2,x+bsize-7,y+8,5)
	rectfill(x,y+4,x+bsize-1,y+8,5)	
	
	-- draw suck power
	rectfill(x+13,y+4,x+bsize-14,y+5,0)
	rectfill(x+12,y+3,x+12+(bsize-25)*suck_power,y+6, (#suck_pt > 0 and 12 or 8))
	rect(x+12,y+3,x+bsize-13,y+6, 6)	
end

function start_sucking()
	suck_pt = board_harvest(board,suck_power)
end

function update_sucker()
	
	if #suck_pt == 0 then
		if btn(❎) then 
			suck_power = (suck_power+0.05) % 1
		else
			if (suck_power > 0) start_sucking()
			if (#suck_pt == 0) suck_power = 0
		end
	else
		for i in all(suck_pt) do
			i.y -= 1+rnd()
			if i.y < boardpos[2]-4 then 
				life_stored += i.s/100
				del(suck_pt,i)
			end
		end
		if (#suck_pt == 0) suck_power = 0
	end
end

function draw_adder(x,y)
	if (action_state == 1) spr(menutiles[menu_pos+1],x+boardpos[1],y+boardpos[2],2,2)
	spr((action_state == 1 and 1 or 33),x+boardpos[1],y+boardpos[2],2,2)
end

function update_action()
	if action_state == 0 then
		update_menu()
	elseif action_state == 1 then
			update_adder()
	end
end

function update_adder()
	if (btn(⬆️)) adder_pos[2] = mid(0,adder_pos[2]-1,bsize-16)
	if (btn(⬇️)) adder_pos[2] = mid(0,adder_pos[2]+1,bsize-16)
	if (btn(⬅️)) adder_pos[1] = mid(0,adder_pos[1]-1,bsize-16)
	if (btn(➡️)) adder_pos[1] = mid(0,adder_pos[1]+1,bsize-16)


	if btnp(🅾️) then
	 --add_random(adder_pos[1],adder_pos[2],16,40)
	 add_stamp(adder_pos[1],adder_pos[2],menutiles[menu_pos+1])
	 action_state = 0
	end
end

function draw_menu(x,y)
	for i = 1,#menutiles do
		spr(menutiles[i],x+((i-1)%menuwidth)*18,y+flr((i-1)/menuwidth)*18,2,2)
	end
	spr((action_state == 0 and 1 or 33),x+(menu_pos%menuwidth)*18,y+flr(menu_pos/menuwidth)*18,2,2)
end

function update_menu()
	if (btnp(⬅️)) menu_pos = (menu_pos-1)%(#menutiles-1)
	if (btnp(➡️)) menu_pos = (menu_pos+1)%(#menutiles-1)
	if (btnp(⬆️)) menu_pos = (menu_pos-menuwidth)%(#menutiles-1)
	if (btnp(⬇️)) menu_pos = (menu_pos+menuwidth)%(#menutiles-1)
	
	if (btnp(🅾️)) action_state = 1
end
-->8
-- todo

-- remove the sucking bar
-- add modal interface

-- add cost and limit to stamp
-- add dead cells

-----------------------

-- multiple boards
-- target score for each board
-- later board with higher scores
-- later boards with fixed dead zones
-- iteration limit?
__gfx__
00000000aaaa00000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaa00000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000008888888800000000000000
00700700aa000000000000aa00000000000000000000000000000000000888800000000000000000000000000000000000000000008000000080000000000000
00077000aa000000000000aa00080000000000000000000000000000000800000088000000000800080000000000000080000000000000000088000000000000
00077000000000000000000000080800000000000000000000000000000800000880000000000800080000000000008888000000000000000008000000000000
00700700000000000000000000088000000000000000088880000000000000800000000000000800080000000000008008800000000880000008000000000000
00000000000000000000000000000000000000000000888888000000000000808888800000000800080000000000880000880000008088000008000000000000
00000000000000000000000000000000000000000008808888000000000000800000800000000000000000000008800000080000008008880088000000000000
00000000000000000000000000000000000000000000880000000000000000888800800000000000000000000008000000888000008000088800000000000000
00000000000000000000000000000000880000000000000000000000000000000008000000000000000000000008880008800000008000000000000000000000
00000000000000000000000000000008080000000000000000000000000008000008000000088000000080000000088080000000008000000000000000000000
00000000000000000000000000000000080000000000000000000000000008000000000000008800000880000000008880000000008888888800000000000000
00000000aa000000000000aa00000000000000000000000000000000000008000000000000000888088800000000000000000000000000000880000000000000
00000000aa000000000000aa00000000000000000000000000000000000008880000000000000008880000000000000000000000000000000080000000000000
00000000aaaa00000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaa00000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444400000000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444400000000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444400000000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444400000000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
