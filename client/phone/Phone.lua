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
    local _intro = nil;
    local _app = nil;

    local _state = true;

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

--intro section
    this.setIntro = function (introClass)
        _intro = introClass(this);
    end

    this.getIntro = function ()
        return _intro;
    end

    this.setState = function (state)
        _state = state;
    end

    this.getState = function ()
        return _state;
    end
--intro section end

--application section
    this.setApplication = function (appClass)
        _app = appClass(this);
    end

    this.getApplication = function()
        return _app;
    end
--application section end

--screen section
    this.invalidate = function ()
        if this.getState() then
            dxSetRenderTarget(_screenRenderTarget, true);
            this.getIntro().draw(_screenRenderTarget);
            dxSetRenderTarget();

            if(this.getIntro().getAlpha() < 175) then
                this.getIntro().setAlpha(this.getIntro().getAlpha()+1);
            else
                this.setState(false);
            end

            return;
        elseif this.getApplication() then
            dxSetRenderTarget(_screenRenderTarget, true);
            this.getApplication().draw(_screenRenderTarget);
            dxSetRenderTarget();
            return;
        end

        dxSetRenderTarget(_screenRenderTarget, true);
        _launcher.draw(_screenRenderTarget);
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