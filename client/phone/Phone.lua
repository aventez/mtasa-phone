phone.Phone = {};
phone.Phone.__index = phone.Phone;

setmetatable(phone.Phone, {
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

function phone.Phone.__constructor (parent, viewType)
    local this = setmetatable({}, phone.Phone);


--private variables section
    local _x = 0;
    local _y = 0;
    
    local _screenRenderTarget = nil;

    local _launcher = nil;
    local _app = nil;
    local _apps = {};

    local _attributes = {};
    local _properties = {};
--private variables section end

    --interaction section
    this.onClosePhone = function ()
    end

    this.closePhone = function ()
        if this.getApplication() then
            this.getApplication().onClose(this);
        end

        this.onClosePhone();
    end
    --interactoin section end

    --position section
        this.getX = function ()
            return _x;
        end

        this.getY = function ()
            return _y;
        end

        this.setX = function (x)
            _x = x;
        end

        this.setY = function (y)
            _y = y;
        end
    --position section end

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

        --default properties
        this.setProperties({
            width = 280,
            height = 559,
            screen_offset_x = 17,
            screen_offset_y = 15,
            screen_width = 245,
            screen_height = 529,
        });
    --property section end

    --launcher section
        this.setLauncher = function (launcherClass)
            _launcher = launcherClass(this);
        end

        this.getLauncher = function ()
            return _launcher;
        end
    --launcher section end

    --config section
        local _config = {};

        this.setConfig = function (name, value)
            _config[name] = value;
        end

        this.getConfig = function (name)
            return _config[name];
        end

        this.getPhoneNumber = function ()
            return this.getConfig('phoneNumber');
        end

    --config section end

    this.openConversation = function (id)
        triggerServerEvent('getTopicMessages', resourceRoot, id);
    end

    -- server section
        this.phoneCall = function (data)
            -- phone call
            triggerServerEvent('onClientPhoneCall', resourceRoot, data);
        end

        this.addMessage = function (topic, number, content)
            -- add new message
            triggerServerEvent('addNewMessage', resourceRoot, topic, number, content);
        end

        this.addTopic = function (first, second)
            -- add new topic
            triggerServerEvent('addNewTopic', resourceRoot, first, second);
        end
    -- server section end

    -- contacts section
        this.getContacts = function ()
            return this.getConfig('contacts');
        end

        this.addContact = function (data)
            local contacts = this.getConfig('contacts');

            if contacts then
                table.insert(contacts, data);
            else
                contacts = {
                    data
                };
            end

            this.setConfig('contacts', contacts);
            this.getApplication().onClose(this);

            -- add contact server-side             
            triggerServerEvent('onClientAddContact', resourceRoot, data.name, data.number, this.getConfig('phoneId'));
        end

        this.removeContact = function (number)
            local contacts = this.getConfig('contacts');

            if contacts then
                for k, v in pairs(contacts) do
                    if v.number == number then
                        table.remove(contacts, k);
                        triggerServerEvent('onClientRemoveContact', resourceRoot, data.id);
                    end
                end

                return false;
            end

            this.setConfig('contacts', contacts);
        end

        this.findContact = function (number)
            local contacts = this.getConfig('contacts');

            if contacts then
                for k, v in pairs(contacts) do
                    if v.number == number then
                        return v;
                    end
                end

                return false;
            end
        end
    -- contacts section end

    -- control section
        this.controlCharacter = function (key)
            if this.getApplication() then
                this.getApplication().controlCharacter(key);
            elseif this.getLauncher() then
                this.getLauncher().controlCharacter(key);
            end
        end

        this.control = function (key)
            if this.getApplication() then
                this.getApplication().control(key);
            elseif this.getLauncher() then
                this.getLauncher().control(key);
            end
        end
    -- control section end

    --application section
        this.setApps = function (apps)
            _apps = apps;
        end

        this.getApps = function ()
            return _apps;
        end

        this.runApplication = function (appIndex)
            _app = _apps[appIndex](_launcher);
        end

        this.setApplication = function (appClass, subApp)
            subApp = subApp or false;

            if appClass == nil then
                _app = nil;
                return;
            end

            if subApp then
                _app = appClass(this.getLauncher());
            else
                _app = appClass(this);
            end
        end

        this.getApplication = function()
            return _app;
        end
    --application section end

    --screen section
        this.invalidate = function ()
            dxSetRenderTarget(_screenRenderTarget, true);

            if this.getApplication() then
                this.getApplication().draw(_screenRenderTarget);
                this.getLauncher().draw(true, tocolor(255, 255, 255, 255));
            else
                this.getLauncher().draw();
            end

            dxSetRenderTarget();
        end

        this.createScreenRenderTarget = function ()
            if _screenRenderTarget then
                if isElement(_screenRenderTarget) then
                    destroyElement(_screenRenderTarget);
                end
                _screenRenderTarget = nil;
            end
            _screenRenderTarget = dxCreateRenderTarget(this.getProperty('screen_width') or 0, this.getProperty('screen_height') or 0, false);
            this.invalidate();
        end

        this.getScreenRenderTarget = function ()
            return _screenRenderTarget;
        end
    --screen section end

    --dimension section
        this.getBoundingBox = function ()
            local box = {};
            box.x = _x;
            box.y = _y;
            box.width = this.getProperty('width');
            box.height = this.getProperty('height');
            return box;
        end

        this.getScreenBoundingBox = function ()
            local box = this.getBoundingBox();
            local screenBox = {};
            screenBox.x = box.x + (this.getProperty('screen_offset_x') or 0);
            screenBox.y = box.y + (this.getProperty('screen_offset_y') or 0);
            screenBox.width = this.getProperty('screen_width') or 0;
            screenBox.height = this.getProperty('screen_height') or 0;
            return screenBox;
        end
    --dimension section end

    --drawing section
        this.draw = function ()
            this.invalidate();

            this.onDraw();
        end
    --drawing section

    return this;
end