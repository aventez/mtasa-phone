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

--priavate variables
    local _phone = phoneObject;
    local _attributes = {};
    local _properties = {};
    local _selected = 1;
--priavate variables end

--attributs section
    this.setAttribute = function (name, value)
        _attributes[name] = value;
    end

    this.getAttribute = function (name)
        return _attributes[name];
    end

    this.setAttributes = function (attributes)
        local k, v = next(attributes);
        while k do
            this.setAttribute(k, v);

            k, v = next(attributes, k);
        end
    end

    this.attr = function (name, value)
        if value == nil then
            return this.getAttribute(name);
        else
            return this.setAttribute(name, value);
        end
    end
--attributs section end

--control section
    this.controlEnter = function () end;
    this.controlBack = function () end;
    this.controlRight = function () end;
    this.controlNumber = function (value) end;
    this.controlLeft = function () end;
    this.controlUp = function () end;
    this.controlDown = function () end;
--control section end

-- selected section
    this.getSelected = function ()
        return _selected;
    end

    this.setSelected = function (selected)
        _selected = selected;
    end
-- selected section end

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

    this.drawStatusBar = function () 
    end

    return this;
end