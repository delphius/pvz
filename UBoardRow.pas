Unit UBoardRow;
{$mode delphi}
{
Holds instances of the BoardNodes and creates virtual row on the board.
Simulates moving and fighting between Plants and Zombies in current row.
}

interface

Uses UBoardNode, UZombie, UPlant, UMoneyPlant;

type
  TBoardRow = class(TInterfacedObject)
  private
    FNodes: array of TBoardNode;
  public
    constructor Create;
    procedure moveZombie;
    procedure addZombie(index: Integer; newZombie: TZombie);
    procedure addPlant(index: Integer; newPlant: TPlant);
    function hasZombie(index: Integer): Boolean;
    function hasPlant(index: Integer): Boolean;
    function fightPvsZ(score: Integer): Integer;
    function generateMoney(money: Integer): Integer;
    function getRow: TArray<TBoardNode>;
  end;

const BOARD_COLS = 9;

implementation
{
Default constructor initializes a row of a board
}
constructor TBoardRow.Create;
var
  i: Integer;
begin
  SetLength(FNodes, BOARD_COLS);
  for i := 0 to BOARD_COLS - 1 do
    FNodes[i] := TBoardNode.Create;
end;

{
Moves zombies across plane (based on the number of node(s))
Assign ZOMBIE_WON to true if zombie stays on the first node (end of the board) and this node does not contain plant.
}
procedure TBoardRow.moveZombie;
var
  i: Integer;
  current, next: TBoardNode;
begin
  for i := 0 to BOARD_COLS - 2 do
  begin
    current := FNodes[i];
    next := FNodes[i + 1];
    if current.hasZombie and current.hasPlant then
      Continue;
    if next.hasZombie and not current.hasZombie and not next.hasPlant then
      current.addZombie(next.destroyZombie);
  end;
end;

{
Adds Zombie object to the specific position
@param index int index where to add Zombie
@param newZombie Zombie object
}
procedure TBoardRow.addZombie(index: Integer; newZombie: TZombie);
begin
  if newZombie <> nil then
    FNodes[index].addZombie(newZombie);
end;

{
Adds Plant object to the specific position
@param index int index where to add Plant
@param newPlant Plant object
}
procedure TBoardRow.addPlant(index: Integer; newPlant: TPlant);
begin
  if newPlant <> nil then
    FNodes[index].addPlant(newPlant);
end;

{
Check if the Zombie exists in a specific position
@param index position to check Zombie instance
@return boolean true if zombie exists in the specified position; false - otherwise
}
function TBoardRow.hasZombie(index: Integer): Boolean;
begin
  if index >= 0 then
    Result := FNodes[index].hasZombie
  else
    Result := False;
end;

{
Check if the Plant exists in a specific position
@param index position to check Plant instance
@return boolean true if plant exists in the specified position; false - otherwise
}
function TBoardRow.hasPlant(index: Integer): Boolean;
begin
  if index >= 0 then
    Result := FNodes[index].hasPlant
  else
    Result := False;
end;

{
Simulates fighting between Plant and Zombie
@param score int current player score
@return int reward for the player when plant kills zombie
}
function TBoardRow.fightPvsZ(score: Integer): Integer;
var
  i, j: Integer;
  plantFind, zombieFind: TBoardNode;
  z: TZombie;
begin
  for i := 0 to BOARD_COLS - 1 do
  begin
    plantFind := FNodes[i];
    if plantFind.hasPlant then
    begin
      for j := i to BOARD_COLS - 1 do
      begin
        zombieFind := FNodes[j];
        if (plantFind = zombieFind) and plantFind.hasZombie then
        begin
          score += plantFind.plantFightZombie;
          Break;
        end else if (plantFind <> zombieFind) and zombieFind.hasZombie then
        begin
          z := plantFind.plantFightZombie(zombieFind.destroyZombie);
          if z.getHealth <= 0 then
          begin
            zombieFind.addZombie(nil);
            score += z.getPointsOnDeath;
          end else
            zombieFind.addZombie(z);
          Break;
        end;
      end;
    end;
  end;
  Result := score;
end;

{
Money generator if on row contains MoneyFlower with 50% chance to gain money
@param money int amount of money player currently have
@return int amount of money player gain from MoneyFlower
}
function TBoardRow.generateMoney(money: Integer): Integer;
var
  bn: TBoardNode;
begin
  for bn in FNodes do
    if bn.hasMoneyPlant then
    begin
      if Random(2) mod 2 = 0 then
      begin
        money += bn.getMoneyPlant.getMoney;
        Result := money;
        Exit;
      end;
    end;
  Result := money;
end;

{
Return array of FNodes that contain
@return ArrayList of BoardNode's
}
function TBoardRow.getRow: TArray<TBoardNode>;
begin
  if FNodes <> nil then
    Result := FNodes
  else
    Result := nil;
end;
end.