-- handle user input
function handle_button_press(player, level)
    if btn(➡️) then
        player.dx+=player.acc
        if not player.hanging then
            player.sprite = 4 + player.frame
        else
            player.sprite = 30 + player.frame
        end
        if can_jump(player, level) then
            add(player.trail, {x = player.x - 4, y = player.y, id = 22})
        else
            deli(player.trail, 1)
        end
    elseif btn(⬅️) then
        player.dx-=player.acc
        if not player.hanging then
            player.sprite = 2 + player.frame
        else
            player.sprite = 14 + player.frame
        end
        if can_jump(player, level) then
            add(player.trail, {x = player.x + 4, y = player.y, id = 23})
        else
            deli(player.trail, 1)
        end
    -- if a player presses down while the sprite is hanging, it can leave/scooch down the chain
    elseif btnp(⬇️) and player.hanging then
        player.hanging = false 
        player.dy = 15
    else
        if player.hanging then
            player.sprite = 16
        else
            player.sprite = 1
        end
        deli(player.trail, 1)
    end

    if btnp(❎) and (can_jump(player, level) or player.hanging) then 
        player.dy-=player.boost
        player.sprite = 6
        sfx(0)
    end
end

-- handle jump physics
function handle_jump(player, level) 
    player.dx=mid(-player.max_dx,player.dx,player.max_dx)
    --limit fall speed
    if (player.dy>0) then
        player.dy=mid(-player.max_dy,player.dy,player.max_dy)
    end

    --apply dx to player position
    if validate_boundaries(player, player.dx, 0, level) then
        player.x+=player.dx
    end

    --apply dy to player position
    if validate_boundaries(player, 0, player.dy, level) then
        player.y += player.dy
    else
        -- snap to ground if falling
        while player.dy > 0 and validate_boundaries(player, 0, 1, level) do
            player.y += 1
        end
        player.dy = 0
    end

    --ground collision
    if can_jump(player, level) then
        player.dy=0
    end

    if player.dy > 0 then
        player.sprite = 7
    end
end

--loop temporary explosion animation when sprite collides with police
function update_explosions(level)
    player = level["player"]
    for i = #player.explosions, 1, -1 do
        --reset player position back to spawn
        player.x = level.respawn_x
        player.y = level.respawn_y
        player.trail = {}
        local e = player.explosions[i]
        e.timer -= 1
        if e.timer <= 0 then
            deli(player.explosions, i) 
        end
    end
end

--check if the sprite has run into walls/screen bounds
function validate_boundaries(player, dx, dy, level)
    map_x = level["map_x"]
    local x1 = ((player.x + dx) / 8) + map_x
    local x2 = ((player.x + dx + 7) / 8) + map_x
    local y1 = ((player.y + dy) / 8)
    local y2 = ((player.y + dy + 7 ) / 8)

    --check that none of the tiles are walls
    local a = fget(mget(x1, y1),0)
    local b = fget(mget(x2, y1),0)
    local c = fget(mget(x1, y2),0)
    local d = fget(mget(x2, y2),0)

    -- check that we are in bounds of the screen
    if x1 < 0+map_x or x2 < 0+map_x or x1 > 16+map_x or x2 > 16+map_x or y1 < 0 or y2 < 0 or y1 > 14 or y2 > 14 then
        return false
    end

    if a or b or c or d then
        return false
    else
        return true
    end
end

--makes sure player is on ground to be able to jump
function can_jump(player, level)
    solid = fget(mget((player.x + 4) / 8 + level["map_x"], (player.y + 9)/ 8), 0)
    if solid then 
        return true
    else 
        return false
    end
end