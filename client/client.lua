local screenX, screenY = guiGetScreenSize();
local show = false;
local animation = {
	positions = {
		on = screenY-screenY/1.80,
		off = screenY
	},
	fadeIn = false,
	duration = 200,
	startTime = 0,
	progress = 0
};
local letters = {
	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'space'
};

local userphone = nil;

function givePhone(model)
	if model == 'apple' then
		userphone = phone.Apple();

		-- default values
		userphone.setX(screenX-screenX/6);
		userphone.setY(animation.positions.off);
		userphone.loadConfig();
		userphone.setApps({
			phone.PhoneApp,
			phone.Messenger,
			phone.Contacts,
			phone.Weather,
			phone.Settings
		});

		-- interaction section
		userphone.onClosePhone = function ()
			changePhoneState();
		end
		-- interaction section end
	end
end
addEvent('givePhone', true);
addEventHandler('givePhone', getLocalPlayer(), givePhone);

function removePhone()
	userphone = nil;
end
addEvent('removePhone', true);
addEventHandler('removePhone', getLocalPlayer(), removePhone);
-- end user phone section

givePhone('apple'); -- debug

function drawPhone()
	if userphone == nil then return end

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
	if not userphone then return end;

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

	    toggleControl('fire', false);
	else
		animation.startTime = getTickCount();
		animation.fadeIn = false;

		unbindControlKeys();

	    addEventHandler('onClientPreRender', root, phoneAnimation);

	    toggleControl('fire', true);
	end

	show = not show;
end
bindKey('end', 'up', changePhoneState);

--control section
	function controlEnter()
		if userphone then
	    	userphone.controlEnter();
	    end
	end

	function controlBack()
		if userphone then
	    	userphone.controlBack();
		end
	end

	function controlUp()
		if userphone then
			userphone.controlUp();
		end
	end

	function controlDown()
		if userphone then
			userphone.controlDown();
		end
	end

	function controlNumber(value)
		if userphone then
			userphone.controlNumber(value);
		end
	end

	function controlLetter(value)
		if userphone then
			if value == 'space' then
				value = ' ';
			end

			userphone.controlLetter(value);
		end
	end

	function bindControlKeys()
		bindKey('mouse_wheel_up', 'down', controlUp);
		bindKey('mouse_wheel_down', 'down', controlDown);
		bindKey('mouse1', 'up', controlEnter);
		bindKey('mouse2', 'up', controlBack);
		bindKey('backspace', 'up', controlBack);

		for k, v in pairs(letters) do
			bindKey(letters[k], 'up', controlLetter);
		end

		for i = 0, 9 do
			bindKey(i, 'up', controlNumber);
		end

		-- bind letters
	end

	function unbindControlKeys()
		unbindKey('mouse_wheel_up', 'down', controlUp);
		unbindKey('mouse_wheel_down', 'down', controlDown);
		unbindKey('mouse1', 'up', controlEnter);
		unbindKey('mouse2', 'up', controlBack);
		unbindKey('backspace', 'up', controlBack);

		for k, v in pairs(letters) do
			unbindKey(letters[k], 'up', controlLetter);
		end

		for i=0,9 do
			unbindKey(i, 'up', controlNumber);
		end

		-- bind letters
	end
--control section end

--server section
	function onResponsePhoneData(array)
		if userphone then
		    for k, v in pairs(array) do
				userphone.setConfig(k, v);
		    end
		end
	end
	addEvent('onResponsePhoneData', true);
	addEventHandler('onResponsePhoneData', getLocalPlayer(), onResponsePhoneData);


	function onResponseTopicMessages(array)
		if userphone then
			userphone.setAttribute('messengerMessages', {
				messages = array
			});

			userphone.setApplication(phone.Messages);
		end
	end
	addEvent('onResponseTopicMessages', true);
	addEventHandler('onResponseTopicMessages', getLocalPlayer(), onResponseTopicMessages);
--server section end