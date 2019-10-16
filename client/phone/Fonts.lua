Fonts = {};

Fonts.fontBig = exports.rp_fontmanager:getFont('SFProText-Regular', 10);
Fonts.Helvetica = exports.rp_fontmanager:getFont('Helvetica', 9);
Fonts.SmallHelvetica = exports.rp_fontmanager:getFont('Helvetica', 6);


Fonts.miniFont = exports.rp_fontmanager:getFont('ProximaNova-Regular', 6);
Fonts.smallFont = exports.rp_fontmanager:getFont('ProximaNova-Regular', 8);
Fonts.font = exports.rp_fontmanager:getFont('ProximaNova-Regular', 10);
Fonts.bigFont = exports.rp_fontmanager:getFont('ProximaNova-Regular', 12);
Fonts.vbigFont = exports.rp_fontmanager:getFont('ProximaNova-Regular', 16);
Fonts.mbigFont = exports.rp_fontmanager:getFont('ProximaNova-Regular', 36);

Fonts.getFont = function (name, size)
	return exports.rp_fontmanager:getFont(name, size);
end