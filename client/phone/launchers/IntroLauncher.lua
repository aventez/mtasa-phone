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
    
    local animation = {
        startTime = getTickCount(),
        progress = 0,
        delayTime = 1200
    };

    this.introAnimation = function ()
        animation.progress = (getTickCount() - animation.startTime) / animation.delayTime;

        if(animation.progress >= 1) then
            this.getPhone().setLauncher(phone.AppleLauncher);
            removeEventHandler('onClientPreRender', root, this.introAnimation);  
        end
    end 

    addEventHandler('onClientPreRender', root, this.introAnimation);

    this.draw = function ()
    	dxDrawImage(0, 0, this.getPhone().getProperty('screen_width'), this.getPhone().getProperty('screen_height'), 'files/intro.png', 0, 0, 0, tocolor(255,255,255,255*animation.progress));
    end

    return this;
end