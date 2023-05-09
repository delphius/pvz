{NPC is a Non-Player Character which could be any kind of a plant or a zombie}
unit UNPC;

interface

type
  TNPC = class(TInterfacedObject)
  private
    FHealth: Integer;
    FName: String;
    FAttackPower: Integer;
  public
{
Initializes a new NPC
@param name NPC's name
@param health NPC's health
}
    constructor Create(name: String; health: Integer); overload;
{
Initializes a new NPC
@param name NPC's name
@param health NPC's health
@param attackPower NPC's attack power
}
    constructor Create(name: String; health: Integer; attackPower: Integer); overload;
{
Returns true if the NPC's health is greater than 0, false otherwise
@return boolean returns true if NPC alive; false - otherwise
}
    function isAlive: Boolean;
{
Returns health of the current NPC's
@return int Returns NPC's health points
}
    function getHealth: Integer;
{
Sets NPC's health points
@param health NPC's given health
}
    procedure setHealth(health: Integer);
{
@return int Returns NPC's attack power
}
    function getAttackPower: Integer;
{
Attacks npc, implemented in subclasses
@param npc NPC to be attacked
}
    procedure attack(npc: TNPC); virtual; abstract;

{
Return that name of the NPC's
@return String name
}
    function getName: String;
  end;

implementation

constructor TNPC.Create(name: String; health: Integer);
begin
  FName := name;
  FHealth := health;
end;

constructor TNPC.Create(name: String; health, attackPower: Integer);
begin
  FName := name;
  FHealth := health;
  FAttackPower := attackPower;
end;

function TNPC.isAlive: Boolean;
begin
  Result := getHealth > 0;
end;

function TNPC.getHealth: Integer;
begin
  Result := FHealth;
end;

procedure TNPC.setHealth(health: Integer);
begin
  Self.FHealth := health;
end;

function TNPC.getAttackPower: Integer;
begin
  Result := FAttackPower;
end;

function TNPC.getName: String;
begin
  Result := FName;
end;
end.
