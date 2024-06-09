pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function _init()
  palt(8, true)
  palt(0, false)
  x = 0 
  y = 57
	music(01)
  tock = false
  coins = {}
  bombs = {}
  score = 0
  fail = false
	jump = {}
  jump.in_progress = false
  jump.falling = false
  level = 0
  -- platx = 8 * 58
  -- platxmin = 8 * 56
  -- plaxmax = 8 * 62
  -- platy = 8 * 9
  platx =  40
  platxmin =  30
  plaxmax =  62
  platy =  70
  right = true
end

function _update()
  number_of_coins = 0
  for _ in pairs(coins) do number_of_coins = number_of_coins + 1 end

  number_of_bombs = 0
  for _ in pairs(bombs) do number_of_bombs = number_of_bombs + 1 end


  

  if (platx + 1) <= plaxmax and right then
    platx += 1
    if riding then
      x +=1
    end
  elseif platx == plaxmax and right then
    right = false
    platx = platx - 1
  elseif (platx - 1) >= platxmin and not right then
    if riding then
      x = x - 1
    end
    platx = platx - 1
  elseif platx == platxmin then
    right = true
  end
  

  if (btn(0)) and mget(((x + 0) / 8), (y + 10) / 8) != 002 and x > -1 then 
    x = x - 1 
  end

  if (btn(1)) and (mget(((x - 1) / 8) + 1, (y + 10) / 8) != 002 and x <= 248 or mget(((x - 1) / 8) + 1, (y + 10) / 8) != 002 and x >= 248) and (mget(((x - 1) / 8) + 1, (y + 10) / 8) != 032) then 
    x = x + 1 
  end

  if (btn(2)) and not jump.in_progress then 
    jump.in_progress = true
    jump.target = y - 16
  end

  -- if (btn(3)) then 
  --   fail = true
  -- end

   if (mget(((x + 0) / 8), (y + 10) / 8) == 009) then
    sfx(008)
  end
 
  if (mget(((x + 0) / 8), (y + 10) / 8) == 009) then
    sfx(008)
    music(-1)
    for x=4,124 do
      flip()
    end
    platx = 8 * 58
    platxmin = 8 * 56
    plaxmax = 8 * 62
    platy = 8 * 9
    x = x + 8
    y = 0
    level = 1
    camera(256, 0)
    music(06)
    return
  end
 

  riding = platx > (x - 5) and platx < (x + 5) and platy >= (y - 8) and platy < (y + 5)

  on_ground = mget((x + 2) / 8,((y - 4) / 8) + 1) == 003 or mget((x + 2) / 8,((y - 4) / 8) + 1) == 009 or mget((x + 2) / 8,((y - 4) / 8) + 1) == 033 or riding or mget((x + 2) / 8,((y - 4) / 8) + 1) == 025

  if jump.in_progress and not jump.falling and y > jump.target then
    y = y - 2
  elseif jump.in_progress and not jump.falling and y <= jump.target then
    jump.falling = true
  elseif jump.falling and on_ground then
    jump = {}
  elseif jump.falling then
    y = y + 2
  end

  if not on_ground and not jump.in_progress then
    y = y + 2
  end

  if time() % 0.5 == 0 then
    tock = not tock
  end

  if y > 128 then
    fail = true
  end

end
 
function _draw()


  if fail then
    cls()
    music(-1)
    camera(x, -64)
    print("fail", x, 0, 3)

    print("score: " .. (score - 1))
    return
    
  end

  cls()
  




  if x > 64 and x < 192 or (x > 320) then 
    camera(x - 64, 0)
  end
  -- map(32 * level, 0, 0, 0, 128, 32)
  map()





  if tock then
    spr(001,x,y)
  else
    spr(001,x,y)
  end

  spr(34, platx, platy)

  for c in all(coins) do
    spr(007, c.x, c.y)
  end

  for b in all(bombs) do
    spr(008, b.x, b.y)
  end

  for b in all(bombs) do
    b.y += 1


    if b.x > (x - 5) and b.x < (x + 5) and b.y >= (y - 8) and b.y < (y) then
      sfx(7)
      del(bombs, b)
      score += 1
      fail = true
    end

    if b.y > 100 then
      del(bombs, b)
    end
  end

  for c in all(coins) do
    c.y += 1


    if c.x > (x - 5) and c.x < (x + 5) and c.y >= (y - 8) and c.y < (y + 8) then
      sfx(5)
      del(coins, c)
      score += 1
    end

    if c.y > 100 then
      del(coins, c)
    end
  end

end

