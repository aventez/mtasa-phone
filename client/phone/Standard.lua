phone.Standard = {};
phone.Standard.__index = phone.Phone();

setmetatable(phone.Standard, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Standard.__constructor (...)
	local this = phone.Phone(..., 'Standard');

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
    end

    this.setLauncher(phone.AppleLauncher);

    this.createScreenRenderTarget();
    
    --@Override
    this.onDraw = function ()
        super.onDraw();

        local box = this.getBoundingBox();
        dxDrawImage(box.x, box.y, box.width, box.height, this.getAttribute('texture'));

        local screenBox = this.getScreenBoundingBox();
        dxDrawImage(screenBox.x, screenBox.y, screenBox.width, screenBox.height, this.getScreenRenderTarget());
    end
    
    return this;
end