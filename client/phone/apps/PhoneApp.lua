phone.PhoneApp = {};
phone.PhoneApp.__index = phone.Application();

setmetatable(phone.PhoneApp, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.PhoneApp.getIcon()
	return 'files/icons/icons1.png';
end


function phone.PhoneApp.__constructor (...)
	local this = phone.Application(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end
	
	this.setAttribute('headerHeight', 50);
	this.setAttribute('contentMargin', 10);
	this.setAttribute('contentMarginTop', 10);

	local p = this.getLauncher().getPhone();

	local data = {
		number = nil
	};

	this.drawHeader = function ()
		local width = p.getProperty('screen_width') or 0;
		local height = this.getAttribute('headerHeight');

		dxDrawRectangle(0, 0, width, height, 0xFFEEFBF2);
		dxDrawLine(0, height, width, height, 0xFFB2B2B2);
		
		dxDrawText('Telefon',
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
		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

		-- drawing background
        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

        -- draw app content
        this.drawHeader();
        this.drawContent();
    end
    
    this.drawContent = function ()
		local number = data.number;
		
		if number == nil or number == '' then
			number = 'Wprowadź numer';
		end

		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

		local headerHeight = this.getAttribute('headerHeight');
		local marginTop = this.getAttribute('contentMarginTop');

		dxDrawText(number,
            0, 
            headerHeight + marginTop, 
            width, 
            height,
            0xFF000000,
            1,
            Fonts.fontBig or 'default',
            'center',
            'top',
            true, 
            true,
            false, --postGUI
            false, 
            true,
            0, 0, 0);

		dxDrawImage(0, 0, width, height, 'files/keyboard.png');
	end

    -- control section
    	this.controlNumber = function (value)
    		if data.number then
    			if string.len(data.number) > 10 then
    				return;
    			end
    		end
    		
    		data.number = string.format('%s%s', data.number or '', value);
    	end

    	this.controlBack = function (value)
    		if data.number then
    			local strLength = string.len(data.number);

    			if strLength <= 0 then
    				p.setApplication(nil);
    			else
    				data.number = string.sub(data.number, 1, strLength-1);
    			end
    		end
    	end

    	this.controlEnter = function ()
    		triggerServerEvent('onClientPhoneCall', resourceRoot, data);
			p.closePhone();
    	end
    -- control section end

    return this;
end