pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- basic

function _init()
	random_board()
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
	print(stat(1),100,0,10)
	for i in all(log) do
		print(i,100,count,10)
		count += 8
	end
end
-->8
-- simulation

board = {}
bpop = 0
bsize = 60
bcolor = {7,2}

function random_board()
	board = {}
	boardpos = {30,20}
	for i = 1,500 do
		board[flr(rnd()*bsize) + flr(rnd()*bsize)*bsize] = 1
	end
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
		for xi=0,2 do
		 for yi=0,2 do
		 	if (xi*yi != 1 and board[k+(xi-1)+(yi-1)*bsize] != nil) sum += 1
		 end
		end
		if board[k] != nil then
			if (sum > 1 and sum < 4) new_board[k] = 1
		else
			if (sum == 3) new_board[k] = 1
		end
	end
	board = new_board
end

function draw_board(x,y)
	draw_edge(x,y)
	local clife = 0
	for k,i in pairs(board) do
		pset(x+k%bsize,y+flr(k/bsize),bcolor[1])
		clife += 1
	end
	bpop = clife
	draw_bar(x,y+bsize+2,clife)
end

function draw_edge(x,y)
	rectfill(x-1,y-1,x+bsize,y+bsize,bcolor[1])
	rectfill(x,y,x-1+bsize,y-1+bsize,bcolor[2])
end

function draw_bar(x,y,fill)
	rectfill(x-1,y,x+(fill/(bsize*sqrt(bsize)))*bsize,y+5,8)
	rect(x-1,y,x+bsize,y+5,bcolor[1])
end

function board_harvest(b,str)
	local ret = {}
	for k,i in pairs(b) do
		if rnd() < str then
			b[k] = nil
			add(ret,{x=k%bsize+boardpos[1], y=flr(k/bsize)+boardpos[2]})
		end
	end
	-- fixme: maybe i need to kill the coroutine?
	start_simulation()
	add(log,#ret)
	return ret
end


-->8
-- user interface

function user_init()
	life_stored = 0
	suck_power = 0
	suck_pos = {boardpos[1],boardpos[2]-12}
end

function update_interface()

	update_sucker()
		
end


function draw_interface()
	draw_sucker(30,8)
end

suck_pt = {}
function draw_sucker(x,y)
	-- draw sucklings
	for i in all(suck_pt) do
		pset(i.x,i.y,12)
	end

	-- draw sucker
	rectfill(x+16,y,x+bsize-17,y+8,5)
	rectfill(x+6,y+2,x+bsize-7,y+8,5)
	rectfill(x,y+4,x+bsize-1,y+8,5)	
	
	-- draw suck power
	rectfill(x+13,y+4,x+bsize-14,y+5,0)
	rectfill(x+12,y+3,x+12+(bsize-25)*suck_power,y+6,8)
	rect(x+12,y+3,x+bsize-13,y+6,6)	
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
		end
	else
		for i in all(suck_pt) do
			i.y -= 1
			if (i.y < boardpos[2]-4) del(suck_pt,i)
		end
		if (#suck_pt == 0) suck_power = 0
	end
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