__gfx__
000000008088880894444494bbbbbbbb11111111cccccccccccccccc0000000000000a00ccaaa9ccbcccccccc806666080000000000000000000000000000000
000000008877778844494444bbabbbab11111111cccccccccccccccc000a90000000d000ccca9cccbcccccccc867777680700070000000000000000000000000
007007008807708844444494abbbbbbb5555555555555555cccccccc00aa990000666500ccca9cccbcccccccc860770680000000000000000000000000000000
000770008870078849449444bbbbbbbb11111111cccccccccccccccc0aaaa99006666650c444445cbcccccccc867007680000000000000000000000000000000
000770008000000844444444bbbbbabb55555555cccccccccccccccc0aaaa99006666650c444445cbcccccccc866666680000700000000000000000000000000
007007008877778844944444bbbbbbbb55555555cccccccccccccccc0aaaa99006666650c555555cbcc9669cc686936860000000000000000000000000000000
00000000887777889444944933333333cccccccccccccccccccccccc00aaa90006666550bbbbbbbb3caa99aac886666880700000000000000000000000000000
0000000088088088444444443333333355555555cccccccccccccccc000a900000555500333333333aaaaaaaa885885880000007000000000000000000000000
665656665565555500888800008888001111111111111111cccccccccccccccccccccccc33333333555555555555555555555555500000000000000000000000
566666565665656508777780087777801111111111111a11cccccccccccccccccccccccc33933393111111111111111111111111100000000000000000000000
66666666555555550877778008777780111111111a111111cccccccccc7777cccccccccc93333333111111111111111111111111100000000000000000000000
5666566655555556008888000a8888a01111111111111111ccccccccc7777777c7777ccc33333333111111111111111111111111100000000000000000000000
66666666565565550908809000088000111111111111a111ccccccccc7777777777777cc33333933111111111111111111111111100000000000000000000000
566565665555555500888800a088880a1111111111111111cccc7777c7777777777777cc33333333111111111111111111111111100000000000000000000000
111111115565556590088009a008800a1111111111111111ccc77777777777777666777c11111111111111111111111111111110100000000000000000000000
1111111155655555902a020a002902001111111111111111ccc77777777777776777677711111111111111111111111111111100000000000000000000000000
55555554aaaaaaaa888888880000000094444494111111a1cc777777777777767777767711117711111111111111111111111000000000000000000000000000
54554555aa6aaaaa88888888000000004449444411a11111cc777777777777777777767711776111111111111111111111111000000000000000000000000000
55555555aaaaa6aa88888888000000004444449411111111cc777777777777777777667c17777111111111111111111111111000000000000000000000000000
55554555aaaaaaaa88888888000000004944944411111111cc77777777777777777677cc17767111111111111111111111110000000000000000000000000000
54555555aaaaaaa666666666000000005555555511111111ccc776666777766666677ccc17777111155555111111111111110000000000000000000000000000
55555554aa6aaaaa8688886800000000cccccccc11111111ccccc777777777777777cccc17777111555555555511111111000000000000000000000000000000
54554555999999996666666600000000cccccccc1111111acccccccccccccccccccccccc11767111555555555555111100000000000000000000000000000000
55555555999999998688886800000000cccccccc1a111111cccccccccccccccccccccccc11117711555555555555011000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555500000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555555500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555555550000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000555555555555555555500000000000000000000000000000
00000000000000000000000000066000000000000000000000000000000000000000000000000000555555555555555555550000000000000000000000000000
00000000000000600000000000066000000000000000000000000000000000000000000000000000555555555555555555555555500000000000000000000000
00000000000000000000000000066000000000000000000000000000000000000000000000000000555555555555555555555555500000000000000000000000
00000000000000000000000000066000000000000000000000000000000000000000000000000000555555555555555555555555500000000000000000000000
00000000000000000000000066666000000000000000000000000000000000000000000000000000000000000555555555555555500000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000bb000000000555555555555555500000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000bbbbbb000000000555555555555555500000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000cbbbbbbbb000000000555555555555555500000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000cccbbbbbbbb000000000555555555555555500000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000cccccbbbbbbbb000000000555555555555555500000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000ccccccccbbbbbbbc00000000555555555555555500000000000000000000000
00c0000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccc000000555555555555555500000000000000000000000
0cc0000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc0000000000000000000000000000000000000000000
ccc0000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccc000000000000000000000000000000000000000000
ccc000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccc00000000000000000000000000000000000000000
ccc0000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccc0000000000000000000000000000000000000000
ccc000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccc0000000000000000000000000000000000000000
ccc00000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccc0000000000000000000000000000000000000000
ccc00000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccc0000000000000000000000000000000000000000
ccc0000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccc0000000000000000000000000000000000000000
ccc000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000
ccc00000000000000000000000000000000000000000000000000000cccccccccbbccccccccccccccccccccc0000000000000000000000000000000000000000
ccb0000000000000000000000000000000000000000000000000000cccccccccbbbbbccccccccccccccccccc0000000000000000000000000000000000000000
bbb0000000000000000000000000000000000000000000000000000ccccccccbbbbbbbcccccccccccbbbcccc0000000000000000000000000000000000000000
bbb000000000000000000000000000000000000000000000000000cccccccccbbbbbbbccccccccccbbbbcccc0000000000000000000000000000000000000000
bbb000000000000000000000000000000000000000000000000000cccccccccbbbbbbbccccccccccbbbbbccc0000000000000000000000000000000000000000
bbb00000000000000000000000000000000000000000000000000ccccccccccbbbbbbcccccccccccbbbbbbbb0000000000000000000000000000000000000000
bbb0000000000000000000000000000000000000000000000000cccccccccccbbbbbbcccccccccccbbbbbbbb0000000000000000000000000000000000000000
bbb0000000000000000000000000000000000000000000000000cccccccccccbbbbbccccccccccccbbbbbbbb0000000000000000000000000000000000000000
bbb0000000000000000000000000000000000000000000000000ccccccccccbbbbbcccccccccccccbbbbbbbb0000000000000000000000000000000000000000
bbb000000000000000000000000000000000000000000000000cccccccccccbbbbccccccccccccccbbbbbbbb0000000000000000000000000000000000000000
bbb000000000000000000000000000000000000000000000000cccccccccccbbbcccccccccccccccbbbbbbbb0000000000000000000000000000000000000000
ccc00000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccbbbbbbbb0000000000000000000000000000000000000000
ccc00000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccbbbbbbbb0000000000000000000000000000000000000000
ccc00000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccbbbbbbbb0000000000000000000000000000000000000000
ccc00000000000000000000000000000000bbbbbbbbbbbbb0cccccccccccccccccccccccccccccccbbbbbbbb0000000000000000000000000000000000000000
ccc00000000000000000000000000000000bbbbbbbbbbbbb0ccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000bbbbbbbbbbbbb0ccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000cbbbbbbbbbbbb0ccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000cbbbbbbbbbbbb0ccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000bbbbbbbbbbbbb00cccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000cc000000000000000000000000000000000000000000000000000000000cc00000000000000000000000000000000
00000000000000000000000000000000000ccc000ccc0000000000000000000000c00000000000000000000000000ccc00000000000000000000000000000000
00000000000000000000000000000000000ccccccccc0000000000000000000000cc000000000000000000000000cccc00000000000000000000000000000000
0cc00000000000000000000000000000000cccccccccc0000000000000000000c000c00000000000000000000000cccc00000000000000000000000000000000
0cc00000000000000000000000000000000ccccccccccccc0000000000000000c00c000000000000000000000000cccc00000000000000000000000000000000
00000000000000000000000000000000000ccccccccccccc000000000000000000cc00000000000000000000000ccccc00000000000000000000000000000000
ccc00000000000000000000000000000000ccccccccccccc0000000000000000ccc0000000000000000000000ccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000ccccccccccccc0000000000000000cc00000000000000000000cccccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000ccccccccccccc0000000000000000c00000000000000000000ccccccccccc00000000000000000000000000000000
ccc00000000000000000000000000000000ccccccccccccc000000000000000c000000000000000000000ccccccccccc00000000000000000000000000000000
00000000000000000000000000000000000ccccccccccccc0000000000000000000000000000000000000ccccccccccc00000000000000000000000000000000
00000000000000000000000000000000000ccccccccccccc0000000000000000000000000000000000000ccccccccccc00000000000000000000000000000000
00000000000000000000000000000000000ccccccccccccc0000000000000000000000000000000000000ccccccccccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc0000000000000000000000000000000000000000ccccccccccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc00000000000000000000000000000000000000000cccccccccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc000000000000000000000000000000000000000000ccccccccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc0000000000000000000000000000000000000000000000ccccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc00000000000000000000000000000000000000000000000cccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc00000000000000000000000000000000000000000000000cccc00000000000000000000000000000000
00000000000000000000000000000000ccccccccccccc00000000000000000000000000000000000000000000000cccc00000000000000000000000000000000
__label__
66611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
66655555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
61111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
66655555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccca9cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccaa99ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccca9cccccccccccccccc
ccccccccccccccccccccccccccccccccaaaa99cccccccccccccccccccc7777cccc7777cccccccccccccccccccccccccccccccccccccccaa99ccccccccccccccc
ccccccccccccccccccccccccccccccccaaaa99ccccccccccccccccccc7777777777777ccccccccccccccccccccccccccccccccccccccaaaa99cccccccccccccc
ccccccccccccccccccccccccccccccccaaaa99ccccccccccccccccc777777777777777ccccccccccccccccccccccccccccccccccccccaaaa99cccccccccccccc
cccccccccccccccccccccccccccccccccaaa9cccccccccccccccc77777777777777777ccccccccccccccccccccccccccccccccccccccaaaa99cccccccccccccc
cccccccccccccccccccccccccccccccccca9ccccccccccccccc77777777777777777777ccccccccccccccccccccccccccccccccccccccaaa9ccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccc777777777777777777777cccccccccccccccccccccccccccccccccccccca9cccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccc7777777777777777767ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccc777777777777777767ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccc77777777777777766cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccc7777777777777677cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccc77777777766677ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccc777777777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbabbbabcccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccabbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbabbcccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbcccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc33333333cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc33333333cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc94444494cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc44494444cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc44444494cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc49449444cccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccc8888ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc44444444cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccc877778cccccccccccccccccccccccccccccccccccccccccccccccccccccccc44944444cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccc877778cccccccccccccccccccccccccccccccccccccccccccccccccccccccc94449449cccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccc8888ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc44444444cccccccccccccccccccccccccccccccccccccccccccccccc
bbbbbbbbbbbb88bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccc94444494ccccccccccccccccbbbbbbbbbbbbbbbbcccccccccccccccc
bbabbbabbba8888bbbabbbabbbabbbabbbabbbabbbabbbabcccccccccccccccccccccccc44494444ccccccccccccccccbbabbbabbbabbbabcccccccccccccccc
abbbbbbbabbb88bbabbbbbbbabbbbbbbabbbbbbbabbbbbbbcccccccccccccccccccccccc44444494ccccccccccccccccabbbbbbbabbbbbbbcccccccccccccccc
bbbbbbbbbbbb22bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccc49449444ccccccccccccccccbbbbbbbbbbbbbbbbcccccccccccccccc
bbbbbabbbbbbbabbbbbbbabbbbbbbabbbbbbbabbbbbbbabbcccccccccccccccccccccccc44444444ccccccccccccccccbbbbbabbbbbbbabbcccccccccccccccc
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccc44944444ccccccccccccccccbbbbbbbbbbbbbbbbcccccccccccccccc
333333333333333333333333333333333333333333333333cccccccccccccccccccccccc94449449cccccccccccccccc3333333333333333cccccccccccccccc
333333333333333333333333333333333333333333333333cccccccccccccccccccccccc44444444cccccccccccccccc3333333333333333cccccccccccccccc
944444949444449494444494944444949444449494444494cccccccccccccccccccccccc94444494cccccccccccccccc9444449494444494bbbbbbbbcccccccc
444944444449444444494444444944444449444444494444cccccccccccccccccccccccc44494444cccccccccccccccc4449444444494444bbabbbabcccccccc
444444944444449444444494444444944444449444444494cccccccccccccccccccccccc44444494cccccccccccccccc4444449444444494abbbbbbbcccccccc
494494444944944449449444494494444944944449449444cccccccccccccccccccccccc49449444cccccccccccccccc4944944449449444bbbbbbbbcccccccc
444444444444444444444444444444444444444444444444cccccccccccccccccccccccc44444444cccccccccccccccc4444444444444444bbbbbabbcccccccc
449444444494444444944444449444444494444444944444cccccccccccccccccccccccc44944444cccccccccccccccc4494444444944444bbbbbbbbcccccccc
9444944994449449944494499444944994449449944494a9cccccccccccccccccccccccc94449449cccccccccccccccc944494499444944933333333cccccccc
444444444444444444444444444444444444444444444aa99ccccccccccccccccccccccc44444444cccccccccccccccc444444444444444433333333cccccccc
94444494944444949444449494444494944444949444aaaa99bbbbbbbbbbbbbbbbbbbbbb94444494bbbbbbbbbbbbbbbb944444949444449494444494bbbbbbbb
44494444444944444449444444494444444944444449aaaa99abbbabbbabbbabbbabbbab44494444bbabbbabbbabbbab444944444449444444494444bbabbbab
44444494444444944444449444444494444444944444aaaa99bbbbbbabbbbbbbabbbbbbb44444494abbbbbbbabbbbbbb444444944444449444444494abbbbbbb
494494444944944449449444494494444944944449449aaa9bbbbbbbbbbbbbbbbbbbbbbb49449444bbbbbbbbbbbbbbbb494494444944944449449444bbbbbbbb
4444444444444444444444444444444444444444444444a9bbbbbabbbbbbbabbbbbbbabb44444444bbbbbabbbbbbbabb444444444444444444444444bbbbbabb
449444444494444444944444449444444494444444944444bbbbbbbbbbbbbbbbbbbbbbbb44944444bbbbbbbbbbbbbbbb449444444494444444944444bbbbbbbb
94449449944494499444944994449449944494499444944933333333333333333333333394449449333333333333333394449449944494499444944933333333
44444444444444444444444444444444444444444444444433333333333333333333333344444444333333333333333344444444444444444444444433333333
94444494944444949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494944444949444449494444494
44494444444944444449444444494444444944444449444444494444444944444449444444494444444944444449444444494444444944444449444444494444
44444494444444944444449444444494444444944444449444444494444444944444449444444494444444944444449444444494444444944444449444444494
49449444494494444944944449449444494494444944944449449444494494444944944449449444494494444944944449449444494494444944944449449444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44944444449444444494444444944444449444444494444444944444449444444494444444944444449444444494444444944444449444444494444444944444
94449449944494499444944994449449944494499444944994449449944494499444944994449449944494499444944994449449944494499444944994449449
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0404040404040404040404040404040404040404040404040404040404040404141414141414141414141414141414141414141414141414141414141414251414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050505050505050505050505050505050505141414141414141414141414141414141414141414141414141414142515251414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050505050505050505050505050505050505141414141414141414141414141414141414141414141414141414142525151414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606061617180606060606060606060606060606060606060606060606141414141414141414141414141429141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606062627280606060606060606060606060606060606060606060606141414141414141414141414141414141414141414141514141414141414151414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060606161718060606060606060606060606060606060606141514141414141415151414141414141415141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606161718060606060606262728060606060606060606060616171806060606141414251414141414141414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606262728060606060606060606060606060606060606060626272806060606141414151414141414251414141414141414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060606060606060606060606060303030606060606060609141414141414141414141414141414251414141414141414141414141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060306060306060606060606030202020606060606060302141414141414141414141414141414141414141421212121141414151414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030606060206060203060606060603020202020606060606030202141414141414211414141414141514141414142120202020141414141414141421000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020606062406060202030606060302020202020606060606020202141414141414202121212114141414141414212020202020141414141414142120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020303031903030202020303030202020202020303030303020202212121212121202020202021141421212121202020202020141414141414212020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202202020202020202020202020212120202020202020202020141414141414202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020202020202020202020202020202020202020202020202020202022020202020202020202020202020202020202020202020202a2b2c2d2d2d202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020202020202020202020202020202020202020202020202020202022020202020202020202020202020202020202020202020203a3b3c3d3a3a202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000280502f0501c0501f05000000230502f1502f15031150331503415035150351503205034050360503605000000350500000033050300502d0502c050290502805021050200500000000000
001001010505405054050540505405054050540405404054050540b0540b0540c0540c0540b0540b0540b0540b05409054070540705407054070540705405054050540e0540e0540c0540c0540e0541105411050
001000002101021010210102101021010210102101011010130101301013010130101301013010000101f0101f0101f0101f0101f0101f0100001013010130101501015010150101501017010170101501015010
001000001d7111f7101f7121f710217102471226710267102671021712217102171021712267102d7112b71029710297102b71130710377103571135710347102f71228710287102b7132d7102d7102971128710
001000001871118710177101a71221710237102571026713287102a7132b7102b7112b7102871026712237101f710267102671228710287102871229710297102b7122b7102b7102b7112b710297101071110711
00020000005000057002570075700b5700d57012570165701d5701f57020570005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
001000001d61018610166100060005600056000460003600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
120700000465007650056500365002650056500465000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c00000075000750037500c7501175016750000000075000750037500375003750077500c750137500000000000077500775007750077501175000000000000000000000000000000000000000000000000000
00100000007500575007750077500775000700007000c7500c7500c7500c7500c7500070000700007001875018750187501875000700007000c7500c7500c7500c75000700007000070022750227501f7501f750
001000000075000750007500075001750007500000006750077500775007750000000575005750037500375003750037500000000000037500375003750037500775007750077500775000000057500375003750
__music__
01 01020344
00 01020444
00 01020344
00 01020444
00 41020344
02 41020444
03 090a4344
00 41424444

