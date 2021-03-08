-- helper functions --
----------------------

function clamp(val,a,b)
    return max(a, min(b, val))
end

function appr(val,target,amount)
 return val > target 
     and max(val - amount, target) 
     or min(val + amount, target)
end

function sign(v)
    return v>0 and 1 or
                                v<0 and -1 or 0
end

function maybe()
    return rnd(1)<0.5
end

function solid_at(x,y,w,h)
 return tile_flag_at(x,y,w,h,0)
end

function ice_at(x,y,w,h)
 return tile_flag_at(x,y,w,h,4)
end

function tile_flag_at(x,y,w,h,flag)
 for i=max(0,flr(x/8)),min(15,(x+w-1)/8) do
     for j=max(0,flr(y/8)),min(15,(y+h-1)/8) do
         if fget(tile_at(i,j),flag) then
             return true
         end
     end
 end
    return false
end

function tile_at(x,y)
 return mget(room.x * 16 + x, room.y * 16 + y)
end

function spikes_at(x,y,w,h,xspd,yspd)
 for i=max(0,flr(x/8)),min(15,(x+w-1)/8) do
     for j=max(0,flr(y/8)),min(15,(y+h-1)/8) do
      local tile=tile_at(i,j)
      if tile==17 and ((y+h-1)%8>=6 or y+h==j*8+8) and yspd>=0 then
       return true
      elseif tile==27 and y%8<=2 and yspd<=0 then
       return true
         elseif tile==43 and x%8<=2 and xspd<=0 then
          return true
         elseif tile==59 and ((x+w-1)%8>=6 or x+w==i*8+8) and xspd>=0 then
          return true
         end
     end
 end
    return false
end