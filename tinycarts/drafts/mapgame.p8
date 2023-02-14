pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	player = {}
	player.px = 2
	player.py = 2
end

function _update()
	move_player()
end

function _draw()
	cls()
	map(0,0,0,0,16,12)
	spr(1,player.px*8,player.py*8)

	for i = 1,#screen_text do
		print(screen_text[i],0,12*8+(i-1)*8,7)
	end
end
-->8
function move_player()
	-- save the old position
	oldpx = player.px
	oldpy = player.py
	move = false

	-- move according to button
	if (btnp(⬆️)) player.py -= 1 move = true
	if (btnp(⬇️)) player.py += 1 move = true 
	if (btnp(⬅️)) player.px -= 1 move = true
	if (btnp(➡️)) player.px += 1 move = true
	
	-- limit player to the map
	if move == true then
		player.px = mid(0,player.px,15)
		player.py = mid(0,player.py,11)
	
		tile = mget(player.px,player.py)

		-- if the tile is a wall, stop the player
		if fget(tile,0) == true then
			player.px = oldpx
			player.py = oldpy
		end
	
		-- if the tile has text, write text
		if fget(tile,1) == true then
			write_text(tile)
		end
	end
end



-->8
-- functions for writing text

screen_text = {}

tile_text = {}
tile_text[18] = "i am an apple"
tile_text[19] = "i am a pear"
tile_text[20] = "you cannot swim"
tile_text[21] = "hello! ♥"

function write_text(tile)

	add(screen_text,tile_text[tile])
	if #screen_text > 4 then
		del(screen_text,screen_text[1])
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700098998900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb3333bbbbbbbbbbbbbbbbbbccccccccbb44444b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb333333bbbbbb3bbbbbbbbbbccccccccbb4c4c4b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb333333bbbbb3bbbbbbbb3bbccccccccbb44444b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb334333bbbb88bbbbbbbb3bbccccccccbb44884b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb3443bbbb8888bbbbb99bbbccccccccbbbdddbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbb44bbbbb8888bbbb999bbbccccccccbb4ddd4b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbb44bbbbbb88bbbbb999bbbccccccccbbbdddbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccbb55b55b00000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000010202030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101110101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010111414101110121010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101414141410101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101414141410101010101310101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010111010101110101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101210101010101012101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010131010151010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010111010101011101010101310101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101510101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101110101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000