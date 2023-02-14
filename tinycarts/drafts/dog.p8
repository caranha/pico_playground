pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
end

function _update()
	updatedog()
	updatebark()
end

function _draw()
	cls()
	drawdog()
	drawbark()
end
-->8
-- state: 0 static, 1 walk
--        2 bark

dog = {x = 64, 
							y = 64,
							fl = false,
							s = 0,
							so = 0
							}

function updatedog()
	dog.so -= 1/30
	if (dog.so < 0) dog.s = 0

	if band(btn(),15) > 0 then
		dog.so = 0.2
		dog.s = 1
	end
	
 if (btn(0)) dog.x -= 2 fl = true
	if (btn(1)) dog.x += 2 fl = false
	if (btn(2)) dog.y -= 2
	if (btn(3)) dog.y += 2
	
--	if (btn(4)) 
end


function drawdog()
	local os = 0
	if (dog.s == 1) os = flr(t()*5%2)*2
		
	spr(1+os,dog.x, dog.y, 2, 2, fl)
end

function initbark()
end

function updatebark()
end

function drawbark()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007700000000000000000000000000000000000000000000000000000000000000
00700700000000000004400000000000000440000000000000004400000007000070000000000000000000000000000000000000000000000000000000000000
00077000000000000004100000000000000410000000000000004100000000700007000000000000000000000000000000000000000000000000000000000000
00077000400000000044444004000000004444400400000000044444000000070007000000000000000000000000000000000000000000000000000000000000
00700700400000000444444004000000044444400400000000444400000070070000700000000000000000000000000000000000000000000000000000000000
00000000400044444444444040004444444444400400004444444444000007007000700000000000000000000000000000000000000000000000000000000000
00000000444444444444000044444444444400000444444444444000007007007000700000000000000000000000000000000000000000000000000000000000
00000000044444444444000004444444444400000044444444444000007007007000700000000000000000000000000000000000000000000000000000000000
00000000000444444444000000044444444400000004444444440000000007007000700000000000000000000000000000000000000000000000000000000000
00000000000440000044000000044000004400000000440000440000000070070000700000000000000000000000000000000000000000000000000000000000
00000000000440000040000000044000044000000004400000400000000000070007000000000000000000000000000000000000000000000000000000000000
00000000004400000044000000004400440000000044000000440000000000700007000000000000000000000000000000000000000000000000000000000000
00000000004440000044400000004440444000000044400000444000000007000070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007700000000000000000000000000000000000000000000000000000000000000
