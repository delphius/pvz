
{This class is responsible for making zombies and making them attack}
unit UZombie;

interface

uses UNPC;

type
  TZombie = class(TNPC)
  private
    FScoreOnDeath: Integer;
  public
    constructor Create(name: String; health: Integer; imgURL: String); overload;
    constructor Create(name: String; health: Integer; attackPower: Integer; imgURL: String); overload;
    constructor Create(name: String; health: Integer; attackPower: Integer; scoreOnDeath: Integer; imgURL: String); overload;
    function getPointsOnDeath: Integer;
    procedure attack(npc: TNPC); override;
  end;

implementation
{
Initializes a new zombie
@param name Zombie's name
@param health Zombie's health
@param imgURL ImageIcon of the zombie on the board (GUI)
}
constructor TZombie.Create(name: String; health: Integer; imgURL: String);
begin
  inherited Create(name, health, imgURL);
end;

{
Initializes a new zombie
@param name Zombie's name
@param health Zombie's health
@param attackPower zombie's attack power
@param imgURL ImageIcon of the zombie on the board (GUI)
}
constructor TZombie.Create(name: String; health, attackPower: Integer; imgURL: String);
begin
  inherited Create(name, health, attackPower, imgURL);
end;

{
Initializes a new zombie
@param name Zombie's name
@param health Zombie's health
@param attackPower zombie's attack power
@param scoreOnDeath score added to the player when zombie is died
@param imgURL ImageIcon of the zombie on the board (GUI)
}
constructor TZombie.Create(name: String; health, attackPower, scoreOnDeath: Integer; imgURL: String);
begin
  inherited Create(name, health, attackPower, imgURL);
  Self.FScoreOnDeath := scoreOnDeath;
end;

{
Returns amount of points that would be added to the game score when zombie died
@return int score when dead
}
function TZombie.getPointsOnDeath: Integer;
begin
  Result := FScoreOnDeath;
end;

{
Allows the zombie to attack plants
@param npc The plant to attack
}
procedure TZombie.attack(npc: TNPC);
begin
  if (npc <> nil) and (npc.getHealth > 0) then
    npc.setHealth(npc.getHealth - getAttackPower);
end;
end.