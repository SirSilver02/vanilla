local function get_screen_scale(w, h, scr_w, scr_h)
    local scr_w, scr_h = scr_w or love.graphics.getWidth(), scr_h or love.graphics.getHeight()
    local scale_x = scr_w / w
    local scale_y = scr_h / h
    local smaller_scale = scale_x < scale_y and scale_x or scale_y

    return smaller_scale
end

local vanilla = {}
vanilla.__index = vanilla

function vanilla:init(aspect_width, aspect_height)
    self.aspect_width = aspect_width
    self.aspect_height = aspect_height

    self.canvas = nil
    self.last_canvas = nil
    self.canvas_settings = nil

    self:resize_canvas()
end

function vanilla:set_canvas_settings(settings)
    self.canvas_settings = settings
end

--note, this does remove the old canvas, so you will lose that data
function vanilla:resize_canvas()
    local scale = get_screen_scale(self.aspect_width, self.aspect_height)
    self.canvas = love.graphics.newCanvas(self.aspect_width * scale, self.aspect_height * scale, self.canvas_settings)
end

--call before drawing things you want rendered on the canvas
function vanilla:start_draw()
    self.last_canvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

--call when you're finished rendering to the canvas
function vanilla:stop_draw()
    love.graphics.setCanvas(self.last_canvas)

    local w, h = love.graphics.getDimensions()
    love.graphics.draw(self.canvas, w / 2, h / 2, 0, 1, 1, self.canvas:getWidth() / 2, self.canvas:getHeight() / 2)
end

--converts mouse coords to canvas coords, assumes canvas is being rendered in the center of the screen, thats how this vanilla is intended to work.
function vanilla:mouse_to_canvas()
    local mx, my = love.mouse.getPosition()

    local scr_w, scr_h = love.graphics.getDimensions()
    local canvas_w, canvas_h = self.canvas:getDimensions()

    return mx - (scr_w / 2) + (canvas_w / 2), my - (scr_h / 2) + (canvas_h / 2)
end

--love callback
function vanilla:resize(w, h)
    self:resize_canvas()
end

return {new = function(aspect_width, aspect_height)
    local inst = setmetatable({}, vanilla)
    inst:init(aspect_width, aspect_height)

    return inst
end}