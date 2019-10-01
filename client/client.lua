local screenX, screenY = guiGetScreenSize();
local show = false;
local animation = {
	positions = {
		on = screenY-screenY/3-45,
		off = screenY
	},
	fadeIn = false,
	duration = 200,
	startTime = 0,
	progress = 0
};

-- user phone section

local userphone = phone.Apple();

-- default values
userphone.setX(screenX-screenX/9);
userphone.setY(animation.positions.off);
userphone.setApps({
	phone.Settings
});
-- end user phone section

addEventHandler('onClientRender', root, function ()
    if userphone.getY() ~= animation.positions.off then
    	userphone.draw();
    end
end);

function phoneAnimation()
	local diff = getTickCount() - animation.startTime;
	local progress = diff / animation.duration;

	if animation.fadeIn == true then
		userphone.setState(true);
		userphone.getIntro().setAlpha(0);
		
    	newY = interpolateBetween(animation.positions.off, 0, 0, animation.positions.on, 0, 0, progress, "Linear")
    else
    	newY = interpolateBetween(animation.positions.on, 0, 0, animation.positions.off, 0, 0, progress, "Linear")
    end

	userphone.setY(newY);

	if(progress >= 1) then
		animation.startTime = 0;
		animation.progress = 0;

		removeEventHandler('onClientPreRender', root, phoneAnimation);
	end
end

function showPhone()
	if animation.startTime ~= 0 then return end; -- antispam

	if not show then
		animation.startTime = getTickCount();
		animation.fadeIn = true;

	    addEventHandler('onClientPreRender', root, phoneAnimation);
	else
		animation.startTime = getTickCount();
		animation.fadeIn = false;

	    addEventHandler('onClientPreRender', root, phoneAnimation);
	end

	show = not show;
end

function controlEnter()
    userphone.controlEnter();
end

function controlBack()
    userphone.controlBack();
end

function controlRight()
    userphone.controlRight();
end

function controlLeft()
    userphone.controlLeft();
end

bindKey('end', 'up', showPhone);
bindKey('arrow_r', 'up', controlRight);
bindKey('arrow_l', 'up', controlLeft);
bindKey('enter', 'up', controlEnter);
bindKey('backspace', 'up', controlBack);