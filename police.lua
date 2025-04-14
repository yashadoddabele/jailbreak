-- update function for the officers
function loop_officer(officer, level)
    local dx = 0

    if officer.sprite < 20 then
        dx = -1
        officer.sprite = 18 + officer.frame
    else
        dx = 1
        officer.sprite = 20 + officer.frame
    end
    
    if validate_boundaries(officer, dx, 0, level) and is_not_ledge(officer, dx, level) then
        officer.x += dx
    else
        --change direction of officer if need be
        if officer.sprite < 20 then
            officer.sprite = 20 
        else
            officer.sprite = 18 
        end
    end

    -- update timer to alternate frames
    officer.timer += 1
    if officer.timer % 10 == 0 then
        officer.frame = (officer.frame + 1) % 2
    end

end

--checks if there is a ledge, in which case the officer changes direction
function is_not_ledge(officer, dx, level) 
    local tile_x = ((officer.x + dx) / 8) + level["map_x"]
    local tile_y = (officer.y / 8)
    local next_tile = mget(tile_x, tile_y+1)
    return fget(next_tile, 0)
end
