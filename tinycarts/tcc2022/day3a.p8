pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
pal({0,1,12,6,5,7},1)
a=128
function _draw()
k=t() x0=cos(k/2)*30 y0=sin(k/5+.2)*30
camera(x0,y0)
for x=x0,x0+a do for y=y0,y0+a do
			pset(x,y,
								(y+k*10&x)%6)
end end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00110011001100110011001100110011116611661166116611661166116611666600660066006600660066006600660000110011001100110011001100110011
001c001c001c001c001c001c001c001c1c651c651c651c651c651c651c651c6565006500650065006500650065006500001c001c001c001c001c001c001c001c
00006666000066660000666600006666111100001111000011110000111100006666111166661111666611116666111100006666000066660000666600006666
000065650000656500006565000065651c1c00001c1c00001c1c00001c1c000065651c1c65651c1c65651c1c65651c1c00006565000065650000656500006565
00116600001166000011660000116600116600111166001111660011116600116600116666001166660011666600116600116600001166000011660000116600
001c6500001c6500001c6500001c65001c65001c1c65001c1c65001c1c65001c65001c6565001c6565001c6565001c65001c6500001c6500001c6500001c6500
00000000111111110000000011111111111111116666666611111111666666666666666600000000666666660000000000000000111111110000000011111111
000000001c1c1c1c000000001c1c1c1c1c1c1c1c656565651c1c1c1c6565656565656565000000006565656500000000000000001c1c1c1c000000001c1c1c1c
00110011116611660011001111661166116611666600660011661166660066006600660000110011660066000011001100110011116611660011001111661166
001c001c1c651c65001c001c1c651c651c651c65650065001c651c656500650065006500001c001c65006500001c001c001c001c1c651c65001c001c1c651c65
00006666111100000000666611110000111100006666111111110000666611116666111100006666666611110000666600006666111100000000666611110000
000065651c1c0000000065651c1c00001c1c000065651c1c1c1c000065651c1c65651c1c0000656565651c1c00006565000065651c1c0000000065651c1c0000
00116600116600110011660011660011116600116600116611660011660011666600116600116600660011660011660000116600116600110011660011660011
001c65001c65001c001c65001c65001c1c65001c65001c651c65001c65001c6565001c65001c650065001c65001c6500001c65001c65001c001c65001c65001c
00000000000000006666666666666666111111111111111100000000000000006666666666666666111111111111111100000000000000006666666666666666
000000000000000065656565656565651c1c1c1c1c1c1c1c000000000000000065656565656565651c1c1c1c1c1c1c1c00000000000000006565656565656565
00110011001100116600660066006600116611661166116600110011001100116600660066006600116611661166116600110011001100116600660066006600
001c001c001c001c65006500650065001c651c651c651c65001c001c001c001c65006500650065001c651c651c651c65001c001c001c001c6500650065006500
00006666000066666666111166661111111100001111000000006666000066666666111166661111111100001111000000006666000066666666111166661111
000065650000656565651c1c65651c1c1c1c00001c1c0000000065650000656565651c1c65651c1c1c1c00001c1c0000000065650000656565651c1c65651c1c
00116600001166006600116666001166116600111166001100116600001166006600116666001166116600111166001100116600001166006600116666001166
001c6500001c650065001c6565001c651c65001c1c65001c001c6500001c650065001c6565001c651c65001c1c65001c001c6500001c650065001c6565001c65
00000000111111116666666600000000111111116666666600000000111111116666666600000000111111116666666600000000111111116666666600000000
000000001c1c1c1c65656565000000001c1c1c1c65656565000000001c1c1c1c65656565000000001c1c1c1c65656565000000001c1c1c1c6565656500000000
00110011116611666600660000110011116611666600660000110011116611666600660000110011116611666600660000110011116611666600660000110011
001c001c1c651c6565006500001c001c1c651c6565006500001c001c1c651c6565006500001c001c1c651c6565006500001c001c1c651c6565006500001c001c
00006666111100006666111100006666111100006666111100006666111100006666111100006666111100006666111100006666111100006666111100006666
000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c00006565
00116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600116600
001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c6500
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011
001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c
00006666000066660000666600006666000066660000666600006666000066660000666600006666000066660000666600006666000066660000666600006666
00006565000065650000656500006565000065650000656500006565000065650000656500006565000065650000656500006565000065650000656500006565
00116600001166000011660000116600001166000011660000116600001166000011660000116600001166000011660000116600001166000011660000116600
001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c6500
00000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111
000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c
00110011116611660011001111661166001100111166116600110011116611660011001111661166001100111166116600110011116611660011001111661166
001c001c1c651c65001c001c1c651c65001c001c1c651c65001c001c1c651c65001c001c1c651c65001c001c1c651c65001c001c1c651c65001c001c1c651c65
00006666111100000000666611110000000066661111000000006666111100000000666611110000000066661111000000006666111100000000666611110000
000065651c1c0000000065651c1c0000000065651c1c0000000065651c1c0000000065651c1c0000000065651c1c0000000065651c1c0000000065651c1c0000
00116600116600110011660011660011001166001166001100116600116600110011660011660011001166001166001100116600116600110011660011660011
001c65001c65001c001c65001c65001c001c65001c65001c001c65001c65001c001c65001c65001c001c65001c65001c001c65001c65001c001c65001c65001c
00000000000000006666666666666666000000000000000066666666666666660000000000000000666666666666666600000000000000006666666666666666
00000000000000006565656565656565000000000000000065656565656565650000000000000000656565656565656500000000000000006565656565656565
00110011001100116600660066006600001100110011001166006600660066000011001100110011660066006600660000110011001100116600660066006600
001c001c001c001c6500650065006500001c001c001c001c6500650065006500001c001c001c001c6500650065006500001c001c001c001c6500650065006500
00006666000066666666111166661111000066660000666666661111666611110000666600006666666611116666111100006666000066666666111166661111
000065650000656565651c1c65651c1c000065650000656565651c1c65651c1c000065650000656565651c1c65651c1c000065650000656565651c1c65651c1c
00116600001166006600116666001166001166000011660066001166660011660011660000116600660011666600116600116600001166006600116666001166
001c6500001c650065001c6565001c65001c6500001c650065001c6565001c65001c6500001c650065001c6565001c65001c6500001c650065001c6565001c65
00000000111111116666666600000000000000001111111166666666000000000000000011111111666666660000000000000000111111116666666600000000
000000001c1c1c1c6565656500000000000000001c1c1c1c6565656500000000000000001c1c1c1c6565656500000000000000001c1c1c1c6565656500000000
00110011116611666600660000110011001100111166116666006600001100110011001111661166660066000011001100110011116611666600660000110011
001c001c1c651c6565006500001c001c001c001c1c651c6565006500001c001c001c001c1c651c6565006500001c001c001c001c1c651c6565006500001c001c
00006666111100006666111100006666000066661111000066661111000066660000666611110000666611110000666600006666111100006666111100006666
000065651c1c000065651c1c00006565000065651c1c000065651c1c00006565000065651c1c000065651c1c00006565000065651c1c000065651c1c00006565
00116600116600116600116600116600001166001166001166001166001166000011660011660011660011660011660000116600116600116600116600116600
001c65001c65001c65001c65001c6500001c65001c65001c65001c65001c6500001c65001c65001c65001c65001c6500001c65001c65001c65001c65001c6500
00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000011111111111111111111111111111111
000000000000000000000000000000001c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c000000000000000000000000000000001c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c
00110011001100110011001100110011116611661166116611661166116611660011001100110011001100110011001111661166116611661166116611661166
001c001c001c001c001c001c001c001c1c651c651c651c651c651c651c651c65001c001c001c001c001c001c001c001c1c651c651c651c651c651c651c651c65
00006666000066660000666600006666111100001111000011110000111100000000666600006666000066660000666611110000111100001111000011110000
000065650000656500006565000065651c1c00001c1c00001c1c00001c1c0000000065650000656500006565000065651c1c00001c1c00001c1c00001c1c0000
00116600001166000011660000116600116600111166001111660011116600110011660000116600001166000011660011660011116600111166001111660011
001c6500001c6500001c6500001c65001c65001c1c65001c1c65001c1c65001c001c6500001c6500001c6500001c65001c65001c1c65001c1c65001c1c65001c
00000000111111110000000011111111111111116666666611111111666666660000000011111111000000001111111111111111666666661111111166666666
000000001c1c1c1c000000001c1c1c1c1c1c1c1c656565651c1c1c1c65656565000000001c1c1c1c000000001c1c1c1c1c1c1c1c656565651c1c1c1c65656565
00110011116611660011001111661166116611666600660011661166660066000011001111661166001100111166116611661166660066001166116666006600
001c001c1c651c65001c001c1c651c651c651c65650065001c651c6565006500001c001c1c651c65001c001c1c651c651c651c65650065001c651c6565006500
00006666111100000000666611110000111100006666111111110000666611110000666611110000000066661111000011110000666611111111000066661111
000065651c1c0000000065651c1c00001c1c000065651c1c1c1c000065651c1c000065651c1c0000000065651c1c00001c1c000065651c1c1c1c000065651c1c
00116600116600110011660011660011116600116600116611660011660011660011660011660011001166001166001111660011660011661166001166001166
001c65001c65001c001c65001c65001c1c65001c65001c651c65001c65001c65001c65001c65001c001c65001c65001c1c65001c65001c651c65001c65001c65
00000000000000006666666666666666111111111111111100000000000000000000000000000000666666666666666611111111111111110000000000000000
000000000000000065656565656565651c1c1c1c1c1c1c1c0000000000000000000000000000000065656565656565651c1c1c1c1c1c1c1c0000000000000000
00110011001100116600660066006600116611661166116600110011001100110011001100110011660066006600660011661166116611660011001100110011
001c001c001c001c65006500650065001c651c651c651c65001c001c001c001c001c001c001c001c65006500650065001c651c651c651c65001c001c001c001c
00006666000066666666111166661111111100001111000000006666000066660000666600006666666611116666111111110000111100000000666600006666
000065650000656565651c1c65651c1c1c1c00001c1c00000000656500006565000065650000656565651c1c65651c1c1c1c00001c1c00000000656500006565
00116600001166006600116666001166116600111166001100116600001166000011660000116600660011666600116611660011116600110011660000116600
001c6500001c650065001c6565001c651c65001c1c65001c001c6500001c6500001c6500001c650065001c6565001c651c65001c1c65001c001c6500001c6500
00000000111111116666666600000000111111116666666600000000111111110000000011111111666666660000000011111111666666660000000011111111
000000001c1c1c1c65656565000000001c1c1c1c65656565000000001c1c1c1c000000001c1c1c1c65656565000000001c1c1c1c65656565000000001c1c1c1c
00110011116611666600660000110011116611666600660000110011116611660011001111661166660066000011001111661166660066000011001111661166
001c001c1c651c6565006500001c001c1c651c6565006500001c001c1c651c65001c001c1c651c6565006500001c001c1c651c6565006500001c001c1c651c65
00006666111100006666111100006666111100006666111100006666111100000000666611110000666611110000666611110000666611110000666611110000
000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c0000000065651c1c000065651c1c000065651c1c000065651c1c000065651c1c0000
00116600116600116600116600116600116600116600116600116600116600110011660011660011660011660011660011660011660011660011660011660011
001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c001c65001c65001c65001c65001c65001c65001c65001c65001c65001c65001c
00000000000000000000000000000000000000000000000000000000000000006666666666666666666666666666666666666666666666666666666666666666
00000000000000000000000000000000000000000000000000000000000000006565656565656565656565656565656565656565656565656565656565656565
00110011001100110011001100110011001100110011001100110011001100116600660066006600660066006600660066006600660066006600660066006600
001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c001c6500650065006500650065006500650065006500650065006500650065006500
00006666000066660000666600006666000066660000666600006666000066666666111166661111666611116666111166661111666611116666111166661111
000065650000656500006565000065650000656500006565000065650000656565651c1c65651c1c65651c1c65651c1c65651c1c65651c1c65651c1c65651c1c
00116600001166000011660000116600001166000011660000116600001166006600116666001166660011666600116666001166660011666600116666001166
001c6500001c6500001c6500001c6500001c6500001c6500001c6500001c650065001c6565001c6565001c6565001c6565001c6565001c6565001c6565001c65
00000000111111110000000011111111000000001111111100000000111111116666666600000000666666660000000066666666000000006666666600000000
000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c000000001c1c1c1c6565656500000000656565650000000065656565000000006565656500000000
00110011116611660011001111661166001100111166116600110011116611666600660000110011660066000011001166006600001100116600660000110011
001c001c1c651c65001c001c1c651c65001c001c1c651c65001c001c1c651c6565006500001c001c65006500001c001c65006500001c001c65006500001c001c
00006666111100000000666611110000000066661111000000006666111100006666111100006666666611110000666666661111000066666666111100006666
000065651c1c0000000065651c1c0000000065651c1c0000000065651c1c000065651c1c0000656565651c1c0000656565651c1c0000656565651c1c00006565
00116600116600110011660011660011001166001166001100116600116600116600116600116600660011660011660066001166001166006600116600116600
001c65001c65001c001c65001c65001c001c65001c65001c001c65001c65001c65001c65001c650065001c65001c650065001c65001c650065001c65001c6500
00000000000000006666666666666666000000000000000066666666666666666666666666666666111111111111111166666666666666661111111111111111
000000000000000065656565656565650000000000000000656565656565656565656565656565651c1c1c1c1c1c1c1c65656565656565651c1c1c1c1c1c1c1c
00110011001100116600660066006600001100110011001166006600660066006600660066006600116611661166116666006600660066001166116611661166
001c001c001c001c6500650065006500001c001c001c001c650065006500650065006500650065001c651c651c651c6565006500650065001c651c651c651c65
00006666000066666666111166661111000066660000666666661111666611116666111166661111111100001111000066661111666611111111000011110000
000065650000656565651c1c65651c1c000065650000656565651c1c65651c1c65651c1c65651c1c1c1c00001c1c000065651c1c65651c1c1c1c00001c1c0000
00116600001166006600116666001166001166000011660066001166660011666600116666001166116600111166001166001166660011661166001111660011
001c6500001c650065001c6565001c65001c6500001c650065001c6565001c6565001c6565001c651c65001c1c65001c65001c6565001c651c65001c1c65001c
00000000111111116666666600000000000000001111111166666666000000006666666600000000111111116666666666666666000000001111111166666666
000000001c1c1c1c6565656500000000000000001c1c1c1c656565650000000065656565000000001c1c1c1c6565656565656565000000001c1c1c1c65656565
00110011116611666600660000110011001100111166116666006600001100116600660000110011116611666600660066006600001100111166116666006600
001c001c1c651c6565006500001c001c001c001c1c651c6565006500001c001c65006500001c001c1c651c656500650065006500001c001c1c651c6565006500
00006666111100006666111100006666000066661111000066661111000066666666111100006666111100006666111166661111000066661111000066661111
000065651c1c000065651c1c00006565000065651c1c000065651c1c0000656565651c1c000065651c1c000065651c1c65651c1c000065651c1c000065651c1c
00116600116600116600116600116600001166001166001166001166001166006600116600116600116600116600116666001166001166001166001166001166
001c65001c65001c65001c65001c6500001c65001c65001c65001c65001c650065001c65001c65001c65001c65001c6565001c65001c65001c65001c65001c65
00000000000000000000000000000000111111111111111111111111111111116666666666666666666666666666666600000000000000000000000000000000
000000000000000000000000000000001c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c6565656565656565656565656565656500000000000000000000000000000000

