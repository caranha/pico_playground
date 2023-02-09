pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
// todo: neighbor birth
// todo: non-random tick option

function _init()
 bsize = 10
 ncell = 10
 simspeed = 2
 cd = 0
 board = {}
 mut_count = {0,0,0,0,0,0,0,0,0,0}
 tick = 0
 for i = 1,10 do
 	idx = flr(rnd()*ncell*ncell)
	 board[idx] = 5
 end
end


function _update()
	cd = cd - 1
	if (cd < 1) then
		cd = simspeed
		local idx = flr(rnd(ncell*ncell))+1
		tick = idx
		if board[idx] != nil and flr(rnd()*10) < board[idx] then
			local idx2 = flr(rnd(ncell*ncell))+1
			local gene = board[idx]
			
			if rnd() < 0.8 then
				if rnd() < 0.5 then
					gene = gene + 1
				else
					gene = gene - 1
				end
			end
			board[idx2] = mid(1,gene,10)
		end

		mut_count = {0,0,0,0,0,0,0,0,0,0}
		
		for idx = 1,ncell*ncell do
			if board[idx] != nil then
				mut_count[board[idx]] += 1
			end
		end 
	end
end

function drawboard(x,y)
	color()
	for i = 1, ncell*ncell do
		local x0 = x + ((i-1)%ncell) * bsize
		local y0 = y + flr((i-1)/ncell) * bsize 
		if tick == i then
			rectfill(x0, y0,
			         x0 + bsize,
			         y0 + bsize,
			         13)
		end
		rect(x0, y0,
		     x0 + bsize, y0 + bsize, 13)
	
		if board[i] != nil then
			pal(12,board[i])
			spr(1,x0+1,y0+1)
			pal()
		end
	end
end

function drawstats(x,y)
	local mean = 0
	local inds = 0
	local ptr = 1
	
	color()
	rect(x, y+6, x+102, y+12, 13)
	for i = 1,10 do
		mean += mut_count[i]*i
		inds += mut_count[i]
		if mut_count[i] > 0 then
			rectfill(x+ptr, y+7,
			         x+ptr+mut_count[i], y+11, i)
			ptr += mut_count[i]
		end
	end
	
	print("mean gene value:"..mean/inds, x+7, y, 13)
end

function _draw()
	cls()
	drawboard(5,5)
	drawstats(4,110)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cfccfc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000ccffcc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
