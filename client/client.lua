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

addEvent('removePhone', true);
addEventHandler('removePhone', getLocalPlayer(), function ()
	userphone = nil;
end);
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
	        if userphone.getApplication() then
	            userphone.getApplication().onClose(userphone);
	        end
		end
	end
end

function changePhoneState()
	if not userphone then return end;

	if animation.startTime ~= 0 then return end; -- antispam

	if not show then
		animation.startTime = getTickCount();
		animation.fadeIn = true;

		addEventHandler('onClientRender', root, drawPhone);

		if userphone.getConfig('pin') and not userphone.getApplication() then
			userphone.setLauncher(phone.PinLauncher);
		elseif userphone.getConfig('intro') and not userphone.getApplication() then
			userphone.setLauncher(phone.IntroLauncher);
		end

	    addEventHandler('onClientPreRender', root, phoneAnimation);

	    toggleControl('fire', false);
	else
		animation.startTime = getTickCount();
		animation.fadeIn = false;

	    addEventHandler('onClientPreRender', root, phoneAnimation);

	    toggleControl('fire', true);
	end

	show = not show;
end
bindKey('end', 'up', changePhoneState);

--server section
	addEvent('onResponsePhoneData', true);
	addEventHandler('onResponsePhoneData', getLocalPlayer(), function (array)
		if userphone then
		    for k, v in pairs(array) do
				userphone.setConfig(k, v);
		    end
		end		
	end);

	addEvent('onResponseNewTopic', true);
	addEventHandler('onResponseNewTopic', getLocalPlayer(), function (data)
		local array = userphone.getConfig('topics');
		table.insert(array, data);

		userphone.setConfig('topics', array);
		userphone.setApplication(phone.Messenger);
	end);

	addEvent('onResponseTopicMessages', true);
	addEventHandler('onResponseTopicMessages', getLocalPlayer(), function (array)
		if userphone then
			userphone.setAttribute('messengerMessages', {
				messages = array
			});

			userphone.setApplication(phone.Messages);
		end
	end);
--server section end

addEventHandler('onClientKey', root, function (button, state)
	if userphone and state then
		userphone.control(button);
	end
end);