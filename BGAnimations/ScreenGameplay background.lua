--[[
	Welcome to the Dedicated Character Display for Project Diva: Stepping Revision.
	In here you'll see how it works. For a programmer, including myself, you'll find it extremely simple.
	I tried my best to do it that way. So that even new players and newcomers can learn from it.
]]

--[[
	Let's begin by setting the enviroment that this will be placed on.
	We Center it, make a fov so depth can happen, flip the Y axis because Characters
	in StepMania are flipped, and set the Z position depending on Aspect Ratio because
	the z field changes on the current Aspect Ratio, so correct that.
]]
local background = Def.ActorFrame{};

--[[
	Change this to true in case you want to see the timer
	before the next animation on your Log Display. (Only windows)
	If mac, it needs to be on a SystemMessage as the mac cannot display the Log Display.
	Unless you run the game via the terminal.

	Just ensure this is on.
	ShowLogOutput=1
]]
local DebugMode = true

-- In case you want frame-by-frame info on specific stuff.
local MassiveLog = false

-- In case location is disabled, but characters are still shown, display
-- the song's background.
if ThemePrefs.Get("CurrentStageLocation") == "None" then
background[#background+1] = Def.Sprite{
	OnCommand=function(self)
	self:LoadFromCurrentSongBackground(GAMESTATE:GetCurrentSong())
	self:scale_or_crop_background()
	end;
	CurrentSongChangedMessageCommand=function(self)
	self:LoadFromCurrentSongBackground(GAMESTATE:GetCurrentSong())
	self:scale_or_crop_background()
	end,
};
end

local t = Def.ActorFrame{
	InitCommand=function(self)
		self:Center():fov(90):rotationy(180):z( WideScale(300,400) ):addy(10);
	end;
	OnCommand=function(self)
	Camera = self;
	end;
};

-- This is to load the stage's time of day.
-- It goes along the Current Stage Lighting setting found on the
-- Theme Options.
local FuturaToLoad = ( 
		ThemePrefs.Get("CurrentStageLighting") == "Auto" and 
			((Hour() < 6 or Hour() > 19) and "Night" or "Day")
		) or ThemePrefs.Get("CurrentStageLighting")

--Settings & Shortcuts
local BeatsBeforeNextSegment = 8*ThemePrefs.Get("DediMeasureCamera")

-- This will check if the current stage is able to change its lighting cycle.
-- Not all locations can do this, so doing this will save space.
local function Load_Appropiate_Material()
	if DIVA:CheckBooleanOnLocationSetting("AbleToChangeLight") then
		return DIVA:GetPathLocation("",ThemePrefs.Get("CurrentStageLocation").."/"..FuturaToLoad.."_material.txt");
	end
	return DIVA:GetPathLocation("",ThemePrefs.Get("CurrentStageLocation").."/main_material.txt");
end

-- Set the time to wait
local Frm = 1/60

local NumCam = DIVA:CheckStageConfigurationNumber(5,"NumCameras")
local StageHasCamera = FILEMAN:DoesFileExist(DIVA:CallCurrentStage().."/Cameras.lua")
CurrentStageCamera = 0

local function CameraRandom()
	if NumCam and StageHasCamera then
		if DIVA:CheckBooleanOnLocationSetting("IsCameraTweenSequential") then
			if CurrentStageCamera > NumCam then
				CurrentStageCamera = 1
			end
			return CurrentStageCamera
		else
			return ( NumCam > 1 and math.random(1, NumCam ) ) or NumCam
		end
	else
		return math.random(1,5)
	end
end

-- Messages to trace when Debug Mode is on.
local DebugMessages = {
	ModelLoad = function()
		if DebugMode then
			for player in ivalues(PlayerNumber) do
				if GAMESTATE:IsPlayerEnabled(player) then
					print(
					"-------------------------------------------\n"..
					"CharacterDisplay: Character Loaded. ("..player..")"..
					"\nCharacterName: "..GAMESTATE:GetCharacter(player):GetDisplayName()
					.."\nCurrentAnimation: "..GAMESTATE:GetCharacter(player):GetDanceAnimationPath()
					.."\nCharacter Location: "..GAMESTATE:GetCharacter(player):GetCharacterDir()
					.."\n-------------------------------------------"
					)
				end
			end
		end
	end,
	TimeBeforeNextCamera = function()
		if DebugMode and MassiveLog then
			print("CharacterDisplay: Neccesary time before next Camera: ".. NextSegment - now)
		end
	end,
	CameraLoaded = function()
		if DebugMode then
			for player in ivalues(PlayerNumber) do
				if GAMESTATE:IsPlayerEnabled(player) and DIVA:HasAnyCharacters(player) then
					print(
					"\n-------------------------------------------\n"..
					"Next Camera Loaded (".. CameraRandom() .."), returning to command.\n"..
					"\nCurrentAnimation: "..GAMESTATE:GetCharacter(player):GetDanceAnimationPath()..
					"\n-------------------------------------------\n"
					)
				end
			end
		end
	end,
};

