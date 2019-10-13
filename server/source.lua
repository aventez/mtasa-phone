function getPhoneConfig()
	-- CONST PHONE UID
	local phoneId = 1;

	local phoneData = getPhoneData(phoneId)[1];
	local options = fromJSON(phoneData.options);

	local number = phoneData.number;
	local model = phoneData.model;

	local data = {
		phoneNumber = number,
		phoneModel = model,
		intro = options.intro,
		muted = options.muted,
		contacts = nil,
		topics = nil
	}

	data.contacts = getContacts(phoneId);
	data.topics = getTopics(number);

	triggerClientEvent(client, 'onResponsePhoneData', client, data);
end
addEvent('getPhoneConfig', true);
addEventHandler('getPhoneConfig', resourceRoot, getPhoneConfig);

-- GETTERS

function getPhoneData(id)
	local result =  exports.rp_database:queryResult(string.format('SELECT * FROM phones WHERE id = %d', id));

	return result;
end


function getTopics(phoneNumber)
	local result = exports.rp_database:queryResult(string.format('SELECT * FROM topics WHERE first = %d OR second = %d', phoneNumber, phoneNumber));

	return result;
end

function getContacts(phoneId)
	local result = exports.rp_database:queryResult(string.format('SELECT * FROM phone_contacts WHERE phone = "%d"', phoneId));

	return result;
end


function getTopicMessages(topic)
	local result = exports.rp_database:queryResult(string.format('SELECT * FROM messages WHERE topic = %d LIMIT 10', topic));

	triggerClientEvent(client, 'onResponseTopicMessages', client, result);
end

addEvent('getTopicMessages', true);
addEventHandler('getTopicMessages', resourceRoot, getTopicMessages);


function savePhoneConfig(config)
	-- save data to db
	print(toJSON(config));
end

addEvent('savePhoneConfig', true);
addEventHandler('savePhoneConfig', resourceRoot, savePhoneConfig);

function onClientPhoneCall(data)
	print(toJSON(data));
end

addEvent('onClientPhoneCall', true);
addEventHandler('onClientPhoneCall', resourceRoot, onClientPhoneCall);

function onClientAddContact(phone, data)
	print(toJSON(data));
end

addEvent('onClientAddContact', true);
addEventHandler('onClientAddContact', resourceRoot, onClientAddContact);





--[[function createPhone(playerSource, commandName)
	triggerClientEvent(playerSource, 'givePhone', playerSource, 'apple');
end
addCommandHandler('phone', createPhone);

function removePhone(playerSource, commandName)
	triggerClientEvent(playerSource, 'removePhone', playerSource);
end
addCommandHandler('rphone', removePhone);

addEventHandler('onPlayerJoin', getRootElement(), function () 
	createPhone(source, nil);
end)]]