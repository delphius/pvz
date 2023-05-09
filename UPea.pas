
{This class is responsible for making peas and making them attack}
unit UPea;

interface

uses UNPC;


type
  TPea = class(TNPC)
  public
    constructor Create(name: String; health: Integer; attackPower: Integer); overload;
    procedure attack(npc: TNPC); override;
  end;

implementation
{
Initializes a new Pea
@param name Pea's name
@param health Pea's health
@param attackPower Pea's attack power
@param imgURL ImageIcon image of the pea on the board (GUI)
}
constructor TPea.Create(name: String; health, attackPower: Integer);
begin
  inherited Create(name, 0, attackPower); //Peas have no health
end;

{
Simulates fight between Plant and given NPC (Zombie)
@param npc NPC to be attacked
}
procedure TPea.attack(npc: TNPC);
begin
  if (npc <> nil) and (npc.getHealth > 0) then
    npc.setHealth(npc.getHealth - getAttackPower);
end;
end.
