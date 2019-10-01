colors.Color = {};
colors.Color.__index = colors.Color;

setmetatable(colors.Color, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

colors.Color.parse = function (color)
    if color:sub(1,5) == 'rgba(' and color:sub(-1) == ')' then
        local rgba = split(color:sub(6,-2), ',');
        if #rgba ~= 4 then return nil; end;

        for k, v in ipairs(rgba) do
             v = tonumber(v);
             if v == nil then
                return nil;
             end
        end

        rgba[4] = rgba[4] * 255; --rgba alpha range is 0.0-1.0, but lua range is 0-255

        return tocolor(rgba[1], rgba[2], rgba[3], rgba[4]);
    elseif color:sub(1,4) == 'rgb(' and color:sub() == ')' then
        local rgba = split(color, ',');
        if #rgba ~= 3 then return nil; end;

        for k, v in ipairs(rgba) do
             v = tonumber(v);
             if v == nil then
                return nil;
             end
        end

        return tocolor(v[1], v[2], v[3], 255);
    elseif color:sub(1,1) == '#' then
        color = color:sub(2);
        if #color == 3 then
            color = color:sub(1,1) .. color:sub(1,1) .. color:sub(2,2) .. color:sub(2,2) .. color:sub(3,3) .. color:sub(3,3);
            return tonumber('FF'..color, 16);
        elseif #color == 6 then
            return tonumber('FF'..color, 16);
        elseif #color == 8 then
            return tonumber(color, 16);
        else
            return nil;
        end
    end
end

function colors.Color.__constructor (filepath)
    local this = setmetatable({}, colors.Color);
    
    return this;
end