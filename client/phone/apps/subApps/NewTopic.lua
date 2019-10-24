phone.NewTopic = {};
phone.NewTopic.__index = phone.Application();

setmetatable(phone.NewTopic, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.NewTopic.__constructor (...)
	local this = phone.Application(...);

	-- default attributes section
		this.setAttribute('headerHeight', 27);
		this.setAttribute('contentMargin', 10);
		this.setAttribute('contentMarginTop', 5);
		this.setAttribute('optSize', 30);
	-- default attributes section end

	-- variables section
		local p = this.getLauncher();

		local content = '';
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

		dxDrawText('Nowa konwersacja',
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

		dxDrawText(content,
			marginContent,
			marginTop+30,
			width,
			height,
			0xFF000000,
			1,
			Fonts.font,
			'center');
	end

    -- control section
    	this.control = function (value)
    		local controlType = Controls.getControlType(value);

    		if controlType == 'TYPE_ENTER' then
		    	if string.len(content) > 0 then
		    		local number = p.getPhoneNumber();
		    		p.addTopic(number, content);
		    	end
    		elseif controlType == 'TYPE_BACK' then
	   			local strLength = string.len(content);

				if strLength <= 0 then
					p.setApplication(phone.Messenger, true);
				else
					content = string.sub(content, 1, strLength-1);
				end
    		end
    	end

    	this.controlCharacter = function (value)
    		if Controls.isNumeric(value) then
	   			if string.len(content) > 10 then
					return;
				end

				content = string.format('%s%s', content, value);  
    		end  		
    	end
    -- control section end

    return this;
end