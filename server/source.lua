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
			{
				id = 2,
				name = "Test2",
				number = 987654321
			},
			{
				id = 2,
				name = "Test3",
				number = 987654321
			},
			{
				id = 2,
				name = "Test4",
				number = 987654321
			},
			{
				id = 2,
				name = "Test5",
				number = 987654321
			},
			{
				id = 2,
				name = "Test6",
				number = 987654321
			},
			{
				id = 2,
				name = "Test7",
				number = 987654321
			},
			{
				id = 2,
				name = "Test8",
				number = 987654321
			},
			{
				id = 2,
				name = "Test9",
				number = 987654321
			},
			{
				id = 2,
				name = "Test10",
				number = 987654321
			},
			{
				id = 2,
				name = "Test11",
				number = 987654321
			},
			{
				id = 2,
				name = "Test12",
				number = 987654321
			},
			{
				id = 2,
				name = "Test13",
				number = 987654321
			},
			{
				id = 2,
				name = "Test14",
				number = 987654321
			},
		},
		messages = {
			{
				id = 1,
				sender = 987654321,
				content = 'test message'
			}
		}
	};

	triggerClientEvent(client, "onResponsePhoneData", client, data);
end

addEvent("getPhoneConfig", true);
addEventHandler("getPhoneConfig", resourceRoot, getPhoneConfig);

function savePhoneConfig(config)
	-- save data to db
	print(toJSON(config));
end

addEvent("savePhoneConfig", true);
addEventHandler("savePhoneConfig", resourceRoot, savePhoneConfig);