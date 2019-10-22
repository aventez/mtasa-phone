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
	}
};

function Controls.getControlType(key)
	if key ~= nil then
		if key:len() > 1 then	
			for k, v in pairs(types) do
				for _k, _v in pairs(types[k]) do
					if _v == key then
						return k;
					end
				end
			end
		end
		
		return nil;
	end
end

function Controls.isNumeric(value)
    if tonumber(value) ~= nil then
        return true;
    else
        return false;
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