Program Main;
uses Windows, Crt, SysUtils, UBoard, UBoardRow, UBoardNode, UPlant;
var
    Board: TBoard;
    ABoard: array of TBoardRow;
    ARow: array of TBoardNode;
    i, j: integer;
    s: string;
    st: array of string;
    flag: Boolean;
begin
    Board := TBoard.Create(10,0,250); // Создаем модель из 10 зомби, нулевым счетом и 250 монетами
    for i := 0 to BOARD_ROWS do Board.AddPlant(i,0,TPlant.Create('Plant1', 500, 20, 'Image')); // Создаем растения
    SetLength(st, 5);
    while true do
      begin
        Board.RunBoard; // Основная процедура обновления модели
        ClrScr;
        if Board.HasWon then
            begin
              WriteLn('You won!');
              Break;
            end;
        if Board.HasLost then
            begin
              WriteLn('You lost!');
              Break;
            end;
        ABoard := Board.GetBoard; // Получаем строки из модели
        for i := 0 to BOARD_ROWS - 1 do
          begin
            ARow := ABoard[i].getRow; // Получаем ячейки из строки
            s := '';
            st[i] := '';
            for j := 0 to BOARD_COLS - 1 do
              begin
                flag := False;
                // Проверяем содержимое ячейки
                if ARow[j].hasPlant then
                    begin
                        if ARow[j].hasZombie then s += 'F' else s += 'P';
                        st[i] += ' P ' + IntToStr(ARow[j].getPlant.getHealth);
                        flag := True;
                    end;
                if ARow[j].hasZombie then
                    begin
                        if not ARow[j].hasPlant then s += 'Z';
                        st[i] += ' Z ' + IntToStr(ARow[j].getZombie.getHealth);
                        flag := True;
                    end;      
                if not flag then s += '_';
              end;
            writeln(s+st[i]);
          end;
        writeln('Score: ' + IntToStr(Board.GetScore));
        Sleep(3000);
      end;
    readln;
end.