phone.AppleLauncher = {};
phone.AppleLauncher.__index = phone.Launcher();

local font = dxCreateFont("files/SFProText-Regular.ttf", 10)

setmetatable(phone.AppleLauncher, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.AppleLauncher.__constructor (...)
	local this = phone.Launcher(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
    end
    
    this.setAttribute('color', tocolor(0, 0, 0, 0.4));
    this.setAttribute('font', font);

    local getStringRealTime = function ()
        local time = getRealTime();
        return string.format('%d:%02d', time.hour, time.minute);
    end

    this.drawStatusBar = function ()
        local time = getRealTime();
        dxDrawImage(5, 2, this.getPhone().getProperty('screen_width')-10, 17, 'files/statusbar.png');
        dxDrawText(getStringRealTime(),
            0,                                              -- X
            2,                                              -- Y
            this.getPhone().getProperty('screen_width'),    -- Width
            20,                                             -- Height
            tocolor(255, 255, 255, 255),                    -- Color
            0.9,                                            -- Scale
            font,                                           -- Font (SF Pro Text - 10)
            'center', 'center',                             -- alignX/alignY orientation
            true,                                           -- clip
            false);                                         -- wordBreak
    end

    this.drawMainMenu = function ()
    local wallpaper = this.getPhone().getAttribute('wallpaper');
        if wallpaper then
            dxDrawImage(0, 0, this.getPhone().getProperty('screen_width'), this.getPhone().getProperty('screen_height'), wallpaper);
        end
    end

    this.draw = function ()
        this.drawMainMenu();
        this.drawStatusBar();
    end
    
    return this;
end