phone.Apple = {};
phone.Apple.__index = phone.Phone();

setmetatable(phone.Apple, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Apple.__constructor (...)
	local this = phone.Phone(..., 'Apple');

    this.setAttribute('wallpaper', './files/wallpapers/wallpaper.png');
    this.setAttribute('texture', './files/border.png');

    this.setLauncher(phone.AppleLauncher);

    this.createScreenRenderTarget();

    this.onDraw = function ()
        local screenBox = this.getScreenBoundingBox();
        dxDrawImage(screenBox.x, screenBox.y, screenBox.width, screenBox.height, this.getScreenRenderTarget());

        local box = this.getBoundingBox();
        dxDrawImage(box.x, box.y, box.width, box.height, this.getAttribute('texture'));
    end
    
    return this;
end