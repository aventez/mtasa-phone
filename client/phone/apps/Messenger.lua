phone.Messenger = {};
phone.Messenger.__index = phone.Application();

setmetatable(phone.Messenger, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Messenger.getIcon()
	return 'files/icons/icons2.png';
end

function phone.Messenger.__constructor (...)
	local this = phone.Application(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end

	this.setAttribute('headerHeight', 50);
	this.setAttribute('optionSize', 30);
	this.setAttribute('contentMarginLeft', 10);
	this.setAttribute('contentMarginRight', 10);
	this.setAttribute('contentMarginTop', 5);

	local _phone = this.getLauncher().getPhone();
	local contacts = _phone.getConfig('messages');
	local contactsList = _phone.getConfig('messagesList');
	local selected = 1;
	local maxContacts = 8;
	local section = {
		first = 1,
		last = 8
	};

	this.drawHeader = function ()
		local width = _phone.getProperty('screen_width') or 0;
		local height = this.getAttribute('headerHeight');

		dxDrawRectangle(0, 0, width, height, 0xFFEEFBF2);
		dxDrawLine(0, height, width, height, 0xFFB2B2B2);
		
		dxDrawText('Wiadomości',
            0, 
            0, 
            width, 
            height-5,
            0xFF000000,
            1,
            Fonts.font or 'default',
            'center',
            'bottom',
            true, 
            true,
            false, --postGUI
            false, 
            true,
            0, 0, 0);
	end

	this.draw = function (renderTarget)
		local width = _phone.getProperty('screen_width') or 0;
		local height = _phone.getProperty('screen_height') or 0;

		-- drawing background
        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

        -- draw app content

    	this.drawHeader();
    	this.drawContent();
    end

	this.drawContent = function ()
		--outputChatBox(toJSON(contacts));

		--outputChatBox(contacts['123']);

		--for k, v in pairs(contacts) do
			--outputChatBox(k);
		--end


		for i = 1, maxContacts do
			newIndex = (section.first + i) - 1;

			--outputChatBox(array);

			if contactsList[newIndex] then
				this.drawContact(i, contacts[contactsList[newIndex]]);
			end
		end
	end

	this.drawContact = function (index, data)
		outputChatBox(toJSON(data[1].sender));

		local width = _phone.getProperty('screen_width') or 0;

		local marginTop = this.getAttribute('headerHeight') + this.getAttribute('contentMarginTop');
		local optSize = this.getAttribute('optionSize');
		local marginLeft = this.getAttribute('contentMarginLeft');
		local marginRight = this.getAttribute('contentMarginRight');

		local height = marginTop + ((index-1)*optSize) - this.getAttribute('contentMarginTop');

		if index == selected then
			dxDrawRectangle(0, height + 1, width, optSize - 1, 0xFFB8B8B8);
		else
			dxDrawRectangle(0, height + 1, width, optSize - 1, 0xFFFFFFFF);
		end

		dxDrawLine(0, height + optSize, width, height + optSize, 0xFFc6c6c8);

		local contactName = data[1].sender;

		dxDrawText(contactName,
			marginLeft, 
			marginTop + ((index-1)*optSize), 
			width, 
			height, 
			0xFF000000, 
			1,
			Fonts.font or 'default',
			'left',
			'top');		
	end

	-- control section
	    --[[

	    this.controlEnter = function () 
	    	local index = (section.first + selected) - 1;

			_phone.setAttribute('contactData', contacts[index]);

			_phone.setApplication(phone.Contact);
		end

	    this.controlBack = function () 
	    	_phone.setApplication(nil);
		end

	    this.controlUp = function ()
	    	this.switchSelected(-1);
		end

	    this.controlDown = function ()
	    	this.switchSelected(1);
		end

		this.switchSelected = function (value)
			local new = selected + value;
			local newIndex = (section.first + new) - 1;

			if new > maxContacts then
				if newIndex > #contacts then
					-- back to down
					section = {
						first = 1,
						last = 8
					};

					selected = 1;
				else
					this.changeSectionValues(1);
					selected = maxContacts;
				end
			elseif new <= 0 then
				-- back to up
				if newIndex <= 0 then
					section = {
						first = #contacts-maxContacts+1,
						last = #contacts
					};

					selected = maxContacts;
				else
					this.changeSectionValues(-1);
					selected = 1;
				end
			else
				selected = new;
			end
		end

		this.changeSectionValues = function (value)
			section.first = section.first + value;
			section.last = section.last + value;
		end

		--]]

    -- control section end

    return this;
end