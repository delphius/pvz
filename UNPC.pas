unit UNPC;

{
NPC is a Non-Player Character which could be any kind of a plant or a zombie
}

interface

type
  TNPC = class(TInterfacedObject)
  private
    FImgURL: String;
    FHealth: Integer;
    FName: String;
    FattackPower: Integer;
  public
    constructor Create(name: String; health: Integer; imgURL: String); overload;
    constructor Create(name: String; health: Integer; attackPower: Integer; imgURL: String); overload;
    function isAlive: Boolean;
    function getHealth: Integer;
    procedure setHealth(health: Integer);
    function getAttackPower: Integer;
    procedure attack(npc: TNPC); virtual; abstract; //Attacks npc, implemented in subclasses @param npc NPC to be attacked
    function getImgURL: String;
    function getName: String;
  end;

implementation
{
Initializes a new NPC
@param name NPC's name
@param health NPC's health
@param imgURL ImageIcon url of the image for NPS's on the board
}
constructor TNPC.Create(name: String; health: Integer; imgURL: String);
begin
  Self.FName := name;
  Self.FHealth := health;
  Self.FImgURL := imgURL;
end;

{
Initializes a new NPC
@param name NPC's name
@param health NPC's health
@param attackPower NPC's attack power
@param imgURL ImageIcon url of the image for NPS's on the board
}
constructor TNPC.Create(name: String; health, attackPower: Integer; imgURL: String);
begin
  Self.FName := name;
  Self.FHealth := health;
  Self.FattackPower := attackPower;
  Self.FImgURL := imgURL;
end;

{
Returns true if the NPC's health is greater than 0, false otherwise
@return boolean returns true if NPC alive; false - otherwise
}
function TNPC.isAlive: Boolean;
begin
  Result := getHealth > 0;
end;

{
Returns health of the current NPC's
@return int Returns NPC's health points
}
function TNPC.getHealth: Integer;
begin
  Result := FHealth;
end;

{
Sets NPC's health points
@param health NPC's given health
}
procedure TNPC.setHealth(health: Integer);
begin
  Self.FHealth := health;
end;

{
@return int Returns NPC's attack power
}
function TNPC.getAttackPower: Integer;
begin
  Result := FattackPower;
end;

{
Returns url to the image of NPC's
@return ImageIcon url
}
function TNPC.getImgURL: String;
begin
  Result := FImgURL;
end;

{
Return that name of the NPC's
@return String name
}
function TNPC.getName: String;
begin
  Result := FName;
end;
end.