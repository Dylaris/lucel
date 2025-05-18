local cell = {}
cell.__index = cell

CELL_TEXT    = 1
CELL_NUMBER  = 2
CELL_FORMULA = 3

function cell:new(content, row, col, type)
    local obj = {}
    setmetatable(obj, self)
    obj.content = content or ""
    obj.row = row or 1
    obj.col = col or "A"
    obj.type = type or CELL_TEXT
    return obj
end

cell.__add = function (c1, c2)
    return c1.content .. c2.content
end

cell.__sub = function (c1, c2)
    if c1.type == CELL_NUMBER and c2.type == CELL_NUMBER then
        return tonumber(c1.content) - tonumber(c2.content)
    end
end

cell.__mul = function (c1, c2)
    if c1.type == CELL_NUMBER and c2.type == CELL_TEXT then
        return string.rep(c2.content, tonumber(c1.content))
    elseif c2.type == CELL_NUMBER and c1.type == CELL_TEXT then
        return string.rep(c1.content, tonumber(c2.content))
    end
end

cell.__div = function (c1, c2)
    if c1.type == CELL_NUMBER and c2.type == CELL_NUMBER then
        return tonumber(c1.content) / tonumber(c2.content)
    end
end

cell.__tostring = function (c)
    local type_string = "TEXT"
    if c.type == CELL_NUMBER then type_string = "NUMBER" end
    if c.type == CELL_FORMULA then type_string = "FORMULA" end

    local json = "{\n"
    for k, v in pairs(c) do
        local value = (type(v) == "string") and '"' .. v .. '"' or tostring(v)
        json = json .. '  "' .. k .. '": ' .. value .. ',\n'
    end
    json = json:sub(1, -2) -- get rid of last ','
    json = json .. "\n}"

    return json
end

return cell
