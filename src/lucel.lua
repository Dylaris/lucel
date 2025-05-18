local lu_cell = require("cell")
local lucel = {}
lucel.__index = lucel

function lucel:new()
    local obj = {}
    setmetatable(obj, self)
    obj.cells = {}
    obj.rows = 0
    obj.cols = 0
    return obj
end

local function get_cell_col(num)
    local a_num = string.byte("A")
    num = num + a_num - 1
    return string.char(num)
end

function lucel:parse(filename)
    local file = io.open(filename, "r")
    if not file then
        io.stderr:write("open file [ " .. filename .. " ] error\n");
        return
    end

    for line in file:lines() do
        self.rows = self.rows + 1
        self.cols = 0
        self.cells[self.rows] = {}

        local cleaned_line = line:match("^|%s*(.-)%s*|$")
        if cleaned_line then
            for content in cleaned_line:gmatch("[^|]+") do
                self.cols = self.cols + 1
                local cleaned_content = content:match("^%s*(.-)%s*$")
                local cell_type = CELL_TEXT
                if tonumber(cleaned_content) then cell_type = CELL_NUMBER end
                if string.sub(cleaned_content, 1, 1) == "=" then cell_type = CELL_FORMULA end
                local cell = lu_cell:new(cleaned_content,
                                         self.rows, get_cell_col(self.cols),
                                         cell_type)
                table.insert(self.cells[self.rows], cell)
            end
        end
    end
end

function lucel:print()
    local max_widths = {}
    for i = 1, self.cols do max_widths[i] = 1 end

    -- get max widths
    for row = 1, self.rows do
        for col = 1, self.cols do
            local cell = self.cells[row][col]
            if not cell then print(row,col) end
            if max_widths[col] < #cell.content then
                max_widths[col] = #cell.content
            end
        end
    end

    local function print_seperator()
        io.write("+")
        for col = 1, self.cols do
            io.write(string.rep("-", max_widths[col] + 2) .. "+")
        end
        io.write("\n")
    end
    
    -- print the top border
    print_seperator()

    -- print the table rows
    for row = 1, self.rows do
        -- print each row's cells with column separators
        io.write("|")
        for col = 1, self.cols do
            local cell = self.cells[row][col]
            io.write(" " .. string.format("%-" .. max_widths[col] .. "s", cell.content) .. " |")
        end
        io.write("\n")

        -- print the separator after each row
        print_seperator()
    end
end

return lucel
