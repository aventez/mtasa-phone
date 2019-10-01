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

--static
phone.Launcher.lastId = 0;
function phone.Launcher.getNewId()
    phone.Launcher.lastId = phone.Launcher.lastId + 1;
    return 'phone.Launcher_' .. phone.Launcher.lastId;
end

function phone.Launcher.__constructor (phoneObject)
    local this = setmetatable({}, phone.Launcher);

--id section
    local _id = phone.Launcher.getNewId();
    this.getId = function ()
        return _id;
    end
--id section end

--priavate variables
    local _phone = phoneObject;
    local _attributes = {};
    local _properties = {};
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

    this.prop = function (name, value)
        if value == nil then
            return this.getProperty(name);
        else
            return this.setProperty(name, value);
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