{Generates board that contains BoardRows based on BoardNodes}
Unit UBoard;
{$mode delphi}

interface

Uses UBoardRow, UPlant, UZombie, sysutils;

type
  TBoard = class(TInterfacedObject)
  private
    //FZombieScope: TDictionary<string, integer>;
    FScore: integer;
    FMoney: integer;
    FZombiesToSpawn: integer;
    FTotalZombies: integer;
    FBoard: array of TBoardRow;
  public
    constructor Create(zombiesToSpawn: integer; score: integer; money: integer); overload;
    //constructor Create(zombieScope: TDictionary<string, integer>; score: integer; money: integer); overload;
    function GetZombieLocation: TArray<integer>;
    function HasWon: boolean;
    function HasLost: boolean;
    procedure FightPlantZombie;
    procedure IncrementMoney;
    procedure MoveZombies;
    procedure RunBoard;
    procedure GenerateZombieSpawn;
    function AddPlant(x: integer; y: integer; plant: TPlant): TPlant;
    function AddZombie(x: integer; y: integer; zombie: TZombie): boolean;
    function GetMoney: integer;
    procedure SetMoney(money: integer);
    function GetBoard: TArray<TBoardRow>;
    function GetScore: integer;
  end;

const BOARD_ROWS = 5;

implementation
{
Default constructor Initializes model for 5x9 board
@param zombiesToSpawn int number of zombies that would be randomly generated
@param score          int initial score for the game (round)
@param money          int initial amount of money
}
constructor TBoard.Create(zombiesToSpawn: integer; score: integer; money: integer);
var
  i: integer;
begin
  Randomize;
  FScore := score;
  FMoney := money;
  FZombiesToSpawn := zombiesToSpawn;
  FTotalZombies := zombiesToSpawn;
  //FZombieScope := TDictionary<string, integer>.Create;
  SetLength(FBoard, BOARD_ROWS);

  for i := 0 to BOARD_ROWS - 1 do
    FBoard[i] := TBoardRow.Create;
end;

{
Default constructor with level builder functionality that initializes model for 5x9 board
@param zombieScope Map where key is name of the zombie, value - number of zombies of this type to spawn
@param score          int initial score for the game (round)
@param money          int initial amount of money
constructor TBoard.Create(zombieScope: TDictionary<string, integer>; score: integer; money: integer);
var
  i: integer;
  key: string;
  temp: integer;
begin
  Randomize;
  FScore := score;
  FMoney := money;
  FZombieScope := zombieScope;

  FZombiesToSpawn := 0;
  for key in FZombieScope.Keys do
  begin
    temp := FZombieScope[key];
    FZombiesToSpawn := FZombiesToSpawn + temp;
  end;

  FTotalZombies := FZombiesToSpawn;

  SetLength(FBoard, BOARD_ROWS);

  for i := 0 to BOARD_ROWS - 1 do
    FBoard[i] := TBoardRow.Create;
end;
}

{
Gets all zombies locations on the board.
Even indices of the array represent x location of zombies, odd are y; [1,2,5,4] means zombie at (1,2) and another at (5,4)
@return int array of generated zombie locations
}
function TBoard.GetZombieLocation: TArray<integer>;
var
  location: TArray<integer>;
  i, j, y: integer;
begin
  SetLength(location, FTotalZombies * 2);

  for i := 0 to Length(location) - 1 do
    location[i] := -1;

  y := 0;

  for i := 0 to BOARD_ROWS - 1 do
    for j := 0 to BOARD_COLS - 1 do
      if (not FBoard[i].HasPlant(j)) and FBoard[i].HasZombie(j) then
      begin
        location[y] := i;
        location[y + 1] := j;
        y := y + 2;
      end;

  Result := location;
end;

{
Checks if player won the game
@return returns a boolean, true for win
}
function TBoard.HasWon: boolean;
var
  arr: TArray<integer>;
begin
  arr := GetZombieLocation;
  Result := (FZombiesToSpawn = 0) and (arr[0] = -1);
end;

{
Checks if player lost the game
@return returns a boolean, true for loss
}
function TBoard.HasLost: boolean;
var
  arr: TArray<integer>;
  i: integer;
begin
  arr := GetZombieLocation;
  for i := 1 to Length(arr) - 1 do
    if arr[i] = 0 then
      Exit(True);
  Result := False;
