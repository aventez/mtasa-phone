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

	-- options section
	local selectedOption = 1;
	local _options = {};

	this.addOption = function (optID, optName, value)
		table.insert(_options, {
			id = optID,
			name = optName,
			data = {
				enabled = value
			}
		});
	end

	local p = this.getLauncher().getPhone();

	this.addOption('intro', 'Ekran startowy', p.getConfig('intro'));
	this.addOption('muted', 'Wyciszenie', p.getConfig('muted'));

	this.getOptions = function ()
		return _options;
	end

	-- options section end

	this.drawHeader = function ()
        local p = this.getLauncher().getPhone();
		local width = p.getProperty('screen_width') or 0;
		local height = this.getAttribute('headerHeight');

		dxDrawRectangle(0, 0, width, height, 0xFFEEFBF2);
		dxDrawLine(0, height, width, height, 0xFFB2B2B2);
		
		dxDrawText('Ustawienia',
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

	this.drawContent = function ()
		local p = this.getLauncher().getPhone();
		local width = p.getProperty('screen_width') or 0;

		local marginTop = this.getAttribute('headerHeight') + this.getAttribute('contentMarginTop');
		local optSize = this.getAttribute('optionSize');
		local marginLeft = this.getAttribute('contentMarginLeft');
		local marginRight = this.getAttribute('contentMarginRight');

		for k, v in ipairs(_options) do
			this.drawOption(k, v.name, v.data);
		end
	end

	this.drawOption = function (index, name, data)
		local p = this.getLauncher().getPhone();
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

		dxDrawText(name, 
			marginLeft, 
			marginTop + ((index-1)*optSize), 
			width, 
			height, 
			0xFF000000, 
			1,
			Fonts.font or 'default',
			'left',
			'top');

		local name = 'files/disabled.png';

		if(data.enabled) then
			name = 'files/enabled.png';
		end

		dxDrawImage(width - imageSizes.width - marginRight,
			marginTop + ((index-1)*optSize),
			imageSizes.width,
			imageSizes.height,
			name);
	end

	this.draw = function (renderTarget)
        local p = this.getLauncher().getPhone();
		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

		-- drawing background
        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

        -- draw app content
        this.drawHeader();
        this.drawContent();
    end
    
    -- control section
	    this.controlEnter = function () 
	    	local p = this.getLauncher().getPhone();
	    	local enabled = not this.getOptions()[selectedOption].data.enabled;

	    	this.getOptions()[selectedOption].data.enabled = enabled;

    		p.setConfig(this.getOptions()[selectedOption].id, enabled);

	    	p.saveConfig();
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