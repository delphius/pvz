unit Unit1;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, UBoard, UBoardRow, UBoardNode, UPlant, UView;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    {**
     * Constructor procedure to create and setup Model and View
     *}
    procedure FormCreate(Sender: TObject);
    {**
     * Timer procedure to emulate model's step
     *}
    procedure Timer1Timer(Sender: TObject);
  private

  public
    ABoard: TBoard; // Model instance
    ABoardRow: array of TBoardRow; // Model's rows array
    ABoardNode: array of TBoardNode; // Model's nodes array
    AGameView: TView; // Game view instance
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var RowIndex: integer;
begin
  // Create a model with 10 zombies, a score of 0 and 1000 coins
  ABoard := TBoard.Create(10,0,1000);
  // Create plants
  for RowIndex := 0 to BOARD_ROWS - 1 do
      ABoard.AddPlant(RowIndex,1 + Random(BOARD_COLS - 4),TPlant.Create('Plant1', 150, 15));
  for RowIndex := 0 to BOARD_ROWS - 1 do
      ABoard.AddPlant(RowIndex,0,TPlant.Create('Plant1', 150, 15));
  // Create an instance of the View class and set it's properties
  AGameView := TView.Create(Self);
  AGameView.SetImageList(ImageList1);
  AGameView.Top := 100;
  AGameView.Parent := Self;
  // Link the model to the view and update the view
  AGameView.LinkModelView(ABoard);
  AGameView.UpdateView;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var br: TBoardRow;
    bn: TBoardNode;
begin
  // Update the model
  ABoard.RunBoard;
  // Update the view
  AGameView.UpdateView;
  Label1.Caption:='Зомби: ';
  Label2.Caption:='Растения: ';
  for br in ABoard.GetBoard do
      for bn in br.getRow do
          begin
             if bn.hasZombie then Label1.Caption := Label1.Caption + IntToStr(bn.getZombie.getHealth) + ' ';
             if bn.hasPlant then Label2.Caption := Label2.Caption + IntToStr(bn.getPlant.getHealth) + ' ';
          end;
  // Check if player has won or has lost and if he does then show appropriate message and terminate program
  if ABoard.HasWon or ABoard.HasLost then
        begin
           Timer1.Enabled:= false;
           if ABoard.HasLost then ShowMessage('You lost!') else ShowMessage('You won!');
           Application.Terminate;
        end;
end;

end.

