-- object functions --
-----------------------

function init_object(type,x,y)
    if type.if_not_fruit~=nil and got_fruit[1+level_index()] then
        return
    end
    local obj = {}
    obj.type = type
    obj.collideable=true
    obj.solids=true

    obj.spr = type.tile
    obj.flip = {x=false,y=false}

    obj.x = x
    obj.y = y
    obj.hitbox = { x=0,y=0,w=8,h=8 }

    obj.spd = {x=0,y=0}
    obj.rem = {x=0,y=0}

    obj.is_solid=function(ox,oy)
        if oy>0 and not obj.check(platform,ox,0) and obj.check(platform,ox,oy) then
            return true
        end
        return solid_at(obj.x+obj.hitbox.x+ox,obj.y+obj.hitbox.y+oy,obj.hitbox.w,obj.hitbox.h)
         or obj.check(fall_floor,ox,oy)
         or obj.check(fake_wall,ox,oy)
    end
   
    obj.is_ice=function(ox,oy)
        return ice_at(obj.x+obj.hitbox.x+ox,obj.y+obj.hitbox.y+oy,obj.hitbox.w,obj.hitbox.h)
    end
   
    obj.collide=function(type,ox,oy)
        local other
        for i=1,count(objects) do
            other=objects[i]
            if other ~=nil and other.type == type and other != obj and other.collideable and
                other.x+other.hitbox.x+other.hitbox.w > obj.x+obj.hitbox.x+ox and 
                other.y+other.hitbox.y+other.hitbox.h > obj.y+obj.hitbox.y+oy and
                other.x+other.hitbox.x < obj.x+obj.hitbox.x+obj.hitbox.w+ox and 
                other.y+other.hitbox.y < obj.y+obj.hitbox.y+obj.hitbox.h+oy then
                return other
            end
        end
        return nil
    end
   
    obj.check=function(type,ox,oy)
        return obj.collide(type,ox,oy) ~=nil
    end
   
    obj.move=function(ox,oy)
        local amount
        -- [x] get move amount
     obj.rem.x += ox
        amount = flr(obj.rem.x + 0.5)
        obj.rem.x -= amount
        obj.move_x(amount,0)
       
        -- [y] get move amount
        obj.rem.y += oy
        amount = flr(obj.rem.y + 0.5)
        obj.rem.y -= amount
        obj.move_y(amount)
    end
   
    obj.move_x=function(amount,start)
        if obj.solids then
            local step = sign(amount)
            for i=start,abs(amount) do
                if not obj.is_solid(step,0) then
                    obj.x += step
                else
                    obj.spd.x = 0
                    obj.rem.x = 0
                    break
                end
            end
        else
            obj.x += amount
        end
    end
   
    obj.move_y=function(amount)
        if obj.solids then
            local step = sign(amount)
            for i=0,abs(amount) do
             if not obj.is_solid(0,step) then
                    obj.y += step
                else
                    obj.spd.y = 0
                    obj.rem.y = 0
                    break
                end
            end
        else
            obj.y += amount
        end
    end

    add(objects,obj)
    if obj.type.init~=nil then
        obj.type.init(obj)
    end
    return obj
end

function destroy_object(obj)
    del(objects,obj)
end

function kill_player(obj)
    sfx_timer=12
    sfx(0)
    deaths+=1
    shake=10
    destroy_object(obj)
    dead_particles={}
    for dir=0,7 do
        local angle=(dir/8)
        add(dead_particles,{
            x=obj.x+4,
            y=obj.y+4,
            t=10,
            spd={
                x=sin(angle)*3,
                y=cos(angle)*3
            }
        })
        restart_room()
    end
end