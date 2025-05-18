package.path = package.path .. ";../src/?.lua"

local lucel = require("lucel")

function test1()
    local engine = lucel:new()
    engine:parse("t1.txt")
    engine:print()

    local cell = engine:getcell("A2")
    print(cell)
    cell = engine:getcell("D2")
    print(cell)
    cell = engine:getcell("A8")
    print(cell)
end

function test2()
end

test1()
