fonts.FontsManager = {};
fonts.FontsManager.__index = fonts.FontsManager;

setmetatable(fonts.FontsManager, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

fonts.FontsManager.fonts = {};

fonts.FontsManager.createFont = function (fontName, size, bold)
	if not fonts.FontsManager.fonts[fontName] then
		fonts.FontsManager.fonts[fontName] = {};
	end
	if not fonts.FontsManager.fonts[fontName][size] then
		fonts.FontsManager.fonts[fontName][size] = {};
	end
	if not fonts.FontsManager.fonts[fontName][size][bold] then
		fonts.FontsManager.fonts[fontName][size][bold] = dxCreateFont('./files/' .. fontName, size, bold);
	end
end

fonts.FontsManager.getFont = function (fontName, size, bold)
	size = size or 9;
	bold = bold or false;
	if not fonts.FontsManager.fonts[fontName] or not fonts.FontsManager.fonts[fontName][size] or not fonts.FontsManager.fonts[fontName][size][bold] then
		fonts.FontsManager.createFont(fontName, size, bold);
	end
	return fonts.FontsManager.fonts[fontName][size][bold];
end

function fonts.FontsManager.__constructor (filepath)
    local this = setmetatable({}, fonts.FontsManager);
    
    return this;
end