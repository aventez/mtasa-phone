phone.Intro = {};
phone.Intro.__index = phone.Intro;

setmetatable(phone.Intro, {
    __call = function (obj, ...)
        return obj.__constructor(...);
    end,
    __eq = function (a, b)
        if not a.getId or not b.getId then
            return false;
        end
        return a.getId() == b.getId();
    end,
});

function phone.Intro.__constructor (phone)
    local this = setmetatable({}, phone.Intro);

    local _phone = phone;
    local _alpha = 0;

    this.getPhone = function ()
        return _phone;
    end

    this.getAlpha = function ()
        return _alpha;
    end

    this.setAlpha = function (alpha)
        _alpha = alpha;
    end

    this.draw = function ()
        dxDrawImage(0, 0, this.getPhone().getProperty('screen_width'), this.getPhone().getProperty('screen_height'), 'files/intro.png', 0, 0, 0, tocolor(255,255,255,_alpha));
    end

    return this;
end