-- timing manager
t[#t+1] = Def.Quad{
	Condition=ThemePrefs.Get("DedicatedCharacterShow");
	OnCommand=function(self)
		self:visible(false)
		:queuemessage("InitialTween"):queuecommand("WaitForStart");
	end;
	CurrentSongChangedMessageCommand=function(self)
		self:stoptweening():queuecommand("WaitForStart"):queuemessage("InitialTween")
	end;
	WaitForStartCommand=function(self)
	-- set globals, we need these later.
	song = GAMESTATE:GetCurrentSong();
	start = song:GetFirstBeat();
	now = GAMESTATE:GetSongBeat();

	-- Clear this one out in case the player restarts the screen.
	-- And to also properly reset the counter if it does.
	NextSegment = nil

	self:sleep(Frm)
	if now<start then
		self:queuecommand("WaitForStart")
	else
		self:queuemessage("Camera1")
		self:sleep(Frm)
		self:queuecommand("TrackTime")
	end
	end,
	TrackTimeCommand=function(self)
	if not NextSegment then
		NextSegment = now + BeatsBeforeNextSegment
	end

	song = GAMESTATE:GetCurrentSong();
	start = song:GetFirstBeat();
	now = GAMESTATE:GetSongBeat();

	self:sleep(Frm)
	if (DIVA:HasAnyCharacters(PLAYER_1) or DIVA:HasAnyCharacters(PLAYER_2)) then
		if now < NextSegment then
			DebugMessages.TimeBeforeNextCamera()
			self:queuecommand("TrackTime")
		else
			self:queuemessage("Camera"..CameraRandom())
			CurrentStageCamera = CurrentStageCamera + 1
			NextSegment = now + BeatsBeforeNextSegment
			DebugMessages.CameraLoaded()
			self:queuecommand("TrackTime")
		end
	end
	end,
}


-- Stage Enviroment
t[#t+1] = Def.ActorFrame{
	Condition=ThemePrefs.Get("DedicatedCharacterShow") and (DIVA:HasAnyCharacters(PLAYER_1) or DIVA:HasAnyCharacters(PLAYER_2));

		--Load the Stage
		Def.Model {
			Condition=ThemePrefs.Get("CurrentStageLocation") ~= "None" and DIVA:LocationIsSafeToLoad();
			Meshes=DIVA:GetPathLocation("",ThemePrefs.Get("CurrentStageLocation").."/model.txt");
			Materials=Load_Appropiate_Material();
			Bones=DIVA:GetPathLocation("",ThemePrefs.Get("CurrentStageLocation").."/model.txt");
			OnCommand=function(self)
				self:cullmode("CullMode_None")
				self:zoom( DIVA:CheckStageConfigurationNumber(1,"StageZoom") )
				self:addy( DIVA:CheckStageConfigurationNumber(0,"StageYOffset") )
				self:addx( DIVA:CheckStageConfigurationNumber(0,"StageXOffset") )
			end,
		};

};

local function UpdateModelRate()
	-- The real kicker, recreating SM's true tempo updater.
	-- StepMania always kept a rate of 0.75 to 1.5, I wanted to break it a little bit more.
	
	-- In case the song is on a rate, then we can multiply it.
	-- It also checks for the song's Haste, if you're using that.
	-- Safe check in case Obtaining HasteRate fails
	local MusicRate = 1
	if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetHasteRate() then
		MusicRate = SCREENMAN:GetTopScreen():GetHasteRate()
	end
	local BPM = (GAMESTATE:GetSongBPS()*60)
	
	-- We're using scale to compare higher values with lower values.
	local UpdateScale = scale( BPM, 60, 300, 0.75, 1.5 );

	-- Then clamp it so it's on a max and a low ammount
	local Clamped = clamp( UpdateScale, 0.5, 2.5 );

	-- Then take what we have and update depending on the music rate.
	local ToConvert = Clamped*MusicRate
	local SPos = GAMESTATE:GetSongPosition()

	if not SPos:GetFreeze() or not SPos:GetDelay() then
		return ToConvert
	else
		return 0
	end
end

local function HasBabyCharacter(pn)
	return GAMESTATE:IsPlayerEnabled(pn) and string.find(GAMESTATE:GetCharacter(pn):GetDisplayName(), "Baby") and DIVA:IsSafeToLoad(pn)
end

