-- room functions --
--------------------

function restart_room()
    will_restart=true
    delay_restart=15
end

function next_room()
 if room.x==2 and room.y==1 then
  music(30,500,7)
 elseif room.x==3 and room.y==1 then
  music(20,500,7)
 elseif room.x==4 and room.y==2 then
  music(30,500,7)
 elseif room.x==5 and room.y==3 then
  music(30,500,7)
 end

    if room.x==7 then
        load_room(0,room.y+1)
    else
        load_room(room.x+1,room.y)
    end
end

function load_room(x,y)
    has_dashed=false
    has_key=false

    --remove existing objects
    foreach(objects,destroy_object)

    --current room
    room.x = x
    room.y = y

    -- entities
    for tx=0,15 do
        for ty=0,15 do
            local tile = mget(room.x*16+tx,room.y*16+ty);
            if tile==11 then
                init_object(platform,tx*8,ty*8).dir=-1
            elseif tile==12 then
                init_object(platform,tx*8,ty*8).dir=1
            else
                foreach(types, 
                function(type) 
                    if type.tile == tile then
                        init_object(type,tx*8,ty*8) 
                    end 
                end)
            end
        end
    end
   
    if not is_title() then
        init_object(room_title,0,0)
    end
end