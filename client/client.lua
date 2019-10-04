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
userphone.loadConfig();
userphone.setApps({
	phone.PhoneApp,
	phone.Contacts,
	phone.Settings
});
-- end user phone section

-- interaction section
userphone.onClosePhone = function ()
	changePhoneState();
end
-- interaction section end

function drawPhone()
    if userphone.getY() ~= animation.positions.off then
    	userphone.draw();
    end
end

function phoneAnimation()
	local diff = getTickCount() - animation.startTime;
	local progress = diff / animation.duration;

	if animation.fadeIn == true then
    	newY = interpolateBetween(animation.positions.off, 0, 0, animation.positions.on, 0, 0, progress, "Linear")
    else
    	newY = interpolateBetween(animation.positions.on, 0, 0, animation.positions.off, 0, 0, progress, "Linear")
    end

	userphone.setY(newY);

	if(progress >= 1) then
		animation.startTime = 0;
		animation.progress = 0;

		removeEventHandler('onClientPreRender', root, phoneAnimation);

		if not animation.fadeIn then
			removeEventHandler('onClientRender', root, drawPhone);
		end
	end
end

function changePhoneState()
	if animation.startTime ~= 0 then return end; -- antispam

	if not show then
		animation.startTime = getTickCount();
		animation.fadeIn = true;

		bindControlKeys();
		addEventHandler('onClientRender', root, drawPhone);

		if userphone.getConfig('intro') and not userphone.getApplication() then
			userphone.setLauncher(phone.IntroLauncher);
		end

	    addEventHandler('onClientPreRender', root, phoneAnimation);
	else
		animation.startTime = getTickCount();
		animation.fadeIn = false;

		unbindControlKeys();

	    addEventHandler('onClientPreRender', root, phoneAnimation);
	end

	show = not show;
end

--control section
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

	function controlUp()
		userphone.controlUp();
	end

	function controlDown()
		userphone.controlDown();
	end

	function controlNumber(value)
		userphone.controlNumber(value);
	end

	function bindControlKeys()
		bindKey('arrow_u', 'up', controlUp);
		bindKey('arrow_d', 'up', controlDown);
		bindKey('arrow_r', 'up', controlRight);
		bindKey('arrow_l', 'up', controlLeft);
		bindKey('enter', 'up', controlEnter);
		bindKey('backspace', 'up', controlBack);

		for i = 0, 9 do
			bindKey(i, 'up', controlNumber);
		end
	end

	function unbindControlKeys()
		unbindKey('arrow_u', 'up', controlUp);
		unbindKey('arrow_d', 'up', controlDown);
		unbindKey('arrow_r', 'up', controlRight);
		unbindKey('arrow_l', 'up', controlLeft);
		unbindKey('enter', 'up', controlEnter);
		unbindKey('backspace', 'up', controlBack);

		for i=0,9 do
			unbindKey(i, 'up', controlNumber);
		end
	end
--control section end

bindKey('end', 'up', changePhoneState);

--server section

function onResponsePhoneData(array)
    for k, v in pairs(array) do
		userphone.setConfig(k, v);
    end

end

addEvent('onResponsePhoneData', true);
addEventHandler('onResponsePhoneData', getLocalPlayer(), onResponsePhoneData);
--server section end