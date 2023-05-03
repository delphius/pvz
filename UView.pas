unit UView;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Buttons, ImgList, UBoard, UBoardRow, UBoardNode;

type
  { View }
  TView = class(TPanel)
  private
    FBoard: TBoard;
    FCells: array of array of TBitBtn;
    FCellWidth: Integer;
    FCellHeight: Integer;
    FImageList: TImageList;
  public
    {**
     * Constructor for the View class.
     * @param AOwner The owner of this component.
     *}
    constructor Create(AOwner: TComponent); override;

    procedure SetImageList(AImageList: TImageList);

    {**
     * Links the model to the view.
     * @param ABoard The TBoard model object to link to this view.
     *}
    procedure LinkModelView(ABoard: TBoard);

    {**
     * Updates the view to synchronize the sprites on the board buttons with the TBoard model.
     *}
    procedure UpdateView;

    {**
     * Returns the generated panel with buttons.
     * @return The generated panel with buttons.
     *}
    function GetPanel: TPanel;

    {**
     * Returns a two-dimensional array of buttons representing the cells on the game board.
     * @return A two-dimensional array of buttons representing the cells on the game board.
     *}
    function GetCells: TArray<TArray<TBitBtn>>;
  end;

  const BOARD_ROWS = 5;
  const BOARD_COLS = 9;

implementation

{ View }

constructor TView.Create(AOwner: TComponent);
var
  x, y: Integer;
begin
  inherited Create(AOwner);

  // Set default cell size
  FCellWidth := 100;
  FCellHeight := 100;

  // Set panel size to match game board size
  Width := BOARD_COLS * FCellWidth;
  Height := BOARD_ROWS * FCellHeight;

  // Create image list for sprites
  FImageList := TImageList.Create(Self);

  // Create cells
  SetLength(FCells, BOARD_ROWS, BOARD_COLS);
  for y := 0 to BOARD_ROWS - 1 do
    for x := 0 to BOARD_COLS - 1 do
    begin
      FCells[y][x] := TBitBtn.Create(Self);
      with FCells[y][x] do
      begin
        Parent := Self;
        Width := FCellWidth;
        Height := FCellHeight;
        Left := x * FCellWidth;
        Top := y * FCellHeight;
        Spacing := 0;
      end;
    end;
end;

procedure TView.SetImageList(AImageList: TImageList);
begin
  FImageList.Assign(AImageList);
end;

procedure TView.LinkModelView(ABoard: TBoard);
begin
  FBoard := ABoard;
  UpdateView;
end;

procedure TView.UpdateView;
var
  x, y: Integer;
  board: TArray<TBoardRow>;
  row: TBoardRow;
  node: TBoardNode;
  spriteIndex: Integer;

  function GetSpriteIndex(const AName: String): Integer;
begin
  // Return the pre-defined index in the FImageList image list for the given plant or zombie name
  if AName = 'Plant1' then
    Result := 1
  else if AName = 'Zombie1' then
    Result := 2
  else if AName = 'Zombie2' then
    Result := 3
  else if AName = 'Conehead Zombie' then
    Result := 4
  else if AName = 'Buckethead Zombie' then
    Result := 5
  else
    Result := -1;
end;

begin
  // Get the current state of the game board from the model
  board := FBoard.GetBoard;

  // Update the sprites on the buttons to match the state of the game board
  for y := 0 to BOARD_ROWS - 1 do
  begin
    row := board[y];
    for x := 0 to BOARD_COLS - 1 do
    begin
      node := row.getRow[x];
      if (node.hasPlant and node.hasZombie) then
        spriteIndex := 4
      else if node.hasPlant then
        spriteIndex := GetSpriteIndex(node.getPlant.getName)
      else if node.hasZombie then
        spriteIndex := GetSpriteIndex(node.getZombie.getName)
      else
        spriteIndex := 0;
      FImageList.GetBitmap(spriteIndex, FCells[y][x].Glyph);
    end;
  end;
end;

function TView.GetPanel: TPanel;
begin
  Result := Self;
end;

function TView.GetCells: TArray<TArray<TBitBtn>>;
begin
  Result := FCells;
end;

end.
