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
	
    -- default variables section
        local p = this.getLauncher().getPhone();
        local data = {
            number = nil,
            weather = {
            	temperature = 15,
            	type = 'sun'	
            }
        };
    -- default variables section end

    -- drawing section
    	this.draw = function (renderTarget)
    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

            -- draw app content
            this.drawContent();

            dxDrawRectangle(0, 0, width, 37, 0xFF444444);
        end
        
        this.drawContent = function ()
    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

    		if data.weather.type == 'sun' then
				dxDrawImage(0, 0, width, height, 'files/weatherbg.png');
    		end

    		dxDrawText(data.weather.temperature .. '°', 
    			0, 
    			150, 
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
    		this.onClose(p);
    	end
    -- control section end

    return this;
end