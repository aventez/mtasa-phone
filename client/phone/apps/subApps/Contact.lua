phone.Contact = {};
phone.Contact.__index = phone.Application();

setmetatable(phone.Contact, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Contact.__constructor (...)
	local this = phone.Application(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end

	-- default attributes section
		this.setAttribute('headerHeight', 27);
		this.setAttribute('contentMargin', 10);
		this.setAttribute('contentMarginTop', 5);
		this.setAttribute('imageSize', 48);
	-- default attributes section end

	-- variables section
		local p = this.getLauncher();

		local _selected = 0;
		local _data = nil;

		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

		local events = {
			callEvent = function () 
				p.phoneCall(_data);
				p.closePhone();
			end,
			messageEvent = function () end,
			deleteEvent = function () end
		};

		local _options = {
			{
				index = 0,
				name = 'Dzwoń',
				action = events.callEvent
			},
			{
				index = 1,
				name = 'SMS',
				action = events.messageEvent
			},
			{
				index = 2,
				name = 'Usuń',
				action = events.deleteEvent
			}
		};
	-- variables section end

	local getOptions = function ()
		return _options;
	end

	-- drawing section
		this.draw = function (renderTarget)
			local width = p.getProperty('screen_width') or 0;
			local height = p.getProperty('screen_height') or 0;

			-- drawing background
	        dxDrawRectangle(0, 0, width, height, (0xFFE3E3E6));

	        -- draw app content
	        this.drawContent(p.getAttribute('contactData'));
	    end

	    this.drawContent = function (data)
	    	if data == nil then
	    		return;
	    	end

	    	_data = data;

	   		local width = p.getProperty('screen_width') or 0;
			local height = p.getProperty('screen_height') or 0;

			local marginTop = this.getAttribute('contentMarginTop') + this.getAttribute('headerHeight') + 15;
			local marginContent = this.getAttribute('contentMargin');

			local imageSize = this.getAttribute('imageSize');

			dxDrawImage(width/2 - imageSize/2, marginTop, imageSize, imageSize, 'files/avatar.png');

			dxDrawText(data.name,
				0, 
				marginTop + imageSize,
				width, 
				height, 
				0xFF000000, 
				1,
				Fonts.fontBig or 'default',
				'center',
				'top',
				false,
				true);

			dxDrawText(data.number,
				marginContent, 
				marginTop + imageSize + 15, 
				width - 5, 
				height, 
				0xFF000000, 
				1,
				Fonts.miniFont or 'default',
				'center',
				'top');

			-- update marginTop for options
			marginTop = marginTop + imageSize + 30;

			local optSize = 30;

			for k, v in ipairs(_options) do
				if v.index == _selected then
					dxDrawRectangle(marginContent, marginTop + (v.index * optSize), width - (marginContent * 2), optSize, 0x33000000);
				end

				dxDrawText(v.name,
					marginContent,
					((marginTop) + (v.index*optSize) + (optSize*0.25)),
					width,
					height,
					0xFF000000,
					1,
					Fonts.font,
					'center');
			end
		end
	-- drawing section end

    -- control section
	    this.controlEnter = function () 
	    	_options[_selected + 1].action();
		end

	    this.controlBack = function ()
	    	p.setApplication(phone.Contacts, true);
		end

	    this.controlUp = function ()
	    	this.switchSelected(-1);
		end

	    this.controlDown = function ()
	    	this.switchSelected(1);
		end

		this.switchSelected = function (value)
			local new = _selected + value;

			if new > #getOptions() - 1 then
				new = 0;
			elseif new < 0 then
				new = #getOptions() - 1;
			end

			_selected = new;
		end
    -- control section end

    return this;
end