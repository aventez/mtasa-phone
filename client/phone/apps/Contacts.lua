phone.Contacts = {};
phone.Contacts.__index = phone.Application();

setmetatable(phone.Contacts, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Contacts.getIcon()
	return 'files/icons/icons3.png';
end

function phone.Contacts.__constructor (...)
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

	local phone = this.getLauncher().getPhone();
	local contacts = phone.getConfig('contacts');
	local selected = 1;
	local pickedContact = nil;
	local maxContacts = 8;
	local section = {
		first = 1,
		last = 8
	};

	this.drawHeader = function ()
		local width = phone.getProperty('screen_width') or 0;
		local height = this.getAttribute('headerHeight');

		dxDrawRectangle(0, 0, width, height, 0xFFEEFBF2);
		dxDrawLine(0, height, width, height, 0xFFB2B2B2);
		
		dxDrawText('Kontakty',
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
		local width = phone.getProperty('screen_width') or 0;
		local height = phone.getProperty('screen_height') or 0;

		-- drawing background
        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

        -- draw app content
        if pickedContact ~= nil then
        	local data = contacts[pickedContact];
			this.drawContactPage(data);
        else
        	this.drawHeader();
        	this.drawContent();
    	end
    end

	this.drawContent = function ()
		for i = 1, maxContacts do
			newIndex = (section.first + i) - 1;

			if contacts[newIndex] then
				this.drawContact(i, contacts[newIndex]);
			end
		end
	end

	this.drawContactPage = function (data)
		local width = phone.getProperty('screen_width') or 0;
		local height = phone.getProperty('screen_height') or 0;

		local marginTop = this.getAttribute('contentMarginTop') + 15;
		local marginLeft = 10;

		local imageSize = 48;

		dxDrawImage(width/2 - imageSize/2, marginTop, imageSize, imageSize, 'files/avatar.png');

		dxDrawText(data.name,
			0, 
			marginTop + imageSize,
			width, 
			height, 
			0xFF000000, 
			1,
			Fonts.fontBig or 'default',
			'center',
			'top',
			false,
			true);

		dxDrawText(data.number,
			marginLeft, 
			marginTop + imageSize + 15, 
			width - 5, 
			height, 
			0xFF000000, 
			1,
			Fonts.miniFont or 'default',
			'center',
			'top');
	end

	this.drawContact = function (index, data)
		local width = phone.getProperty('screen_width') or 0;

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

		dxDrawText(data.name,
			marginLeft, 
			marginTop + ((index-1)*optSize), 
			width, 
			height, 
			0xFF000000, 
			1,
			Fonts.font or 'default',
			'left',
			'top');

		dxDrawText(data.number,
			marginLeft, 
			marginTop + ((index-1)*optSize) + 12, 
			width - 5, 
			height, 
			0xFF000000, 
			1,
			Fonts.miniFont or 'default',
			'right',
			'top');
	end

	-- control section
	    this.controlEnter = function () 
	    	local index = (section.first + selected) - 1;

			pickedContact = index;

	    	outputChatBox('interaction with: ' .. index);
	    	-- contact management
		end

	    this.controlBack = function () 
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
    -- control section end

    return this;
end