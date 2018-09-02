local t = Def.ActorFrame{};

t[#t+1] = Def.Quad{
	OnCommand=cmd(x,SCREEN_LEFT+86;y,SCREEN_BOTTOM-14;horizalign,left;zoomto,SCREEN_WIDTH-118,16;diffuse,Color.Black;fadetop,1);	
};

t[#t+1] = Def.Quad{
	Name="ClearBG";
	InitCommand=cmd(x,SCREEN_LEFT+86;y,SCREEN_BOTTOM-14;horizalign,left;zoomto,SCREEN_WIDTH-118,16;diffusetopedge,color("#006327");diffusebottomedge,color("#2AD58C"));
	OnCommand=cmd(cropleft,0.6);
};

t[#t+1] = Def.Quad{
	InitCommand=cmd(zwrite,true;blend,"BlendMode_NoEffect");
	OnCommand=cmd(x,SCREEN_LEFT+86;y,SCREEN_BOTTOM-14;horizalign,left;zoomto,SCREEN_WIDTH-118,16;queuecommand,"LoopCheck");
	LoopCheckCommand=function(self)
	local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
    local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()

    self:cropleft( ScoreToCalculate )
    self:sleep(1/60)
    self:queuecommand("LoopCheck")
	end,
};



for player in ivalues(PlayerNumber) do
	t[#t+1] = Def.Quad{
		InitCommand=cmd(x,SCREEN_LEFT+86;y,SCREEN_BOTTOM-14;horizalign,left;zoomto,SCREEN_WIDTH-118,16;diffusetopedge,color("#ABFFFE");diffusebottomedge,color("#2DE5D1"));
		OnCommand=function(self)
		self:ztest(true)
		self:queuecommand("LoopCheck")
		end,
		LoopCheckCommand=function(self)
		local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
    	local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()
	
    	if ScoreToCalculate > 0.6 then
    		self:glowshift()
    	end
	
    	self:sleep(1/60)
    	self:queuecommand("LoopCheck")
		end,
	};

	t[#t+1] = Def.Quad{
		OnCommand=cmd(x,SCREEN_LEFT+86;y,SCREEN_BOTTOM-14;horizalign,left;zoomto,2,16;diffuse,(player == PLAYER_1 and Color.Red) or Color.Orange;queuecommand,"LoopCheck");
		LoopCheckCommand=function(self)
		local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
	    local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()	

	    self:x( (SCREEN_LEFT+86)+(ScoreToCalculate*(SCREEN_WIDTH-118)) )
	    self:sleep(1/60)
	    self:queuecommand("LoopCheck")
		end,
	};
end


t[#t+1] = LoadFont("Common Normal")..{
	Name="ClearText";
	Text="STAGE CLEAR";
	InitCommand=cmd(y,SCREEN_BOTTOM-10;zoom,0.5;vertalign,bottom;diffusebottomedge,Color.Yellow;diffusetopedge,color("1,1,1,1");strokecolor,Color.Black);
};

t[#t+1] = LoadActor( THEME:GetPathG("","Gameplay/PBar middle") )..{
	OnCommand=cmd(CenterX;zoom,1.4;zoomtowidth,SCREEN_WIDTH-50;vertalign,bottom;y,SCREEN_BOTTOM-5);
};

t[#t+1] = LoadActor( THEME:GetPathG("","Gameplay/PBar left") )..{
	OnCommand=cmd(x,SCREEN_LEFT+4;horizalign,left;vertalign,bottom;y,SCREEN_BOTTOM-5;zoom,1.4);
};

t[#t+1] = LoadActor( THEME:GetPathG("","Gameplay/PBar right") )..{
	OnCommand=cmd(x,SCREEN_RIGHT-4;horizalign,right;vertalign,bottom;y,SCREEN_BOTTOM-5;zoom,1.4);
};

t[#t+1] = LoadFont("laxero/20px")..{
	OnCommand=cmd(x,SCREEN_LEFT+40;y,SCREEN_BOTTOM-20;diffusebottomedge,Color.Yellow;diffusetopedge,color("1,1,1,1");shadowlength,2;horizalign,left;zoom,0.8;strokecolor,Color.Black;queuecommand,"LoopCheck");
	LoopCheckCommand=function(self)
	local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
    local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()

    self:settext( FormatPercentScore( ScoreToCalculate ) )
    self:sleep(1/60)
    self:queuecommand("LoopCheck")
	end,
};

t.OnCommand=function(self)
local ClearBG = self:GetChild("ClearBG");
local ClearText = self:GetChild("ClearText");

ClearText:x( ClearBG:GetZoomedWidth()/WideScale(1.03,1.1) )
end

return t;