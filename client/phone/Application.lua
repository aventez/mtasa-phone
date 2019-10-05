phone.Application = {};
phone.Application.__index = phone.Application;

setmetatable(phone.Application, {
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

function phone.Application.__constructor (launcher)
    local this = setmetatable({}, phone.Application);

    local _launcher = launcher;
    local _attributes = {};

    --attributs section
        this.setAttribute = function (name, value)
            _attributes[name] = value;
        end

        this.getAttribute = function (name)
            return _attributes[name];
        end
    --attributs section end

    --control section
    this.controlEnter = function () end;
    this.controlBack = function () end;
    this.controlNumber = function (value) end;
    this.controlLetter = function (value) end;
    this.controlUp = function () end;
    this.controlDown = function () end;
    --control section end

    this.getLauncher = function ()
        return _launcher;
    end

    this.draw = function (renderTarget)
        local p = this.getLauncher();
		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

        dxDrawText('Not implemented yet.', 
            0, 
            0, 
            width, 
            height,
            0xFF0000FF,
            1,
            'default',
            'center',
            'center',
            true, 
            true,
            false,
            false, 
            true,
            0, 0, 0);
    end

    return this;
end