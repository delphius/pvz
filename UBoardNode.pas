{Board node is holding information about NPCs on it.}
Unit UBoardNode;

interface

uses UPlant, UZombie, UMoneyPlant, UPea;

type
  TBoardNode = class(TInterfacedObject)
  private
    FPlant: TPlant;
    FZombie: TZombie;
    FPea: TPea;
  public
    constructor Create;
    function destroyZombie: TZombie;
    function addPlant(plant: TPlant): TPlant;
    function addPea(pea: TPea): TPea;
    function plantFightZombie: Integer;
    function plantFightZombie(zombie: TZombie): TZombie;
    function hitZombiePea: Integer;
    procedure addZombie(zombie: TZombie);
    function hasZombie: Boolean;
    function hasPlant: Boolean;
    function hasPea: Boolean;
    function getPlant: TPlant;
    function getMoneyPlant: TMoneyPlant;
    function getPea: TPea;
    function getZombie: TZombie;
    function hasMoneyPlant: Boolean;
    function removePlant: TPlant;
    function removePea: TPea;
  end;

implementation
{
Default constructor that creates empty node
}
constructor TBoardNode.Create;
begin
  FPlant := nil;
  FZombie := nil;
  FPea := nil;
end;

{
Remove Zombie instance if exists
@return Zombie instance of current node before Zombie will be removed
}
function TBoardNode.destroyZombie: TZombie;
var
  z: TZombie;
begin
  if FZombie <> nil then
  begin
    z := FZombie;
    FZombie := nil;
    Result := z;
  end else
    Result := nil;
end;

{
Adds Plant instance to the current node
@param plant new Plant
@return Plant returns the plant if it was added, null otherwise
}
function TBoardNode.addPlant(plant: TPlant): TPlant;
begin
  if FPlant = nil then
  begin
    FPlant := plant;
    Result := FPlant;
  end else
    Result := nil;
end;

{
Adds Pea instance to the current node
@param pea new Pea
@return Pea returns the pea if it was added, null otherwise
}
function TBoardNode.addPea(pea: TPea): TPea;
begin
  if FPea = nil then
  begin
    FPea := pea;
    Result := FPea;
  end else
    Result := nil;
end;

{
Simulates fight between Plant and Zombie in current node
@return int reward when plant kills zombie
}
function TBoardNode.plantFightZombie: Integer;
begin
  FPlant.attack(FZombie);
  if FZombie.getHealth <= 0 then
  begin
    Result := FZombie.getPointsOnDeath;
    FZombie := nil;
  end else
  begin
    FZombie.attack(FPlant);
    if FPlant.getHealth <= 0 then
      FPlant := nil;
    Result := 0;
  end;
end;

{
Simulates fight between current Plant instance and given Zombie instance
@param zombie Zombie object to fight with
@return Zombie if not dead; otherwise Zombie with updated health
}
function TBoardNode.plantFightZombie(zombie: TZombie): TZombie;
begin
  FPlant.attack(zombie);
  Result := zombie;
end;

{
Simulates hitting Zombie by Pea in current node
@return int reward when pea kills zombie
}
function TBoardNode.hitZombiePea: Integer;
begin
  FPea.attack(FZombie);
  if FZombie.getHealth <= 0 then
  begin
    Result := FZombie.getPointsOnDeath;
    FZombie := nil;
    FPea := nil;
  end else
  begin
    FPea := nil;
    Result := 0;
  end;
end;

{
Adds Zombie instance into the node
@param zombie Zombie object
}
procedure TBoardNode.addZombie(zombie: TZombie);
begin
  FZombie := zombie;
end;

{
Check if the current node contain Zombie object
@return boolean true - node contain zombie instance; false - otherwise
}
function TBoardNode.hasZombie: Boolean;
begin
  Result := FZombie <> nil;
end;

{
Check if the current node contain Plant object
@return boolean returns true if this board node has a plant, false otherwise
}
function TBoardNode.hasPlant: Boolean;
begin
  Result := FPlant <> nil;
end;

{
Check if the current node contain Pea object
@return boolean returns true if this board node has a pea, false otherwise
}
function TBoardNode.hasPea: Boolean;
begin
  Result := FPea <> nil;
end;

{
Returns plant instance if the current node
@return Plant instance of the plant
}
function TBoardNode.getPlant: TPlant;
begin
  Result := FPlant;
end;

{
Returns MoneyPlant if exists in current node
@return MoneyPlant object of MoneyPlant
}
function TBoardNode.getMoneyPlant: TMoneyPlant; 
begin 
if (FPlant is TMoneyPlant) then 
    Result:=TMoneyPlant(FPlant) 
      else 
    Result:=nil; 
end; 

{
Returns pea instance if the current node
@return Pea instance of the pea
}
function TBoardNode.getPea: TPea;
begin
  Result := FPea;
end;

{
Returns zombie instance of the current node
@return Zombie instance of Zombie
}
function TBoardNode.getZombie: TZombie; 
begin 
  Result:=FZombie; 
end; 

{
Check if the plant stored in the current node is MoneyPlant
@return boolean true when Plant stored in the node is MoneyPlant instance; false - otherwise
}
function TBoardNode.hasMoneyPlant:Boolean; 
begin 
  Result:=FPlant is TMoneyPlant;
end; 

{
Removes this plant from the board and returns it
@return Plant returns the removed plant
}
function TBoardNode.removePlant:TPlant; 
  var p:TPlant; 
begin 
  p:=FPlant; 
  FPlant:=nil;
  Result:=p; 
end;

{
Removes this pea from the board and returns it
@return Pea returns the removed pea
}
function TBoardNode.removePea:TPea;
  var p:TPea;
begin

if FPea <> nil then
  begin
    p := FPea;
    FPea := nil;
    Result := p;
  end else
    Result := nil;
end;
end.
