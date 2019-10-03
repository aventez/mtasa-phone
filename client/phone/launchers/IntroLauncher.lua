phone.IntroLauncher = {};
phone.IntroLauncher.__index = phone.Launcher();

local alpha = 0;

setmetatable(phone.IntroLauncher, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.IntroLauncher.__constructor (...)
	local this = phone.Launcher(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
    end
    
    this.draw = function ()
    	this.increaseAlphaValue(2);

    	dxDrawImage(0, 0, this.getPhone().getProperty('screen_width'), this.getPhone().getProperty('screen_height'), 'files/intro.png', 0, 0, 0, tocolor(255,255,255,alpha));

    	if(alpha >= 255) then
    		-- disabling intro
    		alpha = 0;
    		this.getPhone().setLauncher(phone.AppleLauncher);
    		return;
    	end
    end
    
    this.increaseAlphaValue = function (value)
    	alpha = alpha + value;
	end

    return this;
end