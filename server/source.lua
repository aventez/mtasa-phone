function getPhoneConfig()
	-- get user phone item uid
	-- select phone data from database
	-- parse to json

	local data = {
		intro = true,
		muted = false,
		phoneNumber = 665217234,
		phoneModel = 'devPhone Standard - v0.1',
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
				sender = 123456789,
				receiver = 665217234,
				content = 'Siema asfasfasf'
			},
			{
				id = 2,
				sender = 123456789,
				receiver = 665217234,
				content = 'co tam'
			},
			{
				id = 3,
				sender = 321,
				receiver = 665217234,
				content = 'test321'
			},
			{
				id = 4,
				sender = 123456789,
				receiver = 665217234,
				content = 'testset'
			},
			{
				id = 5,
				sender = 123456789,
				receiver = 665217234,
				content = 'asdasd'
			},
			{
				id = 6,
				sender = 665217234,
				receiver = 123456789,
				content = 'ok'
			},
			{
				id = 7,
				sender = 665217234,
				receiver = 123456789,
				content = 'asfasfa'
			},
			{
				id = 8,
				sender = 123456789,
				receiver = 665217234,
				content = 'test'
			},
			{
				id = 9,
				sender = 123456789,
				receiver = 665217234,
				content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				id = 10,
				sender = 665217234,
				receiver = 123456789,
				content = 'zxc'
			},
			{
				id = 11,
				sender = 665217234,
				receiver = 123456789,
				content = 'siema co tam powiem ze mlodszy pacha to jebany dzban'
			}
		}
	}

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