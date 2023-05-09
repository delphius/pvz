
{This class is responsible for making plants and making them attack}
unit UPlant;

interface

uses UNPC;


type
  TPlant = class(TNPC)
  private
    FShoot: boolean;
  public
    constructor Create(name: String; health: Integer); overload;
    constructor Create(name: String; health: Integer; attackPower: Integer); overload;
    procedure attack(npc: TNPC); override;
    function isShoot: boolean;
  end;

implementation
{
Initializes a new Plant
@param name Plant's name
@param health Plant's health
@param imgURL ImageIcon image of the plant on the board (GUI)
}
constructor TPlant.Create(name: String; health: Integer);
begin
  inherited Create(name, health);
  FShoot := false;
end;

{
Initializes a new Plant
@param name Plant's name
@param health Plant's health
@param attackPower Plant's attack power
@param imgURL ImageIcon image of the plant on the board (GUI)
}
constructor TPlant.Create(name: String; health, attackPower: Integer);
begin
  inherited Create(name, health, attackPower);
end;

{
Simulates fight between Plant and given NPC (Zombie)
@param npc NPC to be attacked
}
procedure TPlant.attack(npc: TNPC);
begin
  if (npc <> nil) and (npc.getHealth > 0) then
    npc.setHealth(npc.getHealth - getAttackPower);
end;

function TPlant.isShoot: boolean;
begin
  FShoot := not FShoot;
  Result := FShoot;
end;
end.
