pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
p={11,3,5,2,8,10,8,2,5,3}
for i=0,15 do
	pal(i,p[(i+3)%#p+1])
end


s=sin
k=0::_::k+=0.01t=s(s(k))
for x=0,127 do for y=0,127 do
c=s(x/40+k*k)+s(y/80+k+t/10)
pset(x,y,c*2+t)
end end
flip()goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000