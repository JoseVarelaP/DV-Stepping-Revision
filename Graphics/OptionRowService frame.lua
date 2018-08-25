local t = Def.ActorFrame {};

local DebugMode = false;

local ItemsToTweenColor = {
	-- Name, Color 1, Color 2

	-- Choices that show up when enabling stuff, but send to new menus, will appear green.
	{"Dedicated Character Settings", color("1,1,0,1"), color("0.8,0.8,0,0.5")},

	-- Choices that show up when enabling stuff, will appear purple.
	{"ModelsInRoom", color("0.8,0,0.8,1"), color("0.7,0,0.7,0.5")},
	{"FolderToPlayRandomMusic", color("0.8,0,0.8,1"), color("0.7,0,0.7,0.5")},
	{"CurrentStageLighting", color("0.8,0,0.8,1"), color("0.7,0,0.7,0.5")},

	{"DediModelBPM", color("0.8,0,0.8,1"), color("0.7,0,0.7,0.5")},
	{"DediSongData", color("0.8,0,0.8,1"), color("0.7,0,0.7,0.5")},
	{"DediMeasureCamera", color("0.8,0,0.8,1"), color("0.7,0,0.7,0.5")},

	-- Other menu options
	{"Theme Options", Color.HoloDarkPurple, Color.HoloPurple},
};

local UnlockableOptions = {
	"Dedicated Character Settings",
	"ModelsInRoom",
	"FolderToPlayRandomMusic",
	"CurrentStageLighting",
}

local gc = Var("GameCommand");

t[#t+1] = LoadActor("MenuScrollers/Base")..{
	OnCommand=cmd(horizalign,left;zoom,2);
};

t[#t+1] = LoadActor("MenuScrollers/Dim")..{
	OnCommand=cmd(horizalign,left;zoom,2;faderight,0.1);
	GainFocusCommand=cmd(stoptweening;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
};

t[#t+1] = LoadActor("MenuScrollers/Bright")..{
	OnCommand=cmd(horizalign,left;zoom,2);
	GainFocusCommand=function(self)
	local optrow = self:GetParent():GetParent():GetParent()
	self:stoptweening():diffuseshift():diffusealpha(1):effectcolor1(1,1,1,1):effectcolor2(0.8,0.8,0.8,0.5)
	for i=1,#ItemsToTweenColor do
		if optrow:GetName() == ItemsToTweenColor[i][1] then
			self:Load(THEME:GetPathG("","MenuScrollers/DiffuseBright"))
			self:stoptweening():diffuseshift():diffusealpha(1):effectcolor1(ItemsToTweenColor[i][2]):effectcolor2(ItemsToTweenColor[i][3])
		end
	end
	end,
	LoseFocusCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
};

t[#t+1] = LoadFont("Common Normal")..{
	OnCommand=function(self)
	(cmd(horizalign,left;x,42;addx,-300;decelerate,0.2;addx,300;strokecolor,Color.Black))(self);
	local optrow = self:GetParent():GetParent():GetParent()

	self:settext(THEME:GetString("OptionTitles",optrow:GetName()) ):horizalign(left)

	for i=1,#UnlockableOptions do
		if optrow:GetName() == UnlockableOptions[i] then
			self:addx(15):zoom(0.9)
		end
	end

	end,
	GainFocusCommand=cmd(diffuse,1,1,1,1);
	LoseFocusCommand=cmd(stoptweening;linear,0.1;diffuse,0.5,0.5,0.5,1);
};

if DebugMode then
	t[#t+1] = LoadFont("Common Normal")..{
	OnCommand=function(self)
	local optrow = self:GetParent():GetParent():GetParent()
	self:settext(optrow:GetName() .." - ".. THEME:GetString("OptionTitles",optrow:GetName()) ):horizalign(left)
	:zoom(0.6):x(42):y(16)
	end,
};
end

return t;