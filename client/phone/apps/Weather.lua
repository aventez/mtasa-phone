phone.Weather = {};
phone.Weather.__index = phone.Application();

setmetatable(phone.Weather, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Weather.getIcon()
	return 'files/icons/icons4.png';
end


function phone.Weather.__constructor (...)
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
    		dxDrawImage(0, 0, width, height, 'files/weatherbg.png');

            -- draw app content
            this.drawContent();
        end
        
        this.drawContent = function ()
    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

    		local headerHeight = this.getAttribute('headerHeight');
    		local marginTop = this.getAttribute('contentMarginTop');

    		dxDrawText('Los Santos', 
    			0, 
    			headerHeight + marginTop + 10, 
    			width, 
    			height, 
    			0xFFFFFFFF,
    			1,
    			1,
    			Fonts.vbigFont,
    			'center');

    		dxDrawText('Duże zachmurzenie', 
    			0, 
    			headerHeight + (2 * marginTop) + 10, 
    			width, 
    			height, 
    			0xFFFFFFFF,
    			1,
    			1,
    			Fonts.bigFont,
    			'center');

    		dxDrawText('24°', 
    			0, 
    			headerHeight + (3 * marginTop) + 10, 
    			width, 
    			height, 
    			0xFFFFFFFF,
    			1,
    			1,
    			Fonts.mbigFont,
    			'center');
    	end
    -- drawing section end

    -- control section
    	this.controlBack = function (value)
    		p.setApplication(nil);
    	end
    -- control section end

    return this;
end