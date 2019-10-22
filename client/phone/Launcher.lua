phone.Launcher = {};
phone.Launcher.__index = phone.Launcher;

setmetatable(phone.Launcher, {
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

function phone.Launcher.__constructor (phoneObject)
    local this = setmetatable({}, phone.Launcher);

--variables section
    local _phone = phoneObject;
    local _attributes = {};
    local _properties = {};
--variables section end

--attributs section
    this.setAttribute = function (name, value)
        _attributes[name] = value;
    end

    this.getAttribute = function (name)
        return _attributes[name];
    end
--attributs section end

--control section
    this.control = function (key) end;
    this.controlCharacter = function (key) end;
--control section end

--property section
    this.setProperty = function (name, value)
        _properties[name] = value;
    end

    this.getProperty = function (name)
        return _properties[name];
    end

    this.setProperties = function (properties)
        local k, v = next(properties);
        while k do
            this.setProperty(k, v);

            k, v = next(properties, k);
        end
    end
--property section end

    this.getPhone = function ()
        return _phone;
    end

    this.drawStatusBar = function () end

    return this;
end