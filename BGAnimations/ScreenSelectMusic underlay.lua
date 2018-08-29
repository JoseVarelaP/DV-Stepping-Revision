local t = Def.ActorFrame{}

t[#t+1] = LoadActor( THEME:GetPathG("","Light_BottomMenuBar") )..{
	OnCommand=cmd(x,SCREEN_RIGHT;horizalign,right;zoom,2;SetTextureFiltering,false;;y,SCREEN_BOTTOM;vertalign,bottom);
};

-- t[#t+1] = Def.Sprite {
-- 	CurrentSongChangedMessageCommand=function(self)
-- 	self:stoptweening()
-- 	self:linear(0.05):diffusealpha(0)
-- 	:queuecommand("UpdateBackground")
-- 	end,
-- 	UpdateBackgroundCommand=function(self)
-- 	if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetBackgroundPath() then
-- 		self:finishtweening()
-- 		self:LoadFromCurrentSongBackground()
-- 		self:scale_or_crop_background()
-- 		self:linear(0.05)
-- 		self:diffusealpha(1)
-- 	end
-- 	end,
-- 	OnCommand=function(self)
-- 		self:scale_or_crop_background()
-- 	end;
-- };

OldSong = GAMESTATE:GetCurrentSong();

t[#t+1] = Def.Sprite {
	CurrentSongChangedMessageCommand=function(self)
 	self:finishtweening()
 	self:sleep(0.1)
 	self:queuecommand("BeginProcess")
 	end,
 	BeginProcessCommand=function(self)
 	self:queuecommand("UpdateBackground")
 	end,
 	UpdateBackgroundCommand=function(self)
		self:finishtweening()
 		if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetBackgroundPath() then
 			self:visible(true)
 			self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath())
			self:scaletocover(0,0,SCREEN_WIDTH,SCREEN_BOTTOM)
 			self:diffusealpha(1)
 		else
 			self:visible(false)
 		end
 	end,
};

t[#t+1] = Def.Sprite {
	CurrentSongChangedMessageCommand=function(self)
 		self:finishtweening()
 		self:croptop(0)
 		self:fadetop(0)
 		self:cropbottom(0)
 		self:fadebottom(0)
 		self:sleep(0.2):smooth(0.4):fadebottom(0.8):cropbottom(1):sleep(0.1)
 	self:queuecommand("BeginProcess")
 	end,
 	BeginProcessCommand=function(self)
 	self:queuecommand("UpdateBackground")
 	end,
 	UpdateBackgroundCommand=function(self)
		self:finishtweening()
 		if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetBackgroundPath() then
			self:finishtweening()
			self:fadetop(0.8)
			self:croptop(1)
 			self:visible(true)
 			self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath())
			self:scaletocover(0,0,SCREEN_WIDTH,SCREEN_BOTTOM)
 			self:smooth(0.3)
			self:fadetop(0)
			self:croptop(0)
 			self:diffusealpha(1)
 		else
 			self:visible(false)
 			self:LoadBackground(THEME:GetPathG("","_blank"))
 		end
 	end,
};

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(x,WideScale(SCREEN_RIGHT,SCREEN_RIGHT);y,SCREEN_CENTER_Y;diffusealpha,0;zoom,0.8;sleep,0.3;decelerate,0.2;zoom,1;diffusealpha,1);
	OffCommand=cmd(playcommand,"GoAway");
	CancelMessageCommand=cmd(playcommand,"GoAway");
	GoAwayCommand=cmd(accelerate,0.2;addx,100;diffusealpha,0);

	Def.Sprite {
		InitCommand=cmd(diffusealpha,1;horizalign,left;x,-250);
		BeginCommand=cmd(LoadFromCurrentSongBackground);
		CurrentSongChangedMessageCommand=function(self)
 			self:finishtweening():smooth(0.1):diffusealpha(0):sleep(0.1):queuecommand("UpdateBackground")
 		end,
		UpdateBackgroundCommand=function(self)
		self:finishtweening()
 		if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetBackgroundPath() then
			self:finishtweening()
 			self:visible(true)
 			self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath())
			self:setsize(400/2,400/2):rotationz(-10):x(-270):decelerate(0.3):x(-250):rotationz(-5):diffusealpha(1)
 		else
 			self:visible(false)
 		end
		end,
		OnCommand=function(self)
			self:shadowlength(10):diffusealpha(0):linear(0.5):diffusealpha(1)
			self:setsize(400/2,400/2)
		end;
	};

	LoadFont("Common Normal")..{
		InitCommand=cmd(diffusealpha,1;horizalign,left;x,WideScale(-280,-400);y,40;strokecolor,Color.Black;rotationz,-2;maxwidth,WideScale(260,550));
		CurrentSongChangedMessageCommand=function(self)
 			self:finishtweening():smooth(0.1):diffusealpha(0):sleep(0.1):queuecommand("UpdateBackground")
 		end,
		UpdateBackgroundCommand=function(self)
		self:finishtweening()
		self:settext("")
 		if GAMESTATE:GetCurrentSong() then
			self:settext( GAMESTATE:GetCurrentSong():GetDisplayMainTitle() )
 		end
 		self:zoom(1.1)
 		self:smooth(0.1)
 		self:diffusealpha(1)
 		self:zoom(1)
		end,
		OnCommand=function(self)
			self:shadowlength(5):diffusealpha(0):linear(0.5):diffusealpha(1)
		end;
	};

	LoadFont("Common Normal")..{
		InitCommand=cmd(diffusealpha,1;horizalign,left;x,WideScale(-280,-400);y,65;strokecolor,Color.Black;rotationz,-2;maxwidth,WideScale(340,550));
		CurrentSongChangedMessageCommand=function(self)
 			self:finishtweening():smooth(0.1):diffusealpha(0):sleep(0.1):queuecommand("UpdateBackground")
 		end,
		UpdateBackgroundCommand=function(self)
		self:finishtweening()
		self:settext("")
		self:y(65)
 		if GAMESTATE:GetCurrentSong() then
			self:settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() )
			if GAMESTATE:GetCurrentSong():GetDisplaySubTitle() == "" then
 				self:y(60)
 			end
 		end
 		self:zoom(0.85)
 		self:smooth(0.1)
 		self:diffusealpha(1)
 		self:zoom(0.8)
		end,
		OnCommand=function(self)
			self:shadowlength(5):diffusealpha(0):linear(0.5):diffusealpha(1)
		end;
	};

	LoadFont("Common Normal")..{
		InitCommand=cmd(diffusealpha,1;horizalign,left;x,WideScale(-280,-400);y,53;strokecolor,Color.Black;rotationz,-2;maxwidth,WideScale(340,550));
		CurrentSongChangedMessageCommand=function(self)
 			self:finishtweening():smooth(0.1):diffusealpha(0):sleep(0.1):queuecommand("UpdateBackground")
 		end,
		UpdateBackgroundCommand=function(self)
		self:finishtweening()
		self:settext("")
 		if GAMESTATE:GetCurrentSong() then
			self:settext( GAMESTATE:GetCurrentSong():GetDisplaySubTitle() )
 		end
 		self:zoom(0.65)
 		self:smooth(0.1)
 		self:diffusealpha(1)
 		self:zoom(0.6)
		end,
		OnCommand=function(self)
			self:shadowlength(5):diffusealpha(0):linear(0.5):diffusealpha(1)
		end;
	};

}

return t;