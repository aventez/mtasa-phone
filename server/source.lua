function getPhoneConfig()
	-- get user phone item uid
	-- select phone data from database
	-- parse to json

	local data = {
		intro = true,
		muted = false,
		contacts = {
			{
				id = 1,
				name = 'Testowy kontakt',
				number = 123456789
			},
		},
		messages = {
			{
				id = 1,
				sender = 123,
				content = 'test123'
			},
			{
				id = 2,
				sender = 123,
				content = 'test1234'
			},
			{
				id = 3,
				sender = 321,
				content = 'test321'
			}
		}
	};

	triggerClientEvent(client, 'onResponsePhoneData', client, data);
end

addEvent('getPhoneConfig', true);
addEventHandler('getPhoneConfig', resourceRoot, getPhoneConfig);

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

function onClientAddContact(data)
	print(toJSON(data));
end

addEvent('onClientAddContact', true);
addEventHandler('onClientAddContact', resourceRoot, onClientAddContact);