if ThemePrefs.Get("DedicatedCharacterShow") and (DIVA:HasAnyCharacters(PLAYER_1) or DIVA:HasAnyCharacters(PLAYER_2)) then
	for player in ivalues(PlayerNumber) do
		if GAMESTATE:IsPlayerEnabled(player) and DIVA:IsSafeToLoad(player) then

		local function BabySizeCheck(pn)
			if DIVA:HasAnyCharacters(pn) and string.find(GAMESTATE:GetCharacter(pn):GetDisplayName(), "Baby") then
				self:zoom(0.7)
			end

			return self
		end
		-- This will be the warmup model.
		t[#t+1] = Def.Model {
				Condition=GAMESTATE:GetCharacter(player):GetDisplayName() ~= "default",
				Meshes=GAMESTATE:GetCharacter(player):GetModelPath(),
				Materials=GAMESTATE:GetCharacter(player):GetModelPath(),
				Bones=GAMESTATE:GetCharacter(player):GetWarmUpAnimationPath(),
				OnCommand=function(self)
				self:cullmode("CullMode_None")
				if DIVA:BothPlayersEnabled() then self:x( (player == PLAYER_1 and 8) or -8 ) end
				if HasBabyCharacter(player) then self:zoom(0.7) end
				self:queuecommand("UpdateRate")
				end,
				UpdateRateCommand=function(self)
				-- Check function to see how it works.
				self:rate( UpdateModelRate() )
				self:sleep(Frm)
				if now<start then
					self:visible(true)
				else
					self:visible(false)
				end
				self:queuecommand("UpdateRate")
				end,
		};
		-- Load the Character
		t[#t+1] = Def.Model {
				Condition=GAMESTATE:GetCharacter(player):GetDisplayName() ~= "default",
				Meshes=GAMESTATE:GetCharacter(player):GetModelPath(),
				Materials=GAMESTATE:GetCharacter(player):GetModelPath(),
				Bones=GAMESTATE:GetCharacter(player):GetDanceAnimationPath(),
				OnCommand=function(self)
					self:cullmode("CullMode_None")
					DebugMessages.ModelLoad()
				-- position time
				-- reminder that x position is inverted because we inverted the Y axis
				-- to make the character face towards the screen.
				if DIVA:BothPlayersEnabled() then self:x( (player == PLAYER_1 and 8) or -8 ) end
				if HasBabyCharacter(player) then self:zoom(0.7) end
				self:queuecommand("UpdateRate")
				end,
				-- Update Model animation speed depending on song's BPM.
				-- To match SM's way of animation speeds
				UpdateRateCommand=function(self)
				-- Check function to see how it works.
				self:rate( UpdateModelRate() )
				print( UpdateModelRate() )
				self:sleep(Frm)
				if now<start then
					self:visible(false)
				else
					self:visible(true)
				end
				self:queuecommand("UpdateRate")
				end,
		};
		end
	end
end

-- Some song info before we start
t[#t+1] = Def.ActorFrame{
	Condition=ThemePrefs.Get("DedicatedCharacterShow") and ThemePrefs.Get("DediSongData");

	InitCommand=function(self)
		self:xyz(0,-10,-5):rotationy(180):diffusealpha(0):sleep(0.3):decelerate(0.2):diffusealpha(1);
	end;

		LoadActor( THEME:GetPathG("","BGElements/CircleInner") )..{
			OnCommand=function(self)
				self:diffusealpha(0.3):spin():effectmagnitude(0,0,24):zoom(0.08):z(-10);
			end;
		};
	
		Def.Quad{
		OnCommand=function(self)
			self:zoomto(40,6):y(1):diffuse(0,0.5,0.5,1):fadeleft(1):faderight(1);
		end;
		};

		Def.Sprite {
			BeginCommand=function(self) self:LoadFromCurrentSongBackground() end;
			OnCommand=function(self)
				self:scaletoclipped(648/30,480/30)
				:croptop(0.37):cropbottom(0.25)
				:fadeleft(0.2):faderight(0.2)
				:diffuse(0.7,0.7,0.7,1)
			end;
		};
	
		LoadFont("Common Normal")..{
		Text=GAMESTATE:GetCurrentSong():GetDisplayArtist();
		InitCommand=function(self)
			self:zoom(0.07):shadowlengthy(0.2);
		end;
		};
	
		LoadFont("Common Normal")..{
		Text=GAMESTATE:GetCurrentSong():GetDisplayFullTitle();
		InitCommand=function(self)
			self:shadowlengthy(0.2):y(2):zoom(0.05)
		end;
		};

	OnCommand=function(self) self:queuecommand("UpdateToSleep") end;
	UpdateToSleepCommand=function(self)
	if now<(start-4) then
		self:queuecommand("UpdateToSleep")
		self:sleep(Frm)
	else
		self:sleep(Frm)
		self:queuecommand("FadeAway")
	end
	end,
	FadeAwayCommand=function(self) self:accelerate(0.2):diffusealpha(0) end;
};

-- The cameras
if StageHasCamera then
	t[#t+1] = LoadActor( "../../../"..DIVA:CallCurrentStage().."/Cameras.lua" )
	print( "CAMERA: Loaded custom Camera!" )
else
	t[#t+1] = LoadActor( "../Locations/Default_Camera.lua" )
	print( "CAMERA: Loaded Default Camera!" )
end

background[#background+1] = t;

return background;