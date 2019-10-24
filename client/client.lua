local screenX, screenY = guiGetScreenSize();
local show = false;
local animation = {
	positions = {
		on = screenY-screenY/1.80,
		off = screenY
	},
	fadeIn = false,
	duration = 250,
	startTime = 0,
	progress = 0
};

local userphone = nil;


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
	addEvent('onRemovePhone', true);
	addEventHandler('onRemovePhone', getLocalPlayer(), function ()
		userphone = nil;
	end);

	addEvent('onResponsePhoneData', true);
	addEventHandler('onResponsePhoneData', getLocalPlayer(), function (array)
		userphone = phone.Apple();

		userphone.setX(screenX-screenX/6);
		userphone.setY(animation.positions.off);
		userphone.setApps({
			phone.PhoneApp,
			phone.Messenger,
			phone.Contacts,
			phone.Weather,
			phone.Settings
		});

		userphone.onClosePhone = function ()
			changePhoneState();
		end

	    for k, v in pairs(array) do
			userphone.setConfig(k, v);
	    end	
	end);

	addEvent('onResponseNewTopic', true);
	addEventHandler('onResponseNewTopic', getLocalPlayer(), function (data)
		local array = userphone.getConfig('topics');
		if array then
			table.insert(array, data);
		else
			array = {
				data
			};	
		end

		userphone.setConfig('topics', array);
		userphone.getApplication().onClose(userphone);
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

	addEvent('onClientReceivesError', true);
	addEventHandler('onClientReceivesError', root, function (message)
		if message then
			outputChatBox('an error occured: '..message);
		end
	end);

	addEvent('onIncomingCall', true);
	addEventHandler('onIncomingCall', root, function (number)
		userphone.setAttribute('incomingCallNumber', number);
		userphone.setApplication(phone.IncomingCall);
		outputChatBox('dzwoni'..number);
	end);
--server section end

addEventHandler('onClientKey', root, function (button, state)
	if userphone and state and show then
		userphone.control(button);
	end
end);

addEventHandler("onClientCharacter", getRootElement(), function (character)
	if userphone and show then
		userphone.controlCharacter(character);
	end	
end);