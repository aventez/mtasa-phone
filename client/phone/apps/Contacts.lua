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

	-- variables section
		this.setAttribute('headerHeight', 50);
		this.setAttribute('optionSize', 30);
		this.setAttribute('contentMarginLeft', 10);
		this.setAttribute('contentMarginRight', 10);
		this.setAttribute('contentMarginTop', 5);

		local _phone = this.getLauncher().getPhone();
		local contacts = _phone.getContacts();
		local selected = 1;
		local maxContacts = 8;
		local section = {
			first = 1,
			last = 8
		};
	-- variables section end

	-- drawing section
		this.draw = function (renderTarget)
			local width = _phone.getProperty('screen_width') or 0;
			local height = _phone.getProperty('screen_height') or 0;

			-- drawing background
	        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

	        -- draw app content
	    	this.drawContent();
	    end

		this.drawContent = function ()
			for i = 1, maxContacts do
				newIndex = (section.first + i) - 1;

				if contacts[newIndex] then
					this.drawContact(i, contacts[newIndex]);
				end
			end
		end

		this.drawContact = function (index, data)
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

			if data.number then
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
			else
				dxDrawText(data.name,
					marginLeft, 
					marginTop + ((index-1)*optSize), 
					width, 
					height, 
					0xFF0a84ff, 
					1,
					Fonts.font or 'default',
					'left',
					'top');				
			end
		end
	-- drawing section end

	-- control section
	    this.controlEnter = function () 
	    	local index = (section.first + selected) - 1;

	    	if index == 1 then
	    		_phone.setApplication(phone.NewContact);
	    	else
				_phone.setAttribute('contactData', contacts[index]);
				_phone.setApplication(phone.Contact);
			end
		end

	    this.controlBack = function () 
	    	this.onClose(_phone);
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

			if #contacts > maxContacts then
				if new > maxContacts then
					if newIndex > #contacts then
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
					-- no section changes
					selected = new;
				end
			else
				if new <= 0 then
					selected = #contacts;
				elseif new > #contacts then
					selected = 1;
				else
					selected = new;
				end
			end
		end

		this.changeSectionValues = function (value)
			section.first = section.first + value;
			section.last = section.last + value;
		end
    -- control section end

    return this;
end