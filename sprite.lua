function create_sprite(x, y, id)
    return {
        x = x,
        y = y,
        trail = {},
        dx=0,
        dy=0,
        max_dx=2,
        max_dy=3,
        acc=0.5,
        boost=4,
        sprite = id,
        frame = 0,
        timer = 0,
        explosions = {},
        hanging = false
    }
end

-- update sprite at every iteration
function update_sprite(sprites)
    player = sprites["player"]
    policemen = sprites["policemen"]
    key = sprites["key"]
    door = sprites["door"]
    door2 = sprites["door2"]

    local gravity = 0.3
    local friction = 0.70

    if not player.hanging then
        player.dy += gravity
        player.dx*=friction
    end

    if #player.trail > 1 then
        deli(player.trail, 1)
    end

    handle_button_press(player, sprites)
    handle_jump(player, sprites)

    --check if there was a police interaction: if so, restore the key
    for officer in all(policemen) do 
        if detect_sprite_interaction(player, officer) then 
            sfx(1)
            local explosion_x, explosion_y = get_explosion_position(player, officer)
            add(player.explosions, {x = explosion_x, y = explosion_y, timer = 15})
            key.sprite = 34
            door.sprite = 24
            door2.sprite = 40
        end
end
    --check if there was a chain interaction
    detect_chains(sprites)
    --check if there was a key interaction
    detect_key(sprites)

    update_explosions(sprites)

    -- update timer to alternate frames
    player.timer += 1
    if player.timer % 5 == 0 then
        player.frame = (player.frame + 1) % 2
    end
end

-- draws all sprite objects
function draw_sprite(player)
    for t in all(player.trail) do
        spr(t.id, t.x, t.y)
    end

    if #player.explosions > 0 then
        for e in all(player.explosions) do
            spr(13, e.x, e.y)
        end
    else
        spr(player.sprite, player.x, player.y)
    end
end

--general collision function for things like keys/items.
function detect_block(level, id) 
    player = level["player"]
    dx = player.dx
    dy = player.dy

    local x1 = (player.x + dx) / 8 + level["map_x"]
    local x2 = (player.x + dx + 7) / 8 + level["map_x"]
    local y1 = (player.y + dy) / 8
    local y2 = (player.y + dy + 7) / 8

    --check that none of the tiles are walls
    local a = fget(mget(x1, y1),id)
    local b = fget(mget(x2, y1),id)
    local c = fget(mget(x1, y2),id)
    local d = fget(mget(x2, y2),id)

    if a or b or c or d then
        return true
    else
        return false
    end
end

-- detects if player has touched chains and can now hang
function detect_chains(level) 
    player = level["player"]
    if detect_block(level, 4, level) then
        --hanging functionality 
        player.hanging = true
        player.dy = 0
        player.dx = 0
    else
        player.hanging = false
    end
end

-- checks if the sprite has touched the unlocked door, signaling level completion
function went_through_door(level)
    if detect_sprite_interaction(level["player"], level["door"]) or detect_sprite_interaction(level["player"], level["door2"]) then
        if level["door"].sprite == 46 and level["door2"].sprite == 62 then
            return true
        end
    else
        return false
    end
end

-- detects if key has been retrieved
function detect_key(level) 
    player = level["player"]
    key = level["key"]
    door = level["door"]
    door2 = level["door2"]

    if detect_sprite_interaction(player, key) then
        if key.sprite == 34 then--first time getting the key
            sfx(2)
            key.sprite = 29
            door.sprite = 46
            door2.sprite = 62
        end
    end
end

-- detects any general interaction with the player and another game sprite
function detect_sprite_interaction(player, sprite)
    local overlap_x = player.x < sprite.x + 8 and player.x + 8 > sprite.x
    local overlap_y = player.y < sprite.y + 8 and player.y + 8 > sprite.y
    return overlap_x and overlap_y
end

-- the player used to explode when the officer caught him but that seemed weird. so now he just jails him
-- but the code is the same
function get_explosion_position(player, officer)
    local explosion_x = officer.x
    local explosion_y = officer.y

    if player.x < officer.x then
        explosion_x = officer.x - 8  
    elseif player.x > officer.x then
        explosion_x = officer.x + 8  
    elseif player.y < officer.y then
        explosion_y = officer.y - 8  
    elseif player.y > officer.y then
        explosion_y = officer.y + 8  
    end

    return explosion_x, explosion_y
end