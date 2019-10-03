function getPhoneConfig()
	-- get user phone item uid
	-- select phone data from database
	-- parse to json

	local data = {
		intro = true,
		muted = false
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