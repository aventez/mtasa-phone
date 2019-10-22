Controls = {};

local types = {
	TYPE_BACK = {
		'backspace',
		'mouse2'
	},
	TYPE_ENTER = {
		'mouse1',
		'enter'
	},
	TYPE_UP = {
		'mouse_wheel_up',
		'arrow_u'
	},
	TYPE_DOWN = {
		'mouse_wheel_down',
		'arrow_d'
	},
	TYPE_SPACE = {
		'space'
	},
	TYPE_NUMBER = {
		'7', '8', '9',
		'4', '5', '6',
		'1', '2', '3', '0'
	},
	TYPE_LETTER = {
		'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
		'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
		'z', 'x', 'c', 'v', 'b', 'n', 'm'
	},
	TYPE_SPECIAL = {
		'-', '=', '[', ']', '/', "'", '.', ',', '`'
	}
};

function Controls.getControlType(key)
	if key ~= nil then		
		local _types = {};

		if string.len(key) == 1 then
			_types = {
				'TYPE_NUMBER',
				'TYPE_LETTER',
				'TYPE_SPECIAL'
			}
		else
			_types = {
				'TYPE_BACK',
				'TYPE_ENTER',
				'TYPE_UP',
				'TYPE_DOWN',
				'TYPE_SPACE'
			}
		end

		for k, v in pairs(_types) do
			for _k, _v in pairs(types[v]) do
				if _v == key then
					return v;
				end
			end
		end

		return nil;
	end
end

function isInArray(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end