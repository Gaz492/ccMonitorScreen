storageTable = {
    -- FTB:IC Energy Storage
    ["ftbic:lv_battery_box"] = 40000,
    ["ftbic:mv_battery_box"] = 400000,
    ["ftbic:hv_battery_box"] = 4000000,
    ["ftbic:ev_battery_box"] = 40000000,
    -- Tanks
    ["industrialforegoing:common_black_hole_tank"] = 16000,
    ["industrialforegoing:pity_black_hole_tank"] = 64000,
    ["industrialforegoing:simple_black_hole_tank"] = 1024000,
    ["industrialforegoing:advanced_black_hole_tank"] = 65536000,
    ["industrialforegoing:supreme_black_hole_tank"] = 2147483647,
    -- Other
    ["experienceobelisk:cognitium"] = 65536000
}

function tableLength(T)
    local count = 0
    for _, v in pairs(T) do
        count = count + v["amount"]
    end
    return count
end

function getTopStored(T)
    length = tableLength(T)
    if length > 0 then
        table.sort(T, function(a, b)
            return a.amount > b.amount
        end)
        return T[1].displayName
    end
    return "null"
end

function format_int(number)

    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    -- reverse the int-string back remove an optional comma and put the 
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

function shortenNum(n)
    if n >= 10 ^ 9 then
        return string.format("%.2fG", n / 10 ^ 9)
    elseif n >= 10 ^ 6 then
        return string.format("%.2fM", n / 10 ^ 6)
    elseif n >= 10 ^ 3 then
        return string.format("%.2fK", n / 10 ^ 3)
    else
        return tostring(n)
    end
end

function roundNum(val, decimal)
    if (decimal) then
        return math.floor(((val * 10 ^ decimal) + 0.5) / (10 ^ decimal))
    else
        return math.floor(val + 0.5)
    end
end

function drawPixel(window, x, y, color)
    window.setCursorPos(x, y)
    window.setBackgroundColor(color)
    window.write(" ")
end

function drawProgressBar(window, x, y, value, barColour, borderColour)
    winX, winY = window.getSize()
    if barColour == nil then
        barColour = colors.red
    end
    if borderColour == nil then
        borderColour = colors.white
    end

    for i = 0, value do
        drawPixel(window, x + 1 + i, y + 3, barColour)
    end
    drawPixel(window, x, y + 3, borderColour)
    drawPixel(window, winX, y + 3, borderColour)

    for i = 0, winX - 1 do
        drawPixel(window, x + i, y + 2, borderColour)
        drawPixel(window, x + i, y + 4, borderColour)
    end
end

function centerText(window, text, yPos)
    local x,y = window.getSize()
    window.setCursorPos(math.ceil((x / 2) - (text:len() / 2)), yPos)
    window.write(text)
end