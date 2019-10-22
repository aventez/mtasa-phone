phone.AppleLauncher = {};
phone.AppleLauncher.__index = phone.Launcher();

setmetatable(phone.AppleLauncher, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.AppleLauncher.__constructor (...)
	local this = phone.Launcher(...);
    
    local appMargin = 5;
    local appPadding = 2;
    local appSize = 48;
    local appsInRow = 4;

    local bgPadding = 3;

    local _selected = 1;
    local _selectedSize = 40;

    this.setAttribute('color', tocolor(0, 0, 0, 0.4));
    this.setAttribute('iconsMargin', 20);

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

        local iconsMargin = this.getAttribute('iconsMargin');

        for k, v in ipairs(apps) do
            local col = (k-1) % appsInRow;
            local row = math.floor((k-1) / appsInRow);

            local x = col * (appSize + appMargin * 2) + appMargin;
            local y = iconsMargin + row * (appSize + appMargin * 2) + appMargin;

            if(this.getSelectedSize() < appSize + 5) then
                this.iconAnimation(0.13);
            end

            if this.getSelected() == k then
                dxDrawImage(
                    x + appPadding + appMargin,
                    y + appPadding + appMargin + 10,
                    this.getSelectedSize() - appPadding * 2, 
                    this.getSelectedSize() - appPadding * 2,
                    v.getIcon());
            else
                dxDrawImage(
                    x + appPadding + appMargin,
                    y + appPadding + appMargin + 10,
                    appSize - appPadding * 2, 
                    appSize - appPadding * 2,
                    v.getIcon());
            end
        end
    end

    this.iconAnimation = function (progress)
        this.setSelectedSize(this.getSelectedSize() + progress);
    end

    this.control = function (key)
        local controlType = Controls.getControlType(key);

        if controlType == 'TYPE_ENTER' then
            this.getPhone().runApplication(this.getSelected());
        elseif controlType == 'TYPE_UP' then
            this.changeSelected(-1);
        elseif controlType == 'TYPE_DOWN' then
            this.changeSelected(1);
        end
    end

    this.changeSelected = function (value)
        local new = this.getSelected() + value;

        if this.getSelected() == 1 and value < 0 then
            this.setSelected(#this.getPhone().getApps());
            return;
        elseif new > #this.getPhone().getApps() then
            this.setSelected(1);
            return;
        end

        this.setSelected(new);
    end

    this.drawStatusBar = function (color)
        local time = getRealTime();
        dxDrawText(getStringRealTime(),
            0,                                              -- X
            0,                                              -- Y
            this.getPhone().getProperty('screen_width'),    -- Width
            38,                                             -- Height
            color,                                          -- Color
            0.9,                                            -- Scale
            Fonts.font,                                     -- Font
            'center', 'center',                             -- alignX/alignY orientation
            true,                                           -- clip
            false);                                         -- wordBreak
    end

    -- selected section
        this.getSelected = function ()
            return _selected;
        end

        this.setSelected = function (selected)
            this.setSelectedSize(40);
            _selected = selected;
        end

        this.setSelectedSize = function (size)
            _selectedSize = size;
        end

        this.getSelectedSize = function ()
            return _selectedSize;
        end
    -- selected section end

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