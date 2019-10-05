ui.View = {};
ui.View.__index = ui.View;

setmetatable(ui.View, {
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

function ui.View.__constructor(parent, viewType)
	local this = setmetatable({}, ui.View);

	local _launcher = launcher;
    local _attributes = {};

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

    this.getLauncher = function ()
        return _launcher;
    end

    this.onDraw = function ()

    end

    this.draw = function (renderTarget)
        this.onDraw();
    end

    return this;
end