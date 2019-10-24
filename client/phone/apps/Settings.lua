phone.Settings = {};
phone.Settings.__index = phone.Application();

setmetatable(phone.Settings, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Settings.getIcon()
	return 'files/icons/icons0.png';
end

function phone.Settings.__constructor (...)
	local this = phone.Application(...);
	
	-- options section
		local selectedOption = 1;
		local _options = {};

		this.addOption = function (optType, optID, optName, value, app)
			table.insert(_options, {
				id = optID,
				type = optType,
				name = optName,
				value = value or nil
			});
		end

		this.getOptions = function ()
			return _options;
		end
	-- options section end

	-- variables section
		local p = this.getLauncher().getPhone();

		this.setAttribute('headerHeight', 50);
		this.setAttribute('optionSize', 30);
		this.setAttribute('contentMarginLeft', 10);
		this.setAttribute('contentMarginRight', 10);
		this.setAttribute('contentMarginTop', 5);

		this.addOption('switch', 'intro', 'Ekran startowy', p.getConfig('intro'));
		this.addOption('switch', 'muted', 'Wyciszenie', p.getConfig('muted'));
		this.addOption('click', 'info', 'Informacje o telefonie', phone.PhoneInfo);
	-- variables section end

	-- drawing section
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

			local marginTop = this.getAttribute('headerHeight') + this.getAttribute('contentMarginTop');
			local optSize = this.getAttribute('optionSize');
			local marginLeft = this.getAttribute('contentMarginLeft');
			local marginRight = this.getAttribute('contentMarginRight');

			for k, v in ipairs(_options) do
				this.drawOption(k, v);
			end
		end

		this.drawOption = function (index, data)
			local width = p.getProperty('screen_width') or 0;

			local marginTop = this.getAttribute('headerHeight') + this.getAttribute('contentMarginTop');
			local optSize = this.getAttribute('optionSize');
			local marginLeft = this.getAttribute('contentMarginLeft');
			local marginRight = this.getAttribute('contentMarginRight');

			local imageSizes = {
				width = 21,
				height = 13.5
			};

			local height = marginTop + ((index-1)*optSize) - this.getAttribute('contentMarginTop');

			if index == selectedOption then
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

			if data.type == 'switch' then
				local name = 'files/disabled.png';

				if(data.value) then
					name = 'files/enabled.png';
				end

				dxDrawImage(width - imageSizes.width - marginRight,
					marginTop + ((index-1)*optSize),
					imageSizes.width,
					imageSizes.height,
					name);
			end
		end
    -- drawing section end

    -- control section
    	this.control = function (value)
    		local controlType = Controls.getControlType(value);

    		if controlType == 'TYPE_ENTER' then
		    	local option = this.getOptions()[selectedOption];

		    	if option.type == 'switch' then
			    	option.value = not option.value;

		    		p.setConfig(option.id, option.value); 		
			    elseif option.type == 'click' then
			    	p.setApplication(option.value, true);
			    end
    		elseif controlType == 'TYPE_BACK' then
    			this.onClose(p);
    		elseif controlType == 'TYPE_UP' then
    			this.switchSelected(-1);
    		elseif controlType == 'TYPE_DOWN' then
    			this.switchSelected(1);
    		end
    	end

		this.switchSelected = function (value)
			local new = selectedOption + value;

			if new > #this.getOptions() then
				new = 1;
			elseif new <= 0 then
				new = #this.getOptions();
			end

			selectedOption = new;
		end
    -- control section end

    return this;
end