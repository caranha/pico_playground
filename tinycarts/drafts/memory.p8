pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- main loop

p_keys = {false,false,false,false}
pk_pos = {{-16,0},{16,0},{0,-16},{0,16}}
k_cd = 0

seq = {}
seq_count = 0
state = 0
s_cd = 0
wrong = false

-- 0 wait
-- 1 run_seq -- wait next
-- 2 player_seq -- result 1 or 0

function _init()
	state = 1
	fun_update = {up_start,up_setup,up_play}
end

function _update()
	fun_update[state]()
end

function up_start()
	if btnp(❎) then
		seq = make_seq({})
		state = 2
	end
end

function up_setup()
	update_btn()
	s_cd = max(s_cd-1,0)
	if seq_count < #seq and k_cd == 0 then
		if s_cd == 0 then
			seq_count += 1
			s_cd = 20
			press_btn(seq[seq_count]-1)
		end
	end
	
	if seq_count == #seq and s_cd == 0 then
		seq_count = 1
		state = 3
	end
end

function up_play()
	if wrong then
		wrong = false
		clear_kb()
		seq_count = 0
	 state = 1		
	 s_cd = 0
	 return
	end	
	
	if seq_count > #seq then
		seq = make_seq(seq)
		seq_count = 0
		state = 2
		s_cd = 0
		return
	end

	update_btn()
	
	for i = 1,4 do
		if btnp(i-1) and press_btn(i-1) then
			if i == seq[seq_count] then
				seq_count += 1
			else
				wrong = true
				sfx(4)
			end
		end
	end	
end

function _draw()
	cls()
	draw_kb(20,20)
	
	if (state == 1) print("press ❎ to start",60,10,6)
	if (state == 2) print("wait...",60,17,9)
	if (state == 3) print("repeat!",60,24,3)
	
	
end

-->8
-- keyboard

function clear_kb()
	p_keys = {false,false,false,false}
	k_cd = 0
end

function press_btn(n)
	if k_cd == 0 then
		p_keys[n+1] = true
		k_cd = 15
		sfx(n)
		return true
	else
		return false
	end
end

function update_btn()
	if k_cd > 0 then
		k_cd -= 1
	else
		for i = 1,4 do
		p_keys[i] = false
		end
	end
end

function make_seq(s)
	seq_count = 0
	for i = 1,4 do
		add(s,flr(rnd(4)+1))
	end
	return(s)
end

function draw_kb(x,y)
	for i = 1,4 do
		spr(4*(i-1)+(p_keys[i] and 2 or 0),
		x+pk_pos[i][1],
		y+pk_pos[i][2]+(p_keys[i] and 1 or 0),
		2,2)
	end
end

-->8
-- 
__gfx__
1ccccccccccccccc1ccccccccccccccc188888888888888818888888888888881aaaaaaaaaaaaaaa1aaaaaaaaaaaaaaa1bbbbbbbbbbbbbbb1bbbbbbbbbbbbbbb
1ccccccccccccccc1ccccccccccccccc188888888888888818888888888888881aaaaaaaaaaaaaaa1aaaaaaaaaaaaaaa1bbbbbbbbbbbbbbb1bbbbbbbbbbbbbbb
1ccccc00cccccccc1ccccc00cccccccc188888880088888818888888008888881aaaaa0000aaaaaa1aaaaa0000aaaaaa1bbbbbbbbbbbbbbb1bbbbbbbbbbbbbbb
1cccc000cccccccc1cccc000cccccccc188888880008888818888888000888881aaaa000000aaaaa1aaaa009900aaaaa1bbbb000000bbbbb1bbbb000000bbbbb
1ccc0000cccccccc1ccc0010cccccccc188888880000888818888888020088881aaa00000000aaaa1aaa00999900aaaa1bbbb000000bbbbb1bbbb033330bbbbb
1cc0000000000ccc1cc0011000000ccc188000000000088818800000022008881aa0000000000aaa1aa0099999900aaa1bbbb000000bbbbb1bbbb033330bbbbb
1c00000000000ccc1c00111111110ccc188000000000008818802222222200881a000000000000aa1a009999999900aa1bbbb000000bbbbb1bbbb033330bbbbb
1c00000000000ccc1c01111111110ccc188000000000008818802222222220881a000000000000aa1a000099990000aa1bbbb000000bbbbb1bbbb033330bbbbb
1c00000000000ccc1c01111111110ccc188000000000008818802222222220881aaaa000000aaaaa1aaaa099990aaaaa1b000000000000bb1b000033330000bb
1c00000000000ccc1c00111111110ccc188000000000008818802222222200881aaaa000000aaaaa1aaaa099990aaaaa1b000000000000bb1b003333333300bb
1cc0000000000ccc1cc0011000000ccc188000000000088818800000022008881aaaa000000aaaaa1aaaa099990aaaaa1bb0000000000bbb1bb0033333300bbb
1ccc0000cccccccc1ccc0010cccccccc188888880000888818888888020088881aaaa000000aaaaa1aaaa099990aaaaa1bbb00000000bbbb1bbb00333300bbbb
1cccc000cccccccc1cccc000cccccccc188888880008888818888888000888881aaaa000000aaaaa1aaaa000000aaaaa1bbbb000000bbbbb1bbbb003300bbbbb
1ccccc00cccccccc1ccccc00cccccccc188888880088888818888888008888881aaaaaaaaaaaaaaa1aaaaaaaaaaaaaaa1bbbbb0000bbbbbb1bbbbb0000bbbbbb
1ccccccccccccccc1ccccccccccccccc188888888888888818888888888888881aaaaaaaaaaaaaaa1aaaaaaaaaaaaaaa1bbbbbbbbbbbbbbb1bbbbbbbbbbbbbbb
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__sfx__
010400003415034000340003400034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400002815034000340003400034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400001c15034000340003400034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400001015034000340003400034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000345005450034500545003450004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
