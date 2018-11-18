-- Diva Rooom - CharacterSelection
-- Load the characters, put them in a table so we can select.
local CharTable = CHARMAN:GetAllCharacters();
if not getenv("CharSelIndex") then
    setenv("CharSelIndex",1)
end

local RoomSpots = DIVA.LoadSaveDir().."RoomLocations.ini"

-- Allowed input on screen
local BTInput = {
    ["MenuUp"] = function()
        setenv("CharSelIndex",getenv("CharSelIndex") - 1)
    end,
    ["MenuDown"] = function()
        setenv("CharSelIndex",getenv("CharSelIndex") + 1)
    end,
    ["Back"] = function()
        SCREENMAN:GetTopScreen():SetPrevScreenName("DivaRoom/MainMenu"):Cancel()
    end,
    ["Start"] = function()
        -- Set Location and Character based on selection
        setenv( "DivaRoom_CharLoad", CharTable[getenv("CharSelIndex")] )
        setenv( "DivaRoom_LocaLoad", Config.Load( CharTable[ getenv("CharSelIndex") ]:GetDisplayName(), RoomSpots ) )

        -- After this is done, continue by going to the main Diva Room screen.
        setenv("DivaRoomNextScreen", "DivaRoom")
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end,
};

-- Begin by setting up a ActorFrame which will handle everything.
-- And also the subsequent ones that will be filled up later.
local AllObjects = Def.ActorFrame{};
local UI = Def.ActorFrame{};

local function CheckValueOffsets()
    if getenv("CharSelIndex") > #CharTable then setenv("CharSelIndex",1) end
    if getenv("CharSelIndex") < 1 then setenv("CharSelIndex",#CharTable) end
end;

-- Input handler, manages all the Input data that will be recieved by the player.
local function InputHandler(event)
    -- Safe check to input nothing if any value happens to be not a player.
    -- ( AI, or engine input )
    if not event.PlayerNumber then return end

    -- Input that occurs at the moment the button is pressed.
    if ToEnumShortString(event.type) == "FirstPress" then
        if BTInput[event.GameButton] then BTInput[event.GameButton]() end
    end

    -- Input that loops if the same button that was pressed is still held.
    -- Usually I have to loop the same commands from FirstPress to do this
    -- and honestly it's messy.
    if ToEnumShortString(event.type) == "Repeat" then
        if BTInput[event.GameButton] then BTInput[event.GameButton]() end
    end
    CheckValueOffsets()
    MESSAGEMAN:Broadcast("CharUpAllVal")
    CHList:GetChild("CharacterScroller"):SetDestinationItem(getenv("CharSelIndex")-1);
end

local Controller = Def.ActorFrame{
	OnCommand=function(self) MESSAGEMAN:Broadcast("CharUpAllVal")
	SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) end;
};

-- Add Controller to the input
AllObjects[#AllObjects+1] = Controller;

CHList = Def.ActorFrame{
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X,SCREEN_CENTER_Y )
        CHList = self;
    end;
};

local ItSp = 70;

local function LoadCharacterList()
    local t = Def.ActorFrame{};
    for index,cval in ipairs(CharTable) do
        if cval:GetDisplayName() ~= "" then
            local Result =  Def.ActorFrame{

                LoadActor( THEME:GetPathG("","DivaRoom/DateInfo") )..{
                    OnCommand=function(self)
                        self:zoom(0.35)
                    end;
                };
                
                LoadActor( THEME:GetPathG("","DivaRoom/Mask_DateInfo") )..{
                    OnCommand=function(self)
                        self:MaskSource():x(-1):zoom(0.35):cropright(0.6)
                        :clearzbuffer(true)
                    end;
                };

                Def.Sprite{
                    Texture=cval:GetCardPath();
                    OnCommand=function(self)
                        self:zoom(0.75):setsize(90,140):xy(-155,4):MaskDest():cropbottom(0.4):croptop(0.2)
                    end;
                };
                
                LoadActor( THEME:GetPathG("","MenuScrollers/SettingHighlight") )..{
                    OnCommand=function(self)
                        self:zoom(0.35)
                    end;
                    CharUpAllValMessageCommand=function(self)
                        self:stopeffect():diffusealpha(0)
                        if index == getenv("CharSelIndex") then
                            self:diffuseshift():diffusealpha(1)
                            :effectcolor1(1,1,1,0):effectcolor2(Color.White)
                        end
                    end;
                };

                Def.BitmapText{ Font="renner/20px",
                    OnCommand=function(self)
                        self:strokecolor( Color.Black )
                        :halign(0):xy(-120,-10):zoom(0.7)
                        :settext( cval:GetDisplayName() )
                    end;
                };

                Def.BitmapText{ Font="renner/20px",
                Condition=(getenv("DivaRoom_CharLoad") == cval);
                    OnCommand=function(self)
                        self:strokecolor( Color.Black )
                        :halign(1):xy(180,5):zoom(0.5)
                        :settext( "Currently Selected" )
                    end;
                };

                Def.BitmapText{ Font="Common Normal",
                    OnCommand=function(self)
                        self:strokecolor( Color.Black )
                        :halign(0):xy(-130,7):zoom(0.6)
                        -- Get current loction for the character    
                        :settext( "Current Location: "..Config.Load( cval:GetDisplayName(), RoomSpots ) )
                    end;
                };
            };
            t[#t+1] = Result
        end
    end
    return t;
end;

CHList[#CHList+1] = Def.Quad{
    OnCommand=function(self)
        self:zoomto(SCREEN_WIDTH,500):fadetop(0.2):fadebottom(0.2):diffuse(Color.Black):diffusealpha(0.7)
    end;
};

CHList[#CHList+1] = Def.ActorScroller{
    Name = 'CharacterScroller';
    NumItemsToDraw=7;
    OnCommand=function(self)
    self:y(7):SetFastCatchup(true):SetSecondsPerItem(0.1):SetWrap(false)
    :SetDestinationItem( getenv("CharSelIndex")-1 )
    self:addx(-SCREEN_WIDTH):decelerate(0.3):addx(SCREEN_WIDTH)
    end;
    TransformFunction=function(self, offset, itemIndex, numItems)
        self:visible(true);
        self:y(math.floor( offset*60 ))
        self:decelerate(0.2)
        self:zoom(
            (offset == 0 and 1.1) or 
            (offset < -1 or offset > 1) and 0.8 or 1
        )
        :diffusealpha(
            (offset == 0 and 1) or 
            (offset < -1 or offset > 1) and 0.1 or 0.7
        )
    end;
    children = LoadCharacterList();
};

-- Load the usual border
UI[#UI+1] = LoadActor("../Borders.lua");

AllObjects[#AllObjects+1] = CHList;
AllObjects[#AllObjects+1] = UI;

return AllObjects;