end;

{
Simulates fight between Zombies and Plants on each row and if Plant kill Zombie add point to the player
}
procedure TBoard.FightPlantZombie;
var
  br: TBoardRow;
begin
  for br in FBoard do
    FScore := br.FightPvsZ(FScore);
end;

{
Increment money if at least one of the rows contains MoneyFlower (if more, values added)
}
procedure TBoard.IncrementMoney;
var
  br: TBoardRow;
begin
  for br in FBoard do
    FMoney := br.GenerateMoney(FMoney);
end;

{
Move Zombies across board in each row
}
procedure TBoard.MoveZombies;
var
  br: TBoardRow;
begin
  for br in FBoard do
    br.MoveZombie;
end;

{
Main method that runs the Zombie generation, simulates fight method, moves zombies across board and prints board.
}
procedure TBoard.RunBoard;
begin
  IncrementMoney;
  FightPlantZombie;
  MoveZombies;
  GenerateZombieSpawn;
end;

{
Randomly generates zombies' spawn location on the board
}
procedure TBoard.GenerateZombieSpawn;
var
  randRow: integer;
  //keys: TArray<string>;
  //key: string;
  //multiplier: integer;
begin
  if FZombiesToSpawn > 0 then
    if Random(2) = 0 then
    begin
      randRow := Random(BOARD_ROWS);
      if not FBoard[randRow].HasZombie(BOARD_COLS - 1) then
        {if not FZombieScope.Count = 0 then
        begin
          keys := FZombieScope.Keys.ToArray;
          for key in keys do
            if (Random(2) = 0) and (FZombieScope[key] > 0) then
            begin
              multiplier := StrToInt(key[key.Length]);
              AddZombie(randRow, BOARD_COLS - 1, TZombie.Create(key, multiplier * 100, multiplier * (1 div 2) * 10, multiplier * 10, 'ImagePath')); // Разобраться с путями
              FZombieScope.AddOrSetValue(key, (FZombieScope[key] - 1));
              Dec(FZombiesToSpawn);
              Break;
            end;
        end else}
        begin
          if Random(2) = 0 then
            AddZombie(randRow, BOARD_COLS - 1, TZombie.Create('Zombie1', 100, 20, 10, 'ImagePath'))
          else
            AddZombie(randRow, BOARD_COLS - 1, TZombie.Create('Zombie2', 200, 15, 20, 'ImagePath')); // Разобраться с путями
          Dec(FZombiesToSpawn);
        end;
    end;
end;

{
Adds Plant object on a specific coordinate
@param x     int column index
@param y     int row index
@param plant Plant object
@return Plant returns the plant if it was added, null otherwise
}
function TBoard.AddPlant(x: integer; y: integer; plant: TPlant): TPlant;
begin
  if (FMoney >= 50) and (x >= 0) and (x < BOARD_COLS) and (y >= 0) and (y < BOARD_COLS) then
    if plant <> nil then
      if not FBoard[x].HasPlant(y) then
      begin
        FBoard[x].AddPlant(y, plant);
        FMoney := FMoney - 50;
        Exit(plant);
      end;
  Result := nil;
end;

{
Adds Zombie object on a specific coordinate
@param x      int row index
@param y      int column index
@param zombie Zombie object
@return boolean true if zombie added; false - otherwise
}
function TBoard.AddZombie(x: integer; y: integer; zombie: TZombie): boolean;
begin
  if (zombie <> nil) and (x >= 0) and (x < 5) and (y = 8) then
  begin
    FBoard[x].AddZombie(y, zombie);
    Exit(True);
  end;
  Result := False;
end;

{
Return amount of money player currently have
@return int amount of money
}
function TBoard.GetMoney: integer;
begin
  Result := FMoney;
end;

{
Sets the amount of money the player gets
@param money amount of money to set
}
procedure TBoard.SetMoney(money: integer);
begin
  FMoney := money;
end;

{
Return whole board rows generated for a particular board
@return ArrayList of BoardRows objects
}
function TBoard.GetBoard: TArray<TBoardRow>;
begin
  Result := FBoard;
end;

{
Return score
@return int score
}
function TBoard.GetScore: integer;
begin
  Result := FScore;
end;
end.