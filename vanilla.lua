local function get_screen_scale(w, h, scr_w, scr_h)
    local scr_w, scr_h = scr_w or love.graphics.getWidth(), scr_h or love.graphics.getHeight()
    
    return math.min(scr_w / w, scr_h / h)
end

local vanilla = {}
vanilla.__index = vanilla

function vanilla:init(aspect_width, aspect_height, settings)
    self.aspect_width = aspect_width
    self.aspect_height = aspect_height
    
    self.scale = nil
    self.last_canvas = nil
    self.canvas = love.graphics.newCanvas(aspect_width, aspect_height, settings)

    self:resize_canvas()
end

function vanilla:resize_canvas()
    self.scale = get_screen_scale(self.aspect_width, self.aspect_height)
end

function vanilla:start_draw()
    self.last_canvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function vanilla:stop_draw()
    love.graphics.setCanvas(self.last_canvas)

    local w, h = love.graphics.getDimensions()
    love.graphics.draw(self.canvas, w / 2, h / 2, 0, self.scale, self.scale, self.canvas:getWidth() / 2, self.canvas:getHeight() / 2)
    --love.graphics.draw(self.canvas, 0, 0, 0, self.scale, self.scale)
end

function vanilla:mouse_to_canvas(x, y)
    local mx, my = x or love.mouse.getX(), y or love.mouse.getY()

    local scr_w, scr_h = love.graphics.getDimensions()
    local canvas_w, canvas_h = self.canvas:getDimensions()
    canvas_w, canvas_h = canvas_w * self.scale, canvas_h * self.scale

    return (mx / self.scale) - (scr_w / 2) / self.scale + (canvas_w / 2) / self.scale , (my / self.scale) - (scr_h / 2) / self.scale + (canvas_h / 2) / self.scale
end

--love callback
function vanilla:resize(w, h)
    self:resize_canvas()
end

return {new = function(aspect_width, aspect_height, settings)
    local inst = setmetatable({}, vanilla)
    inst:init(aspect_width, aspect_height, settings)

    return inst
end}
