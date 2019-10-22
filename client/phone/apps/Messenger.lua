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

	-- variables section
		this.setAttribute('headerHeight', 90);
		this.setAttribute('optionSize', 72);
		this.setAttribute('contentMarginLeft', 87);
		this.setAttribute('contentMarginRight', 10);
		this.setAttribute('contentMarginTop', 15);

		local _phone = this.getLauncher().getPhone();

		local topics = _phone.getConfig('topics');
		_phone.setAttribute('messengerContact', topics[1]);

		local selected = 1;
		local maxContacts = 4;
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
	        dxDrawImage(0, 0, width, height, 'files/topics/background.png');

	        -- draw app content
	    	this.drawContent();
	    end

		this.drawContent = function ()
			for i = 1, 4 do
				newIndex = (section.first + i) - 1;

				if topics[newIndex] then
					this.drawContact(i, topics[newIndex]);
				end
			end
		end

		this.drawContact = function (index, data)
			local width = _phone.getProperty('screen_width') or 0;

			local marginTop = this.getAttribute('headerHeight') + this.getAttribute('contentMarginTop');
			local optSize = this.getAttribute('optionSize');
			local marginLeft = this.getAttribute('contentMarginLeft');
			local marginRight = this.getAttribute('contentMarginRight');

			local height = marginTop + ((index-1)*optSize) + (index-1)*20;

			local number = nil;

			if index == selected then
				dxDrawImage(20, height, 239, optSize, 'files/topics/row.png');
			else
				dxDrawImage(20, height, 239, optSize, 'files/topics/row.png', 0, 0, 0, tocolor(255, 255, 255, 99));
			end

			if data.first == _phone.getConfig('phoneNumber') then
				number = data.second;
			else
				number = data.first;			
			end

			local contact = _phone.findContact(number);
			if contact then
				number = contact.name;
			end

			dxDrawText(number,
				marginLeft, 
				height + 20, 
				width, 
				height+optSize, 
				0xFFFFFFFF, 
				1,
				Fonts.getFont('ProximaNova-Regular', 11) or 'default',
				'left',
				'top');

			dxDrawText(data.content,
				marginLeft, 
				height + 43, 
				width, 
				height+optSize, 
				0xFFFFFFFF, 
				1,
				Fonts.getFont('ProximaNova-Regular', 7) or 'default',
				'left',
				'top');
		end
	-- drawing section end

	-- control section
		this.control = function (value)
			local controlType = Controls.getControlType(value);

			if controlType == 'TYPE_ENTER' then
		    	triggerServerEvent('getTopicMessages', resourceRoot, topics[(section.first + selected) - 1].id);
			elseif controlType == 'TYPE_BACK' then
				this.onClose(_phone);
			elseif controlType == 'TYPE_UP' then
				this.switchSelected(-1);
			elseif controlType == 'TYPE_DOWN' then
				this.switchSelected(1);
			elseif controlType == 'TYPE_SPACE' then
				_phone.setApplication(phone.NewTopic);
			end
		end

		this.switchSelected = function (value)
			local new = selected + value;
			local newIndex = (section.first + new) - 1;

			if #topics > maxContacts then
				if new > maxContacts then
					if newIndex > #topics then
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
							first = #topics-maxContacts+1,
							last = #topics
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
					selected = #topics;
				elseif new > #topics then
					selected = 1;
				else
					selected = new;
				end
			end

			local index = (section.first + selected) - 1;

			_phone.setAttribute('messengerContact', topics[index]);
		end

		this.changeSectionValues = function (value)
			section.first = section.first + value;
			section.last = section.last + value;
		end
    -- control section end

    return this;
end