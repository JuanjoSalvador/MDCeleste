-- update function --
-----------------------

function _update()
    frames=((frames+1)%30)
    if frames==0 and level_index()<30 then
        seconds=((seconds+1)%60)
        if seconds==0 then
            minutes+=1
        end
    end
   
    if music_timer>0 then
     music_timer-=1
     if music_timer<=0 then
      music(10,0,7)
     end
    end
   
    if sfx_timer>0 then
     sfx_timer-=1
    end
   
    -- cancel if freeze
    if freeze>0 then freeze-=1 return end

    -- screenshake
    if shake>0 then
        shake-=1
        camera()
        if shake>0 then
            camera(-2+rnd(5),-2+rnd(5))
        end
    end
   
    -- restart (soon)
    if will_restart and delay_restart>0 then
        delay_restart-=1
        if delay_restart<=0 then
            will_restart=false
            load_room(room.x,room.y)
        end
    end

    -- update each object
    foreach(objects,function(obj)
        obj.move(obj.spd.x,obj.spd.y)
        if obj.type.update~=nil then
            obj.type.update(obj) 
        end
    end)
   
    -- start game
    if is_title() then
        if not start_game and (btn(k_jump) or btn(k_dash)) then
            music(-1)
            start_game_flash=50
            start_game=true
            sfx(38)
        end
        if start_game then
            start_game_flash-=1
            if start_game_flash<=-30 then
                begin_game()
            end
        end
    end
end

-- drawing functions --
-----------------------
function _draw()
    if freeze>0 then return end
   
    -- reset all palette values
    pal()
   
    -- start game flash
    if start_game then
        local c=10
        if start_game_flash>10 then
            if frames%10<5 then
                c=7
            end
        elseif start_game_flash>5 then
            c=2
        elseif start_game_flash>0 then
            c=1
        else 
            c=0
        end
        if c<10 then
            pal(6,c)
            pal(12,c)
            pal(13,c)
            pal(5,c)
            pal(1,c)
            pal(7,c)
        end
    end

    -- clear screen
    local bg_col = 0
    if flash_bg then
        bg_col = frames/5
    elseif new_bg~=nil then
        bg_col=2
    end
    rectfill(0,0,128,128,bg_col)

    -- clouds
    if not is_title() then
        foreach(clouds, function(c)
            c.x += c.spd
            rectfill(c.x,c.y,c.x+c.w,c.y+4+(1-c.w/64)*12,new_bg~=nil and 14 or 1)
            if c.x > 128 then
                c.x = -c.w
                c.y=rnd(128-8)
            end
        end)
    end

    -- draw bg terrain
    map(room.x * 16,room.y * 16,0,0,16,16,4)

    -- platforms/big chest
    foreach(objects, function(o)
        if o.type==platform or o.type==big_chest then
            draw_object(o)
        end
    end)

    -- draw terrain
    local off=is_title() and -4 or 0
    map(room.x*16,room.y * 16,off,0,16,16,2)
   
    -- draw objects
    foreach(objects, function(o)
        if o.type~=platform and o.type~=big_chest then
            draw_object(o)
        end
    end)
   
    -- draw fg terrain
    map(room.x * 16,room.y * 16,0,0,16,16,8)
   
    -- particles
    foreach(particles, function(p)
        p.x += p.spd
        p.y += sin(p.off)
        p.off+= min(0.05,p.spd/32)
        rectfill(p.x,p.y,p.x+p.s,p.y+p.s,p.c)
        if p.x>128+4 then 
            p.x=-4
            p.y=rnd(128)
        end
    end)
   
    -- dead particles
    foreach(dead_particles, function(p)
        p.x += p.spd.x
        p.y += p.spd.y
        p.t -=1
        if p.t <= 0 then del(dead_particles,p) end
        rectfill(p.x-p.t/5,p.y-p.t/5,p.x+p.t/5,p.y+p.t/5,14+p.t%2)
    end)
   
    -- draw outside of the screen for screenshake
    rectfill(-5,-5,-1,133,0)
    rectfill(-5,-5,133,-1,0)
    rectfill(-5,128,133,133,0)
    rectfill(128,-5,133,133,0)
   
    -- credits
    if is_title() then
        print("x+c",58,80,5)
        print("matt thorson",42,96,5)
        print("noel berry",46,102,5)
    end
   
    if level_index()==30 then
        local p
        for i=1,count(objects) do
            if objects[i].type==player then
                p = objects[i]
                break
            end
        end
        if p~=nil then
            local diff=min(24,40-abs(p.x+4-64))
            rectfill(0,0,diff,128,0)
            rectfill(128-diff,0,128,128,0)
        end
    end

end

function draw_object(obj)

    if obj.type.draw ~=nil then
        obj.type.draw(obj)
    elseif obj.spr > 0 then
        spr(obj.spr,obj.x,obj.y,1,1,obj.flip.x,obj.flip.y)
    end

end

function draw_time(x,y)

    local s=seconds
    local m=minutes%60
    local h=flr(minutes/60)
   
    rectfill(x,y,x+32,y+6,0)
    print((h<10 and "0"..h or h)..":"..(m<10 and "0"..m or m)..":"..(s<10 and "0"..s or s),x+1,y+1,7)

end