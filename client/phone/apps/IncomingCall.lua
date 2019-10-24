phone.IncomingCall = {};
phone.IncomingCall.__index = phone.Application();

setmetatable(phone.IncomingCall, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.IncomingCall.__constructor (...)
	local this = phone.Application(...);
	
    -- default variables section
        local p = this.getLauncher();
        local number = p.getAttribute('incomingCallNumber');
        local text = number;

        local found = p.findContact(number);
        if found then
            text = found.name;
        end

    -- default variables section end

    -- drawing section
    	this.draw = function (renderTarget)
    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

            -- draw app content
            this.drawContent();
        end
        
        this.drawContent = function ()
    		local width = p.getProperty('screen_width') or 0;
    		local height = p.getProperty('screen_height') or 0;

			dxDrawImage(0, 0, width, height, 'files/incomingCall/background.png');

            dxDrawText(text, 0, 80, width, height, white, 1, 1, Fonts.vbigFont, 'center', 'top');
    	end
    -- drawing section end

    -- control section
    	this.control = function (value)
            local controlType = Controls.getControlType(value);

            if controlType == 'TYPE_BACK' then
                -- decline
                p.onClose();
            elseif controlType == 'TYPE_ENTER' then
                -- accept
            end
    	end
    -- control section end

    return this;
end