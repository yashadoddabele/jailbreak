
-- initializes a level with the necessary attributes 
function init_level(num)
    elements = get_elements_for_level(num)
    sprites = {}

    sprites["player"] = create_sprite(elements["player"].x, elements["player"].y, elements["player"].id)
    sprites["key"] = create_sprite(elements["key"].x, elements["key"].y, elements["key"].id)
    sprites["door"] = create_sprite(elements["door"].x, elements["door"].y, elements["door"].id)
    sprites["door2"] = create_sprite(elements["door2"].x, elements["door2"].y, elements["door2"].id)
    sprites["policemen"] = {}
    sprites["map_x"] = elements["map_x"]
    sprites["respawn_x"] = elements["player"].x
    sprites["respawn_y"] = elements["player"].y
    sprites["map_x_offset"] = elements["map_x_offset"]

    -- inits policemen
    for police in all(elements["policemen"]) do
        add(sprites["policemen"], create_sprite(police.x, police.y, police.id))
    end

    return sprites
end

-- update function for the level - updates all sprites
function update_level(level) 
    update_sprite(level)
	for officer in all(level["policemen"]) do 
		loop_officer(officer, level)
	end
end

-- determines if the level has been cleared (if the sprite entered the unlocked door)
function level_cleared(level)
    if went_through_door(level) then
        return true
    else
        return false
    end
end

-- draws the level layout
function draw_level(level, num)
    draw_sprite(level["door"])
	draw_sprite(level["door2"])
    draw_sprite(level["player"])
    draw_sprite(level["key"])

    for officer in all(level["policemen"]) do
	    draw_sprite(officer)
    end
end

-- customizable function defining parameters for the level design
function get_elements_for_level(num)
    local elements = {}

    if num == 1 then
        elements["player"] = {id = 1, x = 20, y = 88}
        elements["key"] = {id = 34, x = 8, y = 39}
        elements["policemen"] = {}
        add(elements["policemen"], {id = 18, x = 80, y = 96})
        elements["door"] = {id = 24, x = 10, y = 0}
        elements["door2"] = {id = 40, x = 10, y = 8}
        elements["map_x"] = 0

    elseif num == 2 then
        elements["player"] = {id = 1, x = 108, y = 8}
        elements["key"] = {id = 34, x = 2, y = 15}
        elements["policemen"] = {}
        add(elements["policemen"], {id = 18, x = 30, y = 80})
        add(elements["policemen"], {id = 18, x = 55, y = 88})
        add(elements["policemen"], {id = 18, x = 120, y = 88})
        elements["door"] = {id = 24, x = 120, y = 40}
        elements["door2"] = {id = 40, x = 120, y = 48}
        elements["map_x"] = 16

    elseif num == 3 then
        elements["player"] = {id = 1, x = 57, y = 9}
        elements["key"] = {id = 34, x = 112, y = 94}
        elements["policemen"] = {}
        add(elements["policemen"], {id = 18, x = 10, y = 96})
        add(elements["policemen"], {id = 18, x = 30, y = 96})
        add(elements["policemen"], {id = 18, x = 50, y = 96})
        add(elements["policemen"], {id = 18, x = 70, y = 96})
        add(elements["policemen"], {id = 18, x = 90, y = 96})
        elements["door"] = {id = 24, x = 110, y = 0}
        elements["door2"] = {id = 40, x = 110, y = 8}
        elements["map_x"] = 32
    end

    return elements
end
