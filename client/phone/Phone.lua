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

    --default properties
    this.setProperties({
        width = 190,
        height = 394,
        screen_offset_x = 12,
        screen_offset_y = 54,
        screen_width = 165,
        screen_height = 292,
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

    this.loadConfig = function (file)
        triggerServerEvent("getPhoneConfig", resourceRoot);
    end

    this.saveConfig = function (file)
        triggerServerEvent("savePhoneConfig", resourceRoot, _config);
    end

    this.setConfig = function (name, value)
        _config[name] = value;
    end

    this.getConfig = function (name)
        return _config[name];
    end

--config section end

-- control section
    this.controlLeft = function ()
        if this.getApplication() then
            this.getApplication().controlLeft();
        else
            this.changeSelected(-1);
        end
    end    

    this.controlRight = function ()
        if this.getApplication() then
            this.getApplication().controlRight();
        else
            this.changeSelected(1);
        end
    end

    this.controlBack = function ()
        this.setApplication(nil);
    end

    this.controlEnter = function ()
        if this.getApplication() then
            this.getApplication().controlEnter();
        else
            this.runApplication(this.getLauncher().getSelected());
        end
    end

    this.controlUp = function ()
        if this.getApplication() then
            this.getApplication().controlUp();
        else
            this.runApplication(this.getLauncher().getSelected());
        end
    end

    this.controlDown = function ()
        if this.getApplication() then
            this.getApplication().controlDown();
        else
            this.runApplication(this.getLauncher().getSelected());
        end
    end

    this.changeSelected = function (value)
        local new = this.getLauncher().getSelected() + value;

        if this.getLauncher().getSelected() == 1 and value < 0 then
            this.getLauncher().setSelected(#this.getApps());
            return;
        elseif new > #this.getApps() then
            this.getLauncher().setSelected(1);
            return;
        end

        this.getLauncher().setSelected(new);
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

    this.setApplication = function (appClass)
        if appClass == nil then 
            _app = appClass;
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
        if this.getApplication() then
            dxSetRenderTarget(_screenRenderTarget, true);
            this.getApplication().draw(_screenRenderTarget);
            _launcher.draw(true, tocolor(0, 0, 0, 255)); -- draw just statusbar
            dxSetRenderTarget();
            return;
        end

        dxSetRenderTarget(_screenRenderTarget, true);
        _launcher.draw();
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

    this.onDraw = function ()
    end

    this.draw = function ()
        this.invalidate();

        this.onDraw();
    end

    return this;
end