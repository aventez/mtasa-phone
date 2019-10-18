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
	
    -- default variables section
        local p = this.getLauncher().getPhone();
        local data = {
            number = ''
        };
    -- default variables section end

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
    		local number = data.number;

    		if number == '' then
    			number = 'Wprowadź numer';
    		end

    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

            dxDrawImage(0, 0, width, height, 'files/dialing/background.png');

    		dxDrawText(number,
                0, 
                70, 
                width, 
                height,
                0xFFFFFFFF,
                1,
                Fonts.bigFont or 'default',
                'center',
                'top',
                true, 
                true,
                false, --postGUI
                false, 
                true,
                0, 0, 0);
    	end
    -- drawing section end

    -- control section
    	this.controlNumber = function (value)
    		if data.number then
    			if string.len(data.number) > 10 then
    				return;
    			end
    		end
    		
    		data.number = string.format('%s%s', data.number or '', value);

            playSound("files/button.mp3");
    	end

    	this.controlBack = function (value)
			local strLength = string.len(data.number);

			if strLength <= 0 then
                this.onClose(p);
			else
				data.number = string.sub(data.number, 1, strLength-1);
                playSound("files/tock.mp3");
			end
    	end

    	this.controlEnter = function ()
    		if data.number then
                if string.len(data.number) > 0 then 
                    p.phoneCall(data.number);
    			    p.closePhone();
                end
            end
    	end
    -- control section end

    return this;
end