package.path = package.path .. ";../src/?.lua"

local lucel = require("lucel")

function test1()
    local engine = lucel:new()
    engine:parse("t1.txt")
    engine:print()
end

test1()
