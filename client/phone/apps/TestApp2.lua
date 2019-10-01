phone.TestApp2 = {};
phone.TestApp2.__index = phone.Application();

setmetatable(phone.TestApp2, {
    __call = function (obj, ...)
        return obj.__constructor(...);
    end,
});

function phone.TestApp2.getIcon()
    return 'files/icons/icons1.png';
end

function phone.TestApp2.__constructor (...)
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
        dxDrawText('Application in development2', 
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