ui.Header = {};
ui.Header.__index = ui.View();

setmetatable(ui.Header, {
	__call = function(obj, ...)
		return obj.__constructor(...);
	end
});

function ui.Header.__constructor(...)
	local this = ui.View(..., 'Header');

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end

	this.onDraw = function ()
		super.onDraw();

		local width = this.getAttribute('width') or 0;
		local height = this.getAttribute('height') or 0;

		dxDrawRectangle(0, 0, width, height, 0xFFEEFBF2);
		dxDrawLine(0, height, width, height, 0xFFB2B2B2);
		
		dxDrawText(this.getAttribute('text'),
            0, 
            0, 
            width, 
            height-5,
            0xFF000000,
            1,
            Fonts.font or 'default',
            'center',
            'bottom',
            true, 
            true,
            false, --postGUI
            false, 
            true,
            0, 0, 0);
	end

	return this;
end