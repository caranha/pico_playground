pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- ai for connect4
-- by caranha

gamestate = 1

function _init()
	gameboard = new_game()

	-- set p1 and p2 on ai_cofun below.
		
	--random_coro -- random player
	--random_winlose_coro -- random, plays winning moves, avoid losing moves
	--ai_wincounter -- random plays for .6 seconds, counts the victory of every move, plays highest victory
	--ai_mcts -- implements mcts
	--player_ai -- player chooses the move
	
 ai_cofun = {ai_mcts,ai_mcts}
end

function _update()
	update_player()
end

function advance_state()
	-- 1 p1, 2 trans, 3 p2, 4 trans, 5 game over
	if (gameboard.move == 49) gamestate = 5 return
	if (gameboard.win != 0) gamestate = 5 return
	if (gamestate == 1) gamestate = 3 return
	if (gamestate == 3) gamestate = 1 return
end

function _draw()
	cls()
	draw_player(0,10)
	draw_board(gameboard,0,10,1)
	if (think_board != nil) draw_board(think_board,100,10,0.3)


	local win = {"","red win","blue win"}
	print(win[gameboard.win+1],0,100,7)


	if win_count != nil then
		for i = 1,7 do
			print(win_count[i],75,10+8*i)
		end
	end

	print(stat(0)/2048,104,114,10)
	print(stat(1),104,120,10)
  
	do_ai(ceil(gamestate/2))
end
-->8
-- game engine

function new_game()
	local board = {}
	for i = 1,7 do
		board[i] = {0,0,0,0,0,0,0}
	end
	return {board = board,turn=1,win=0,move=0}
end

function copy_board(b)
	local bb = {turn = b.turn, win = b.win, move = b.move}
	bb.board = {{},{},{},{},{},{},{}}
	for i = 1,7 do
		for j = 1,7 do
			bb.board[i][j] = b.board[i][j]
		end
	end

	return bb
end

function play(board,move,player)
	if (player != board.turn) return false
	for i = 1,7 do
		if board.board[move][i] == 0 then
			board.board[move][i] = player
			board.win = testwin(board.board,move,i)
			board.turn = (player) % 2 + 1
			board.move += 1
			return true
		end
	end
	return false
end

function testvalid(b,m)
	if (m == nil) return false
	return (b.board[m][7] == 0 and true or false)
end

function testwin(b,c,r)
	local d = {{-1,-1},{-1,0},{0,-1},{1,-1}}
	local col = b[c][r]
	if (col == 0) return(0)

	for i = 1,#d do
		local sum = 0
		local j = 1
		while j < 4 and testcolor(b,c+d[i][1]*j,r+d[i][2]*j,col) do
			sum += 1
			j += 1
		end
		j = -1
		while j > -4 and testcolor(b,c+d[i][1]*j,r+d[i][2]*j,col) do
			sum += 1
			j -= 1
		end
		if (sum > 2) return col
	end
	return 0
end

function testcolor(b,c,r,col)
	if (mid(1,r,7) != r or mid(1,c,7) != c) return false
	return (b[c][r] == col)
end


function draw_board(board,xo,yo,size)
 -- size is (70 by 70)*size
	rectfill(xo,yo,xo+70*size,yo+70*size,5)
	bd = board.board
	
	local c = {0,8,12}
	for i = 1,7 do
		for j = 1,7 do
			circfill(xo+10*size*(i-1)+5*size,yo+10*size*(j-1)+5*size,3*size,c[bd[i][8-j]+1])
		end
	end
end

function rollout_random(rb)
	while rb.move < 49 and rb.win == 0 do
		local m = flr(rnd(7)+1)
		play(rb,m,rb.turn)
		if (rb.win != 0) return rb.win
	end
	return rb.win
end



-->8
-- player gui

player_state = 1
player_on = 0
player_move = nil

function draw_player(ox,oy)
	if (player_on == 0) return
	spr(1,ox+1+(player_state-1)*10,oy-8)
end

function update_player()
	if (player_on == 0) return
	if (btnp(⬅️)) player_state = max(1,player_state-1)
	if (btnp(➡️)) player_state = min(7,player_state+1)
	if (btnp(⬇️)) then 
		if testvalid(gameboard,player_state) then
			player_move = player_state
		end			
	end	
end
-->8
-- ai

cmove = nil
ai_coro = nil
ai_time = 20
ai_cd = 0
think_board = nil

