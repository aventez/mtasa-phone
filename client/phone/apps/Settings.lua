phone.Settings = {};
phone.Settings.__index = phone.Application();

setmetatable(phone.Settings, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Settings.getIcon()
	return 'files/icons/icons0.png';
end

function phone.Settings.__constructor (...)
	local this = phone.Application(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end
	
	this.draw = function (renderTarget)
        local p = this.getLauncher().getPhone();
		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

        dxDrawRectangle(0, 0, width, height, (0xFFB3B3B3));
        dxDrawText('Application in development', 
            0, 
            0, 
            width, 
            height,
            0xFF000000,
            1,
            'default',
            'center',
            'center',
            true, 
            true,
            false, --postGUI
            false, 
            true,
            0, 0, 0);
    end
    
    return this;
end