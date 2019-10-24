-- DEBUG SECTION
function debugPhone(player, commandName, id)
	if id then
		givePhone(player, id or 1);
	else
		removePhone(player);
	end
end
addCommandHandler("phone", debugPhone);
-- DEBUG SECTION END

function removePhone(client)
	triggerClientEvent(client, 'onRemovePhone', client);
end

function givePhone(client, id)
	local phoneId = id;

	local phoneData = getPhoneData(phoneId)[1];
	local options = fromJSON(phoneData.options);

	local number = phoneData.number;
	local model = phoneData.model;

	local data = {
		phoneId = phoneId,
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

	setElementData(client, 'phoneNumber', number);

	triggerClientEvent(client, 'onResponsePhoneData', client, data);
end

-- GETTERS
function getPhoneData(id)
	local result =  exports.rp_database:queryResult(string.format('SELECT * FROM phones WHERE id = %d', id));

	return result;
end

function getTopics(phoneNumber)
	if phoneNumber then
		--local result = exports.rp_database:queryResult(string.format('SELECT * FROM topics WHERE first = %d or second = %d', phoneNumber, phoneNumber));
		local result = {
			{
				id = 1,
				first = 665217234,
				second = 530936262
			},
			{
				id = 2,
				first = 530936262,
				second = 123456789
			}
		};

		return result;
	end
end

function getContacts(phoneId)
	if phoneId then
		--local result = exports.rp_database:queryResult(string.format('SELECT * FROM phone_contacts WHERE phone = "%d"', phoneId));
		local result = {
			{
				id = 1,
				name = 'Test contact',
				number = 123456789,
				phone = phoneId
			}
		}

		return result;
	end
end

addEvent('getTopicMessages', true);
addEventHandler('getTopicMessages', resourceRoot, function (topic)
	if topic then
		--local result = exports.rp_database:queryResult(string.format('SELECT * FROM messages WHERE topic = %d', topic));

		-- DEBUG
		local result = {
			{
				id = 1,
				number = 530936262,
				content = 'siema'
			},
			{
				id = 2,
				number = 665217234,
				content = 'elo'
			}
		};

		triggerClientEvent(client, 'onResponseTopicMessages', client, result);
	end
end);




addEvent('addNewTopic', true);
addEventHandler('addNewTopic', resourceRoot, function (first, second)
	outputDebugString('TODO - new topic');
	--local _, _, insertid = exports.rp_database:queryResult(string.format('INSERT INTO topics VALUES (null, %d, %d)', first, second));

	--[[triggerClientEvent(client, 'onResponseNewTopic', client, {
		id = insertid,
		first = first,
		second = second
	});]]
end);

addEvent('savePhoneConfig', true);
addEventHandler('savePhoneConfig', resourceRoot, function (config)
	outputDebugString('TODO - save config');
end);

addEvent('addNewMessage', true);
addEventHandler('addNewMessage', resourceRoot, function (topic, number, content)
	--local _, _, insertid = exports.rp_database:queryResult(string.format('INSERT INTO messages VALUES (null, %d, %d, "%s")', topic, number, content));
	outputDebugString('TODO - new message');
end);

addEvent('onClientPhoneCall', true);
addEventHandler('onClientPhoneCall', resourceRoot, function (number)
	outputDebugString('TODO - phone call');
end);

addEvent('onClientAddContact', true);
addEventHandler('onClientAddContact', resourceRoot, function (name, number, phone)
	--local _, _, insertid = exports.rp_database:queryResult(string.format('INSERT INTO phone_contacts VALUES (null, "%s", %d, %d)', name, number, phone));
	outputDebugString('TODO - add contact');
end);

addEvent('onClientRemoveContact', true);
addEventHandler('onClientRemoveContact', resourceRoot, function (id)
	outputDebugString('TODO - remove contact');
end);