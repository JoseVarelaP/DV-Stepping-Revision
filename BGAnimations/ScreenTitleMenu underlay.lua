local t = Def.ActorFrame{
	OnCommand=function(self)
	DIVA_LogoAlreadyShown = false
	if ThemePrefs.Get("EnableRandomSongPlay") then
		GAMESTATE:SetPreferredSong(DIVA_RandomSong)
		MESSAGEMAN:Broadcast("ShowBackground")
	end
	end,
}

if #SONGMAN:GetAllSongs() > 0 and ThemePrefs.Get("EnableRandomSongPlay") then

	local FadeIn = function(self)
		self:sleep(.3):decelerate(0.2):diffuse(0,0,0,1)
	end;
	local GlobalItems = function(self)
		self:horizalign(left):diffuse(0,0,0,1):zoom(0.6):shadowlengthy(1)
	end;

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
		self:diffusealpha(0)
		end,
		OnCommand=function(self)
		self:zoom(0.8):x(SCREEN_LEFT+70):y(SCREEN_BOTTOM-35):sleep(.3):decelerate(0.2):diffusealpha(1)
		end,
		OffCommand=function(self)
		self:accelerate(0.2):diffusealpha(0)
		end,

		LoadActor( THEME:GetPathG("","TitleMenu/MusicNote"))..{
		OnCommand=function(self)
		self:zoom(0.15):x(-15):y(-3)
		end,
		};

		LoadFont("Common Normal")..{
		Text=DIVA_RandomSong:GetDisplayFullTitle() .." - ".. DIVA_RandomSong:GetDisplayArtist();
		InitCommand=function(self)
		self:horizalign(left):diffuse(0,0,0,1):zoom(0.6):shadowlengthy(1)
		end;
		OnCommand=function(self)
		self:strokecolor( Color.White )
		local ToMove = -2
		self:y(ToMove)
		end,
		};
	};
end

return t;