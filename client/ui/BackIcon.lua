ui.BackIcon = {};
ui.BackIcon.__index = ui.View();

setmetatable(ui.BackIcon, {
	__call = function(obj, ...)
		return obj.__constructor(...);
	end
});

function ui.BackIcon.__constructor(...)
	local this = ui.View(..., 'BackIcon');

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end

	this.onDraw = function ()
		super.onDraw();

		local marginLeft = 7;
		local marginTop = 25;
		local imageSize = 16;

		dxDrawImage(marginLeft, marginTop, imageSize, imageSize, 'files/arrow.png')
	end

	return this;
end