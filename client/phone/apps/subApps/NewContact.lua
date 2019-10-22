phone.NewContact = {};
phone.NewContact.__index = phone.Application();

setmetatable(phone.NewContact, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.NewContact.__constructor (...)
	local this = phone.Application(...);

	-- default attributes section
		this.setAttribute('headerHeight', 27);
		this.setAttribute('contentMargin', 10);
		this.setAttribute('contentMarginTop', 5);
		this.setAttribute('optSize', 30);
	-- default attributes section end

	-- variables section
		local p = this.getLauncher();

		local options = {
			{
				id = 1,
				value = nil,
				text = 'Wprowadź nazwę',
				type = 'all'
			},
			{
				id = 2,
				value = nil,
				text = 'Wprowadź numer',
				type = 'numbers'
			}
		};
		local selected = 1;

	-- variables section end

	this.draw = function (renderTarget)
		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

		-- drawing background
        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

        -- draw app content
        this.drawContent();
    end

    this.drawContent = function ()
    	local width = p.getProperty('screen_width') or 0;
		local marginTop = this.getAttribute('contentMarginTop') + this.getAttribute('headerHeight') + 15;
		local marginContent = this.getAttribute('contentMargin');
		local optSize = this.getAttribute('optSize');

		dxDrawText('Nowy kontakt',
			0, 
			marginTop,
			width, 
			height, 
			0xFF000000, 
			1,
			Fonts.fontBig or 'default',
			'center',
			'top',
			false,
			true);

		marginTop = marginTop + 30;

		for k, v in ipairs(options) do
			local index = k-1;

			if v.id == selected then
				dxDrawRectangle(marginContent, marginTop + (index * optSize), width - (marginContent * 2), optSize, 0x33000000);
			end

			if v.value and string.len(v.value or '') > 0 then
				dxDrawText(v.value,
					marginContent,
					((marginTop) + (index*optSize) + (optSize*0.25)),
					width,
					height,
					0xFF000000,
					1,
					Fonts.font,
					'center');
			else
				dxDrawText(v.text,
					marginContent,
					((marginTop) + (index*optSize) + (optSize*0.25)),
					width,
					height,
					0xFF000000,
					1,
					Fonts.font,
					'center');				
			end
		end
	end

    -- control section
    	this.control = function (value)
    		local controlType = Controls.getControlType(value);

    		if controlType == 'TYPE_ENTER' then
		    	for k, v in pairs(options) do
		    		if not v.value or string.len(v.value or '') <= 0 then
		    			return;
		    		end
		    	end

		    	p.addContact({
	           		name = options[1].value,
	           		number = options[2].value
		    	});
		    	p.setApplication(phone.Contacts, true);
    		elseif controlType == 'TYPE_BACK' then
	    		if options[selected].value then
	    			local strLength = string.len(options[selected].value);

	    			if strLength <= 0 then
	    				p.setApplication(phone.Contacts, true);
	    			else
	    				options[selected].value = string.sub(options[selected].value, 1, strLength-1);
	    			end
	    		else
	    			p.setApplication(phone.Contacts, true);
	    		end
    		elseif controlType == 'TYPE_UP' then
    			this.switchSelected(-1);
    		elseif controlType == 'TYPE_DOWN' then
    			this.switchSelected(1);
    		elseif controlType == 'TYPE_NUMBER' then
	    		if options[selected].value then
	    			if string.len(options[selected].value) > 10 then
	    				return;
	    			end
	    		end

				options[selected].value = string.format('%s%s', options[selected].value or '', value);
    		elseif controlType == 'TYPE_LETTER' then
				if options[selected].type == 'numbers' then
					return;
				end

	    		if options[selected].value then
	    			if string.len(options[selected].value) > 10 then
	    				return;
	    			end
	    		end

				options[selected].value = string.format('%s%s', options[selected].value or '', value);
    		end
    	end

		this.switchSelected = function (value)
			local new = selected + value;

			if new > #options then
				new = 1;
			elseif new <= 0 then
				new = #options;
			end

			selected = new;
		end
    -- control section end

    return this;
end