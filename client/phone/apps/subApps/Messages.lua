phone.Messages = {};
phone.Messages.__index = phone.Application();

setmetatable(phone.Messages, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Messages.__constructor (...)
	local this = phone.Application(...);

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
	end

	-- default attributes section
		this.setAttribute('statusbarHeight', 38);
		this.setAttribute('headerHeight', 51);
		this.setAttribute('optSize', 40);
		this.setAttribute('margin', 25);
		this.setAttribute('distance', 10);
		this.setAttribute('marginBottom', 70);
		this.setAttribute('maxLength', 123);
	-- default attributes section end

	-- variables section
		local p = this.getLauncher();

		local _elements = {};
		
		local messages = p.getAttribute('messengerMessages');
		local contact = p.getAttribute('messengerContact');

		if contact.first == p.getConfig('phoneNumber') then
			number = contact.second;
		else
			number = contact.first;			
		end

		local found = p.findContact(number);
		if found then
			number = found.name;
		end

		local width = p.getProperty('screen_width') or 0;
		local height = p.getProperty('screen_height') or 0;

		local lastY = nil;
		local size = 0;

		local content = '';
	-- variables section end

	local getOptions = function ()
		return _options;
	end

	-- elements section

	-- elements section end

	-- drawing section
		this.draw = function (renderTarget)
			local width = p.getProperty('screen_width') or 0;
			local height = p.getProperty('screen_height') or 0;

			local margin = this.getAttribute('margin');
			local statusbarHeight = this.getAttribute('statusbarHeight');
			local headerHeight = this.getAttribute('headerHeight');

			dxDrawRectangle(0, 0, width, height, 0xFF111111);

			-- drawing background
			dxDrawImage(0, 10, width, height, 'files/msgbg.png');

			-- drawing messages
	        this.drawContent(messages);

			-- drawing header
			dxDrawRectangle(0, statusbarHeight, width, headerHeight, 0xFF444444);
			dxDrawImage(margin, statusbarHeight + 17, 13, 18, 'files/contactsArrow.png');
			dxDrawImage(margin + 28, statusbarHeight + 12, 28, 28, 'files/avatar.png');
			
			dxDrawText(number,
				margin + 70, 
				statusbarHeight + 18,
				width,
				statusbarHeight + 12 + 10,
				textColor,
				1,
				1,
				Fonts.font,
				'left',
				'top',
				false,
				true);

			-- drawing bottom
			dxDrawImage(0, height-48, width, 48, 'files/bottom.png');

			-- drawing label
			local _content = nil;

			if content == '' then
				_content = 'Wiadomość';
			else
				_content = content;
			end

			dxDrawText(_content,
				0,
				height - 33,
				0+155,
				height - 33,
				textColor,
				1,
				1,
				Fonts.font,
				'right',
				'top',
				false,
				false);
	    end

	    this.drawContent = function (data)
	   		local width = p.getProperty('screen_width') or 0;
			local height = p.getProperty('screen_height') or 0;

			local optSize = this.getAttribute('optSize');
			local marginBottom = this.getAttribute('marginBottom');

			lastY = height - marginBottom;
			size = 0;

			if data.messages then
				for i = #data.messages, 1, -1 do
					local value = data.messages[i];
					this.drawMessage(i, value);
				end
			end
		end

		this.drawMessage = function (index, data)
			-- variables section
				-- attributes
					local width = p.getProperty('screen_width') or 0;
					local height = p.getProperty('screen_height') or 0;

					local optSize = this.getAttribute('optSize');
					local margin = this.getAttribute('margin');
					local distance = this.getAttribute('distance');
					local maxLength = this.getAttribute('maxLength');
				-- attributes end

				-- default colors
					local color = 0xFF444444;
					local textColor = 0xFFC4C4C4;
				-- default colors end

				-- positions vars
					local x = nil;
					local y = nil;
				-- positions vars end

				-- text length
					local rowLen = dxGetTextWidth(data.content, 1, Fonts.font)+margin;
				-- text length end
			-- variables section end


			lastY = lastY - optSize - distance;

			if rowLen >= maxLength then
				local rest = rowLen - maxLength;

				local linesCount = (rest / 104) + 1;

				for i=1,linesCount do
					optSize = optSize + 17;
					lastY = lastY - 17;
				end

				rowLen = maxLength;
			end


			-- setting position
				y = lastY;

				if data.number == p.getConfig('phoneNumber') then
					x = width - margin - rowLen;
				else
					x = margin;
					color = 0xFF0077FF;
				end
			-- setting position end

			size = size + optSize;

			if y < 100 then
				return;
			end

			-- drawing section
				dxDrawRectangle(x,
					y,
					rowLen,
					optSize,
					color);

				dxDrawText(data.content,
					x + 10,
					y + 10,
					x+rowLen - 10,
					y+optSize - 10,
					textColor,
					1,
					Fonts.font,
					'left',
					'center',
					false,
					true);
			-- drawing section end
		end
	-- drawing section end

    -- control section
	    this.controlBack = function () 
			local strLength = string.len(content);

			if strLength <= 0 then
				p.setApplication(phone.Messenger, true);
			else
				content = string.sub(content, 1, strLength-1);
			end
		end

		this.controlNumber = function (value)
			if string.len(content) > 150 then
				return;
			end

			content = string.format('%s%s', content, value);
		end

		this.controlLetter = function (value)
			if string.len(content) > 150 then
				return;
			end

			content = string.format('%s%s', content, value);		
		end
    -- control section end

    return this;
end