program Main;

uses
  Windows, Crt, SysUtils, UBoard, UBoardRow, UBoardNode, UPlant;

var
  Board: TBoard;
  ABoard: array of TBoardRow;
  ARow: array of TBoardNode;
  RowIndex, ColIndex: integer;
  CellContent, PlantZombieHealth: string;

begin
  // Create a model with 10 zombies, a score of 0 and 250 coins
  Board := TBoard.Create(10,0,250);

  // Create plants
  for RowIndex := 0 to BOARD_ROWS do
    Board.AddPlant(RowIndex,0,TPlant.Create('Plant1', 500, 20, 'Image'));

  while true do
    begin
      // Main procedure for updating the model
      Board.RunBoard;
      ClrScr;

      if Board.HasWon or Board.HasLost then
        begin
          if Board.HasWon then WriteLn('You won!') else WriteLn('You lost!');
          Break;
        end;

      // Get rows from the model
      ABoard := Board.GetBoard;

      for RowIndex := 0 to BOARD_ROWS - 1 do
        begin
          // Get cells from the row
          ARow := ABoard[RowIndex].getRow;
          CellContent := '';
          PlantZombieHealth := '';

          for ColIndex := 0 to BOARD_COLS - 1 do
            begin
              // Check cell content
              if not (ARow[ColIndex].hasPlant or ARow[ColIndex].hasZombie) then
                begin
                  CellContent += '_';
                  Continue;
                end;

              if ARow[ColIndex].hasPlant then
                begin
                  if ARow[ColIndex].hasZombie then CellContent += 'F' else CellContent += 'P';
                  PlantZombieHealth += ' P ' + IntToStr(ARow[ColIndex].getPlant.getHealth);
                end;

              if ARow[ColIndex].hasZombie then
                begin
                  if not ARow[ColIndex].hasPlant then CellContent += 'Z';
                  PlantZombieHealth += ' Z ' + IntToStr(ARow[ColIndex].getZombie.getHealth);
                end;
            end;

          writeln(CellContent + PlantZombieHealth);
        end;

      writeln('Money: ' + IntToStr(Board.GetMoney) + ' Score: ' + IntToStr(Board.GetScore));
      Sleep(3000);
    end;

    readln;
end.