phone.PinLauncher = {};
phone.PinLauncher.__index = phone.Launcher();

setmetatable(phone.PinLauncher, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.PinLauncher.__constructor (...)
	local this = phone.Launcher(...);

    local validPin = this.getPhone().getConfig('pin');
    local pin = '';
    local animation = {
        duration = 700,
        startTime = 0,
        progress = 0
    };

    this.draw = function ()
    	local width = this.getPhone().getProperty('screen_width');
        local height = this.getPhone().getProperty('screen_height');

        dxDrawRectangle(0, 0, width, height, 0xFF222222);

        if animation.startTime ~= 0 then
            local diff = getTickCount() - animation.startTime;
            local progress = diff / animation.duration;

            dxDrawImage(width/2-32, height/2+32, 64, 64, 'files/success.jpg', 0, 0, 0, tocolor(14, 138, 0, 255*progress));

            if(progress > 1) then
                this.getPhone().setLauncher(phone.AppleLauncher);
            end
        end

        dxDrawText(pin, 0, 0, width, height, white, 1.0, 1.0, 'default', 'center', 'center');
    end

    --control section
        this.control = function (value)
            local controlType = Controls.getControlType(value);

            if controlType == 'TYPE_BACK' then
                local strLength = string.len(pin);

                pin = string.sub(pin, 1, strLength-1);
            end
        end

        this.controlCharacter = function (value)
            if Controls.isNumeric(value) then
                if string.len(pin) < 4 then
                    pin = pin .. value;
                    if pin == validPin then
                        animation.startTime = getTickCount();
                    end
                end
            end
        end
    --control section end

    return this;
end