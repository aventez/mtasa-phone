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
		pin = options.pin,
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
	local result = exports.rp_database:queryResult(string.format('SELECT topics.*, messages.content FROM `topics` JOIN `messages` ON messages.id=(SELECT messages.id FROM `messages` WHERE messages.topic=topics.id ORDER BY messages.id DESC LIMIT 1) WHERE topics.first = %d OR topics.second = %d', phoneNumber, phoneNumber));

	return result;
end

function getContacts(phoneId)
	local result = exports.rp_database:queryResult(string.format('SELECT * FROM phone_contacts WHERE phone = "%d"', phoneId));

	return result;
end


function getTopicMessages(topic)
	local result = exports.rp_database:queryResult(string.format('SELECT * FROM messages WHERE topic = %d', topic));

	triggerClientEvent(client, 'onResponseTopicMessages', client, result);
end
addEvent('getTopicMessages', true);
addEventHandler('getTopicMessages', resourceRoot, getTopicMessages);

function addNewTopic(first, second)
	local _, _, insertid = exports.rp_database:queryResult(string.format('INSERT INTO topics VALUES (null, %d, %d)', first, second));

	triggerClientEvent(client, 'onResponseNewTopic', client, {
		id = insertid,
		first = first,
		second = second
	});
end
addEvent('addNewTopic', true);
addEventHandler('addNewTopic', resourceRoot, addNewTopic);

function addNewMessage(topic, number, content)
	local _, _, insertid = exports.rp_database:queryResult(string.format('INSERT INTO messages VALUES (null, %d, %d, "%s")', topic, number, content));
end
addEvent('addNewMessage', true);
addEventHandler('addNewMessage', resourceRoot, addNewMessage);

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