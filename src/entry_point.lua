-- entry point --
-----------------

function _init()
    title_screen()
end

function title_screen()
    got_fruit = {}
    for i=0,29 do
        add(got_fruit,false) end
    frames=0
    deaths=0
    max_djump=1
    start_game=false
    start_game_flash=0
    music(40,0,7)
   
    load_room(7,3)
end

function begin_game()
    frames=0
    seconds=0
    minutes=0
    music_timer=0
    start_game=false
    music(0,0,7)
    load_room(0,0)
end

function level_index()
    return room.x%8+room.y*8
end

function is_title()
    return level_index()==31
end