local function JustASinglePlayer(pn)
	if pn == PLAYER_1 then return GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2) end
	if pn == PLAYER_2 then return GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsPlayerEnabled(PLAYER_1) end
end

local function DiffuseColorForBothPlayers(self)
	if DIVA:BothPlayersEnabled() then
		if GAMESTATE:GetCurrentTrail(PLAYER_1) then
			self:diffuseleftedge( CustomDifficultyToColor( GAMESTATE:GetCurrentTrail(PLAYER_1):GetDifficulty() ) )
		end
		if GAMESTATE:GetCurrentTrail(PLAYER_2) then
			self:diffuserightedge( CustomDifficultyToColor( GAMESTATE:GetCurrentTrail(PLAYER_2):GetDifficulty() ) )
		end
	end
end

local function InvertSongBase()
	WhatToLoad = "Color_WheelSong"
	if DIVA:BothPlayersEnabled() then WhatToLoad = "2PColor_WheelSong" end
	return WhatToLoad
end

local t = Def.ActorFrame {};

	t[#t+1] = Def.ActorFrame{

		Def.ActorFrame{
		
			LoadActor("SelectMusic/WheelHighlight")..{
			InitCommand=function(self)
				self:horizalign(left):zoom(0.5):shadowlength(3)
			end;
			SetMessageCommand=function(self,params)
			local steps = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
			if steps then
				self:diffuse( CustomDifficultyToColor( steps:GetDifficulty() ) )
				DiffuseColorForBothPlayers(self)
			end
			end,
			};
	
			LoadActor("SelectMusic/Base_WheelSong")..{
			OnCommand=function(self)
				self:horizalign(left):zoom(0.5)
			end;
			};
	
			LoadActor("SelectMusic/"..InvertSongBase())..{
			InitCommand=function(self)
				self:horizalign(left):zoom(0.5)
			end;
			OnCommand=function(self)
			if JustASinglePlayer(PLAYER_2) then
				self:zoomx(-0.5):addx(4)
				self:horizalign(right)
			end
			end,
			SetMessageCommand=function(self,params)
			local steps = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
			if steps then
				self:diffuse( CustomDifficultyToColor( steps:GetDifficulty() ) )
				DiffuseColorForBothPlayers(self)
			end
			end,
			PlayerJoinedMessageCommand=function(self)
			self:Load( THEME:GetPathG("","SelectMusic/"..InvertSongBase()) )
			end,
			};
	
			LoadActor("SelectMusic/Star_WheelSong")..{
			InitCommand=function(self)
				self:horizalign(left):zoom(0.6):y(-2):x(-15):shadowlengthy(2)
			end;
			OnCommand=function(self)
			if JustASinglePlayer(PLAYER_2) then
				self:horizalign(right)
			end
			end,
			SetMessageCommand=function(self,params)
			local steps = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
			if steps then
				self:diffuse( CustomDifficultyToColor( steps:GetDifficulty() ) )
				DiffuseColorForBothPlayers(self)
			end
			end,
			};

			LoadFont("renner/20px") ..{
			OnCommand=function(self)
				self:x(110):y(-14):horizalign(left):shadowlength(1):strokecolor(Color.Black):maxwidth(430)
			end;
			SetMessageCommand=function(self,params)
			self:settext("")
			local song = params.Course;
				if song then
					self:settext( song:GetDisplayFullTitle() );
				end;
			end;
			};

		};

	};

for player in ivalues(PlayerNumber) do
t[#t+1] = LoadFont("unsteady oversteer/20px") ..{
	OnCommand=function(self)
		self:x(((player == PLAYER_1 and 80) or 528)):y(0):zoom(1.2):strokecolor(Color.Black)
	end;
	SetMessageCommand=function(self,params)
	local song = params.Course;
	local enabled = GAMESTATE:IsPlayerEnabled(player);
	local steps = GAMESTATE:GetCurrentTrail(player);
	self:settext("")
		if enabled and song and steps then
			self:settext( steps:GetMeter() );
		end
	end;
};

t[#t+1] = LoadFont("unsteady oversteer/20px") ..{
	InitCommand=function(self)
	self:x(490)
	if DIVA:BothPlayersEnabled() then
		self:x( (player == PLAYER_1 and 380) or 490 )
	end
	end,
	OnCommand=function(self)
		self:y(16):zoom(1):strokecolor(Color.Black):horizalign(right)
	end;
	SetMessageCommand=function(self,params)
	local song = params.Course;
	local enabled = GAMESTATE:IsPlayerEnabled(player);
	local steps = GAMESTATE:GetCurrentTrail(player);
	self:settext("")
	if enabled and song and steps then
		if DIVA:BothPlayersEnabled() then
			self:x( (player == PLAYER_1 and 380) or 490 )
		end
	end
	end;
};
end

t.NextSongMessageCommand=function(self)
	self:playcommand("Close")
end;
t.PreviousSongMessageCommand=function(self)
	self:playcommand("Close")
end;
t.StartSelectingStepsMessageCommand=function(self)
	self:queuemessage("FadeWheel")
end;
t.StepsChosenMessageCommand=function(self)
	self:playcommand("Close")
end;
t.PlayerJoinedMessageCommand=function(self)
	self:playcommand("Close")
end;
t.CancelMessageCommand=function(self)
	self:playcommand("Close")
end;
t.CloseCommand=function(self)
	self:queuemessage("ReturnWheel")
end;
t.SetMessageCommand=function(self,params)
local song = params.Course;
local steps = GAMESTATE:GetCurrentTrail( GAMESTATE:GetMasterPlayerNumber() );
self:stoptweening()
self:zoom(1)
self:diffuse(1,1,1,1)
end;
	
return t;