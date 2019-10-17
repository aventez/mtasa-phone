phone.PhoneInfo = {};
phone.PhoneInfo.__index = phone.Application();

setmetatable(phone.PhoneInfo, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.PhoneInfo.getIcon()
	return 'files/icons/icons1.png';
end


function phone.PhoneInfo.__constructor (...)
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
            number = nil,
            labels = {
            	{
            		key = 'Numer telefonu',
            		value = p.getConfig('phoneNumber') or 1
            	},
            	{
            		key = 'Model i wersja telefonu',
            		value = p.getConfig('phoneModel') or 'devPhone'
            	}
            }
        };

    	this.setAttribute('headerHeight', 50);
    	this.setAttribute('contentMargin', 10);
    	this.setAttribute('contentMarginTop', 30);
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
    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

    		local headerHeight = this.getAttribute('headerHeight');
    		local marginTop = this.getAttribute('contentMarginTop');

    		for k, v in pairs(data.labels) do
    			this.drawLabel(k-1, v);
    		end
    	end

    	this.drawLabel = function (index, text)
    	    local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

    		local headerHeight = this.getAttribute('headerHeight');
    		local marginTop = this.getAttribute('contentMarginTop');

    		dxDrawText(text.key, 
    			0, 
    			headerHeight + (index * marginTop) + 10, 
    			width, 
    			height, 
    			tocolor(0, 0, 0, 255),
    			1,
    			1,
    			Fonts.font,
    			'center');

    		dxDrawText(text.value, 
    			0, 
    			headerHeight + (index * marginTop) + 25, 
    			width, 
    			height, 
    			tocolor(0, 0, 0, 255),
    			1,
    			1,
    			Fonts.miniFont,
    			'center');
    	end
    -- drawing section end

    -- control section
    	this.controlBack = function (value)
    		p.setApplication(phone.Settings, true);
    	end
    -- control section end

    return this;
end