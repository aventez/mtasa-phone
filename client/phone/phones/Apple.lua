phone.Apple = {};
phone.Apple.__index = phone.Phone();

setmetatable(phone.Apple, {
	__call = function (obj, ...)
		return obj.__constructor(...);
	end,
});

function phone.Apple.__constructor (...)
	local this = phone.Phone(..., 'Apple');

	local super = {};
	for k, v in pairs(this) do
		if type(v) == 'function' then
			super[k] = v;
		end
    end

    this.setAttribute('wallpaper', './files/wallpaper.png');
    this.setAttribute('texture', './files/Apple.png');

    this.setIntro(phone.Intro);
    this.setLauncher(phone.AppleLauncher);
    --this.setApplication(phone.Application);

    this.createScreenRenderTarget();

    --outputChatBox(appsMaxId);

    -- control section
        this.controlLeft = function ()
            if this.getState() == false then
                this.changeSelected(-1);
            end
        end    

        this.controlRight = function ()
            if this.getState() == false then
                this.changeSelected(1);
            end
        end

        this.controlBack = function ()
            if this.getState() == false then
                this.setApplication(nil);
            end
        end

        this.controlEnter = function ()
            if this.getState() == false then
                outputChatBox(this.getLauncher().getSelected());

                this.runApplication(this.getLauncher().getSelected());
            end
        end

        this.changeSelected = function (value)
            local new = this.getLauncher().getSelected() + value;

            if this.getLauncher().getSelected() == 1 and value < 0 then
                this.getLauncher().setSelected(#this.getApps());
                return;
            elseif new > #this.getApps() then
                this.getLauncher().setSelected(1);
                return;
            end

            this.getLauncher().setSelected(new);
        end
    -- control section end

    this.onDraw = function ()
        super.onDraw();

        local box = this.getBoundingBox();
        dxDrawImage(box.x, box.y, box.width, box.height, this.getAttribute('texture'));

        local screenBox = this.getScreenBoundingBox();
        dxDrawImage(screenBox.x, screenBox.y, screenBox.width, screenBox.height, this.getScreenRenderTarget());
    end
    
    return this;
end