-- updates the start screen (if the player presses x, the game begins)
function update_start_screen() 
    if btnp(❎) then
        return true
    else
        return false
    end
end 

-- drawing functions for the scenes
function draw_start_screen()
    cls()
    map(48, 0, 0, 0, 16, 14)  
end

function draw_end_screen()
    cls()
    map(64, 0, 0, 0, 16, 14)  
end

-- updates the start screen (if the player presses x, the game restarts)
function update_end_screen() 
    if btnp(❎) then
        return true
    else
        return false
    end
end 