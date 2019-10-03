phone.AppleLauncher = {};
phone.AppleLauncher.__index = phone.Launcher();

local font = dxCreateFont("files/SFProText-Regular.ttf", 10);

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
    this.setAttribute('icon-margin-top', 30);

    local appMargin = 10;
    local appPadding = 0;
    local appSize = 32;
    local appsInRow = 3;

    local bgPadding = 3;

    local getStringRealTime = function ()
        local time = getRealTime();
        return string.format('%d:%02d', time.hour, time.minute);
    end

    this.drawMainMenu = function ()
        local wallpaper = this.getPhone().getAttribute('wallpaper');
        if wallpaper then
            dxDrawImage(0, 0, this.getPhone().getProperty('screen_width'), this.getPhone().getProperty('screen_height'), wallpaper);
        end

        local apps = this.getPhone().getApps();

        for k, v in ipairs(apps) do
            local col = (k-1) % appsInRow;
            local row = math.floor((k-1) / appsInRow);

            local x = col * (appSize + appMargin * 2) + appMargin;

            if this.getSelected() == k then
                dxDrawRectangle(x + appMargin - bgPadding, this.getAttribute('icon-margin-top') - bgPadding, appSize + (bgPadding * 2), appSize + (bgPadding * 2), 0x33FAFAFA);
            end

            dxDrawImage(
                x + appPadding + appMargin,
                this.getAttribute('icon-margin-top'),
                appSize, 
                appSize,
                v.getIcon());
        end
    end

    this.drawStatusBar = function (color)
        local time = getRealTime();
        dxDrawImage(5, 2, this.getPhone().getProperty('screen_width')-10, 17, 'files/statusbar.png', 0, 0, 0, color);
        dxDrawText(getStringRealTime(),
            0,                                              -- X
            2,                                              -- Y
            this.getPhone().getProperty('screen_width'),    -- Width
            20,                                             -- Height
            color,                                          -- Color
            0.9,                                            -- Scale
            font,                                           -- Font (SF Pro Text - 10)
            'center', 'center',                             -- alignX/alignY orientation
            true,                                           -- clip
            false);                                         -- wordBreak
    end

    this.draw = function (onlyStatus, color)
        onlyStatus = onlyStatus or false;
        color = color or tocolor(255, 255, 255, 255);

        if onlyStatus == true then
            this.drawStatusBar(color);
            return;
        end

        this.drawMainMenu();
        this.drawStatusBar(color);
    end
    
    return this;
end