function do_ai(n)
	if (gamestate != 1 and gamestate!= 3) return
	if (ai_coro == nil) then
		ai_cd = ai_time
		ai_coro = cocreate(ai_cofun[n])
		cmove = nil
	end
	
	if cmove != nil and (costatus(ai_coro) == "dead" or ai_cd < 0) then
		play(gameboard,cmove,gameboard.turn)
		ai_coro = nil
		advance_state()
	else
		ai_cd -= 1
		--assert(coresume(ai_coro,ai_cd))
		coresume(ai_coro,ai_cd)
	end
end

function player_ai()
	player_move = nil
	player_on = 1
	while true do
		if player_move != nil then
			player_on = 0
			cmove = player_move
			return
		end
	end
end

function random_coro()
	while cmove == nil do
		local m = flr(rnd(7)+1)
		if (testvalid(gameboard,m)) cmove = m
	end	
end

function random_winlose_coro()
	local badmove = {}
	for i = 1,7 do -- see if i win
		local b = copy_board(gameboard)
		play(b,i,b.turn)
		if b.win != 0 then 
			cmove = i
		else
			for j = 1,7 do -- see if i lose
				local bb = copy_board(b)
				play(bb,j,bb.turn)
				if (bb.win != 0) badmove[i] = true
			end
		end
	end

	local count = 0
	while cmove == nil do
		m = flr(rnd(7)+1)
		if (testvalid(gameboard,m) and (count > 500 or not badmove[m])) cmove = m
		count += 1
	end	
end

function ai_wincounter()
	win_count = {0,0,0,0,0,0,0}
	local maxmove = flr(rnd(7)+1)
		
	for i = 1,7 do -- see if i win
		local b = copy_board(gameboard)
		if (play(b,i,b.turn) == false) win_count[i] -= 7000
		if (b.win != 0) win_count[i] += 2000
	end

	while(true) do
		for i = 1,7 do
			if (win_count[i] > win_count[maxmove]) maxmove = i
		end
		cmove = maxmove
		local test = flr(rnd(7)+1)
		local rb = copy_board(gameboard)
		play(rb,test,rb.turn)
		think_board = rb
		local result = rollout_random(rb)
		if (result == gameboard.turn) win_count[test] += 1
	end

end

mcts_c = sqrt(2)
function ai_mcts()
	local b = copy_board(gameboard)
 local root = new_mcts_node(b)
 local maxmove = 1
 local maxcount = 0
 win_count = {0,0,0,0,0,0,0}
 
	while cmove == nil do
		local m = flr(rnd(7)+1)
		if (testvalid(gameboard,m)) cmove = m
	end
	
	while true do
 	mcts_select(root)
		if root.visits > 7 then
		 maxcount = 0
			for i = 1,7 do
				win_count[i] = (root.children[i] == nil and -1 or root.children[i].win)
				if (win_count[i] > maxcount) maxcount = win_count[i] maxmove = i
			end
			cmove = maxmove
		end
 end
end

function mcts_select(node)
	local score_i = 1
	local maxscore = 0
	local result = 0
	node.visits += 1
	
	-- end nodes
	if node.state.win != 0 then
		node.win += (node.state.win == (node.state.turn%2+1)	and 1 or 0)
		return node.state.win
	end
	if (node.state.moves == 49) return 0
	
	-- explore a new node
	for i = 1,7 do
		if node.children[i] == nil then
			local newstate = copy_board(node.state)
			if play(newstate,i,newstate.turn) then
			  node.children[i], result = new_mcts_node(newstate)
  			node.win += (result == node.state.turn	and 1 or 0)
  			return result
  	end
		else
			local cn = node.children[i]
			local c_score = cn.win/cn.visits + mcts_c*sqrt(log2(node.visits)/cn.visits)
			if (c_score > maxscore) maxscore = c_score score_i = i
		end
	end
	
	local result = mcts_select(node.children[score_i])
 node.win += (result == (node.state.turn%2+1)	and 1 or 0)
 return result	
end

function new_mcts_node(b)
	local node = {}
	node.visits = 1
	node.state = b
	local rol_b = copy_board(b)
	local rol_result = rollout_random(rol_b)
	think_board = rol_b
	node.win = (rol_result == (b.turn%2)+1 and 1 or 0)
	node.children = {}
	return node, rol_result
end

-->8
-- utils
log2_t = {0,0.1375,0.2630,
     0.3785,0.4854,0.5849,
     0.6780,0.7655,0.8479,
     0.9259,1}

function log2(n)
 -- http://pico-8.wikia.com/wiki/math
 -- "good enough"
 if (n < 1) return nil
 local t = 0
 while n > 2 do
  n /= 2
  t += 1
 end
 return log2_t[flr((n-0.95)*10)+1] + t
end

function noop() end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
