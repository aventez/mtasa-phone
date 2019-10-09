phone.Apple = {};
phone.Apple.__index = phone.Phone();

setmetatable(phone.Apple, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Apple.__constructor (...)
	local this = phone.Phone(..., 'Apple');

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
    end

    this.setAttribute('wallpaper', './files/wallpaper.png');
    this.setAttribute('texture', './files/Apple.png');

    if this.getConfig('intro') then
        this.setLauncher(phone.IntroLauncher);
    else
        this.setLauncher(phone.AppleLauncher);
    end

    this.createScreenRenderTarget();

    this.onDraw = function ()
        super.onDraw();

        local screenBox = this.getScreenBoundingBox();
        dxDrawImage(screenBox.x, screenBox.y, screenBox.width, screenBox.height, this.getScreenRenderTarget());

        local box = this.getBoundingBox();
        dxDrawImage(box.x, box.y, box.width, box.height, this.getAttribute('texture'));
    end
    
    return this;
end