local t = Def.ActorFrame{}

-- t[#t+1] = LoadSongBackground()..{
-- 	OnCommand=cmd(diffusealpha,0.1);
-- }

t[#t+1] = LoadActor( THEME:GetPathG("","BGElements/CircleInner") )..{
	OnCommand=function(self)
		self:x(SCREEN_RIGHT):diffusealpha(0.3):spin():effectmagnitude(0,0,24):zoom(1.2)
	end;
};

t[#t+1] = LoadActor( THEME:GetPathG("","BGElements/CircleOuter") )..{
	OnCommand=function(self)
		self:x(SCREEN_RIGHT):zoom(1.2):queuecommand("Loop")
	end;
	LoopCommand=function(self)
	self:diffusealpha(0.2):linear(5)
	:diffusealpha(0.8):decelerate(1)
	:diffusealpha(0.2):sleep(6)
	:queuecommand("Loop")
	end,
};

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:zoom(1.2):queuecommand("Loop")
	end;
	LoopCommand=function(self)
	self:diffusealpha(0):zoom(0)
	:x( math.random(0,SCREEN_RIGHT) ):y( math.random(0,SCREEN_BOTTOM) )
	:zoomto(0,10):diffuse(0,0.6,0.8,0.5):zoomto(200,10):cropright(1):linear(1):cropright(0)
	:linear(1):zoomto( 450, 60 ):diffusealpha(0):sleep( math.random(1,3) )
	:queuecommand("Loop")
	end,
}

t[#t+1] = LoadActor( THEME:GetPathG("","BGElements/CircleOuter") )..{
	OnCommand=function(self)
		self:x(SCREEN_RIGHT):zoom(1.2):queuecommand("Loop")
	end;
	LoopCommand=function(self)
	self:diffusealpha(0):zoom(1.2):sleep(5)
	:diffusealpha(1):linear(6)
	:zoom(5):diffusealpha(0.1):sleep(1)
	:queuecommand("Loop")
	end,
};

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:zoomto(SCREEN_WIDTH,100):Center():diffuse(0,0,0,1):fadetop(0.1):fadebottom(0.1)
	end;
};

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		self:CenterY():x(SCREEN_LEFT+20)
	end;
	
	LoadFont("Common Normal")..{
	Text=GAMESTATE:GetCurrentSong():GetDisplayArtist();
	InitCommand=function(self)
		self:horizalign(left):zoom(1):shadowlengthy(2):y(-10)
	end;
	};

	LoadFont("Common Normal")..{
	Text=GAMESTATE:GetCurrentSong():GetDisplayFullTitle();
	InitCommand=function(self)
		self:horizalign(left):shadowlengthy(2):y(10):zoom(0.8)
	end;
	};
}

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		self:CenterY():x(SCREEN_RIGHT-20)
	end;
	
	LoadFont("Common Normal")..{
	Text=SecondsToMMSS(GAMESTATE:GetCurrentSong():MusicLengthSeconds());
	InitCommand=function(self)
		self:horizalign(right,zoom,1):shadowlengthy(2)
	end;
	};

}

return t;