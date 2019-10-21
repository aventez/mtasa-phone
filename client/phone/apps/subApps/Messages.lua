phone.Messages = {};
phone.Messages.__index = phone.Application();

setmetatable(phone.Messages, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Messages.__constructor (...)
	local this = phone.Application(...);

	-- default attributes section
		this.setAttribute('statusbarHeight', 38);
		this.setAttribute('headerHeight', 51);
		this.setAttribute('optSize', 40);
		this.setAttribute('margin', 25);
		this.setAttribute('distance', 10);
		this.setAttribute('marginBottom', 70);
		this.setAttribute('maxLength', 143);
	-- default attributes section end

	-- variables section

		local p = this.getLauncher();

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

		local delaySettings = {
			delay = 3000,
			lastMessage = 0,
		};
	-- variables section end

	local getOptions = function ()
		return _options;
	end

	-- drawing section
		this.draw = function (renderTarget)
			local width = p.getProperty('screen_width') or 0;
			local height = p.getProperty('screen_height') or 0;

			local margin = this.getAttribute('margin');
			local statusbarHeight = this.getAttribute('statusbarHeight');
			local headerHeight = this.getAttribute('headerHeight');

			dxDrawRectangle(0, 0, width, height, 0xFF111111);

			-- drawing background
			dxDrawImage(0, 0, width, height, 'files/messenger/background.png');

			dxDrawText(number,
				0, 
				0,
				width,
				95,
				textColor,
				1,
				1,
				Fonts.font,
				'center',
				'bottom',
				false,
				true);

			-- drawing label
			if content == '' then
				dxDrawText('Wiadomość',
					0,
					height-51,
					155,
					height-51+40,
					tocolor(255, 255, 255, 133),
					1,
					1,
					Fonts.font,
					'right',
					'center',
					false,
					false);
			else
				dxDrawText(content,
					0,
					height-51,
					155,
					height-51+40,
					textColor,
					1,
					1,
					Fonts.font,
					'right',
					'center',
					false,
					false);
			end

			-- drawing messages
	        this.drawContent();
	    end

	    this.drawContent = function ()
	    	local data = p.getAttribute('messengerMessages');
			local height = p.getProperty('screen_height') or 0;
			local marginBottom = this.getAttribute('marginBottom');

			lastY = height - marginBottom;
			size = 0;

			if data.messages then
				for i = #data.messages, 1, -1 do
					--outputChatBox(toJSON(data.messages[i]));
					this.drawMessage(data.messages[i]);
				end
			end
		end

		this.drawMessage = function (data)
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
					local color = tocolor(255, 255, 255, 28);
					local textColor = 0xFFC4C4C4;
				-- default colors end

				-- positions vars
					local x = nil;
					local y = nil;
				-- positions vars end

				-- text length
					local rowLen = dxGetTextWidth(data.content, 1, Fonts.font)+20;
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
					color = tocolor(255, 255, 255, 47);
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
				outputChatBox('destroy');
				p.setApplication(phone.Messenger, true);
			else
				content = string.sub(content, 1, strLength-1);
				playSound("files/tock.mp3");
			end
		end

		this.controlEnter = function ()
			local strLength = string.len(content);

			if strLength > 0 then
				if getTickCount() > delaySettings.lastMessage + delaySettings.delay then
					p.addMessage(contact.id, p.getConfig('phoneNumber'), content);

					local new = p.getAttribute('messengerMessages');
					table.insert(new.messages, {
						number = p.getConfig('phoneNumber'),
						content = content,
						topic = contact.id,
					});
					p.setAttribute('messengerMessages', new);

					delaySettings.lastMessage = getTickCount();

					content = '';
				end
			end
		end

		this.controlNumber = function (value)
			if string.len(content) > 150 then
				return;
			end

			playSound("files/tock.mp3");

			content = string.format('%s%s', content, value);
		end

		this.controlLetter = function (value)
			if string.len(content) > 150 then
				return;
			end

			if getKeyState("lshift") then
				value = string.upper(value);
			elseif getKeyState("lalt") then
				if value == 'a' then
					value = 'ą';
				elseif value == 'e' then
					value = 'ę';
				elseif value == 'z' then
					value = 'ż';
				elseif value == 'x' then
					value = 'ź';
				elseif value == 'l' then
					value = 'ł';
				elseif value == 'o' then
					value = 'ó'; 
				end
			end

			playSound("files/tock.mp3");

			content = string.format('%s%s', content, value);		
		end
    -- control section end

    return this;
end