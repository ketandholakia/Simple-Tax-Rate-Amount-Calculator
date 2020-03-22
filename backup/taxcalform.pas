unit taxcalform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btn1: TButton;
    edValue: TEdit;
    edVat: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ledGross: TLabeledEdit;
    ledGrossFromVat: TLabeledEdit;
    ledNet: TLabeledEdit;
    ledNetFromVat: TLabeledEdit;
    ledVat: TLabeledEdit;
    ledVatFromGross: TLabeledEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlgross: TPanel;
    pnlgrossfromvat: TPanel;
    pnlnet: TPanel;
    pnlnetfromvat: TPanel;
    pnlvalue: TPanel;
    pnlvatamount: TPanel;
    pnlvatfromgross: TPanel;
    procedure btn1Click(Sender: TObject);
    procedure edValueChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
      fVatRate: double;
    { private declarations }
  public
        property VatRate :  double read fVatRate;
    constructor Create (const vatValue : double);

    function Vat(const netValue : double) : double;
    function Gross(const netValue : double) : double;
    function Net(const grossValue : double) :  double;
    function VatFromGross(const grossValue : double) :  double;
    function NetFromVat(const vatValue : double) :  double;
    function GrossFromVat(const vatValue : double) :  double;
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btn1Click(Sender: TObject);

  var
    vc : Tform1;
    valueIn : double;
  begin
    valueIn := StrToFloat(edValue.Text) ;
    vc := Tform1.Create(StrToFloat(edVat.Text));
    try
      ledVat.Text := FormatFloat('.00',vc.Vat(valueIn));
      ledGross.Text := FormatFloat('.00',vc.Gross(valueIn));
      ledNet.Text := FormatFloat('.00',vc.Net(valueIn));
      ledVatFromGross.Text := FormatFloat('.00',vc.VatFromGross(valueIn));
      ledNetFromVat.Text := FormatFloat('.00',vc.NetFromVat(valueIn));
      ledGrossFromVat.Text := FormatFloat('.00',vc.GrossFromVat(valueIn));
    finally
      vc.Free;
    end;

end;

procedure TForm1.edValueChange(Sender: TObject);
begin
  if (edVat.Text <> '') and (edValue.Text <> '')
  then
  begin
  btn1.Click;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

edValue.SetFocus;
end;

constructor TForm1.Create(const vatValue: double);
begin
  fVatRate := vatValue;
end;

function TForm1.Vat(const netValue: double): double;
begin
   result := VatRate * netValue / 100 ;
end;

function TForm1.Gross(const netValue: double): double;
begin
  result := netValue + Vat(netValue);
end;

function TForm1.Net(const grossValue: double): double;
begin
  result := 100 / (100 + VatRate) * grossValue;
end;

function TForm1.VatFromGross(const grossValue: double): double;
begin
   result := grossValue - Net(grossValue);
end;

function TForm1.NetFromVat(const vatValue: double): double;
begin
 result := vatValue * 100 / VatRate;
end;

function TForm1.GrossFromVat(const vatValue: double): double;
begin
  result := vatValue + NetFromVat(vatValue);
end;

end.

