local t = Def.ActorFrame{}

-- t[#t+1] = Def.Quad{
-- 	OnCommand=cmd(FullScreen;diffuse,0,0,0,0;decelerate,);
-- }

t[#t+1] = Def.ActorFrame{
	BeginCommand=cmd(Center;zoom,1;diffusealpha,0;decelerate,0.2;diffusealpha,1);
	OffCommand=cmd(addy,-10;decelerate,0.2;addy,10;sleep,0.5;accelerate,0.2;zoom,0);
	CancelMessageCommand=cmd(accelerate,0.1;diffusealpha,0);

	LoadActor( THEME:GetPathG("","WideInterpreter"), { File="Global/TextBox", Width=430, Height=300 } )..{
	};

	Def.ActorProxy{
	BeginCommand=function(self)
	self:SetTarget( SCREENMAN:GetTopScreen():GetChild("Container") )
	self:zoom(0.7):y(-170)
	end,
	};

}

return t;