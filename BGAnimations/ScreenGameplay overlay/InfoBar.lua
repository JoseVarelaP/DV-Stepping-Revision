local t = Def.ActorFrame{};

t[#t+1] = LoadActor( THEME:GetPathG("","Gameplay/TopInfo") )..{
	InitCommand=function(self)
		self:x(SCREEN_LEFT):horizalign(left):zoom(1):vertalign(top)
	end;
};

t[#t+1] = LoadFont("Common Normal")..{
	OnCommand=function(self)
		self:x(SCREEN_LEFT+90):y(4):horizalign(left):zoom(0.6):SetTextureFiltering(false):vertalign(top)
	end;
	CurrentSongChangedMessageCommand=function(self)
	local InfoToShow = (
		(not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong():GetDisplayFullTitle())
		or GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().." - "..GAMESTATE:GetCurrentSong():GetDisplayFullTitle()
		)
	
	self:settext( InfoToShow )
	end,
};

return t;