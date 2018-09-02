local t = Def.ActorFrame{};

t[#t+1] = Def.Quad{ Name="BGQuad"};

t[#t+1] = LoadActor( THEME:GetPathG("","Intro/Jose") )..{ Name="Jose" };
t[#t+1] = Def.ActorFrame{
	Name="Logo";
	LoadActor( THEME:GetPathG("","Intro/White_ThemeLogo") );
	LoadFont("Common Normal")..{
		Text="Version ".. PDSRPInfo["Version"],
		InitCommand=cmd(x,130;horizalign,right;y,45;zoom,0.6;diffuse,Color.Black);
	};
};


local ThemeNamesToLoad = {
	"PD-Stepping-Revision",
	"PD-Stepping-Revision-master",
};

t.OnCommand=function(self)
	-- get everything
	local Jose = self:GetChild("Jose");
	local Logo = self:GetChild("Logo");
	local BGLines = self:GetChild("BGLines");
	local BGQuad = self:GetChild("BGQuad");

	-- Reload the theme!
	--[[
		But why though?
		This is because of the Random Song Play feature.
		If the theme is loaded once, the game won't run the entirety
		of the SongFolder command correctly, and it would spit out 
		a bunch of errors to ThemePrefs. The solution is to reload the
		theme again, while already loaded, so the script loads with the
		now available data.
	]]
	if not AlreadyReloaded then
		AlreadyReloaded = true
		for i=1,#ThemeNamesToLoad do
			if THEME:DoesThemeExist(ThemeNamesToLoad[i]) then
				THEME:SetTheme(ThemeNamesToLoad[i])
			end
		end
	end

	if not DIVA_RandomSong then
		DIVA_RandomSong = SONGMAN:GetRandomSong()
	end

	DIVA:ResetRandomSong()


	-- now let's roll
	Jose:Center():diffusealpha(0):sleep(0.5):decelerate(0.2):diffusealpha(1):sleep(1):accelerate(.2):diffusealpha(0)
	Logo:Center():diffusealpha(0):zoom(1):sleep(2.5):decelerate(0.2):diffusealpha(1):sleep(3):accelerate(.2):diffusealpha(0)
	BGQuad:FullScreen():diffuse(Color.Black):decelerate(0.2):diffuse(Color.White):sleep(6.8):accelerate(0.3):diffuse(Color.Black)

	self:sleep(8):queuecommand("SendToNewScreen")
end
t.SendToNewScreenCommand=function(self)
	SCREENMAN:SetNewScreen("ScreenInit")
end

return t;