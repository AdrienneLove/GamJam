-- Game scale
--SCALE = 0.7

function love.conf(t)
    io.stdout:setvbuf("no")

    -- identity
    t.title = "48hr Game Challenge 2014"                -- The title of the window the game is in (string)
    t.author = "Oopa Chalupa!"       -- The author of the game (string)
    t.url = ""                 -- The website of the game (string)
    t.identity = "save/"          -- The name of the save directory (string)

    -- version
    t.version = "0.9.0"         -- The LÖVE version this game was made for (string)
    t.console = false           -- Attach a console (boolean, Windows only)
    t.release = false           -- Enable release mode (boolean)

    -- window
    t.window.width = 1024        
    t.window.height = 768
    t.window.fullscreen = false -- Enable fullscreen (boolean)
    t.window.vsync = true       -- Enable vertical sync (boolean)
    t.window.fsaa = 0           -- The number of FSAA-buffers (number)
    t.window.resizable = true

    -- modules
    t.modules.joystick = true   -- Enable the joystick module (boolean)
    t.modules.audio = true      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = true      -- Enable the sound module (boolean)
    t.modules.physics = true    -- Enable the physics module (boolean)
end