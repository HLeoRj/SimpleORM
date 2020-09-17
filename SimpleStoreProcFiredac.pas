{ ****************************************************************************** }
{ Projeto: Componente }
{ Colaboradores nesse arquivo: }
{ }
{ Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior. }

{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT) }

{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc., }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA. }
{ Voc� tamb�m pode obter uma copia da licen�a em: }
{ http://www.opensource.org/licenses/lgpl-license.php }
{ ****************************************************************************** }
{ Arquivo SimpleStoreProcFiredac.pas }
{ Desenvolvido e escrito por : Henrique Leonardo - hleonardo@yahoo.com.br }
{ Skype / Telegram : hleorj }
{ **************************************************************************** }

unit SimpleStoreProcFiredac;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  SimpleStoreProcInterface;

Type
  TSimpleStoreProcFiredac = class(TInterfacedObject, iSimpleStoreProc)
  private
    FConnection: TFDConnection;
    FStoreProce: TFDStoredProc;
  public
    constructor Create(aConnection: TFDConnection);
    destructor Destroy; override;
    class function New(aConnection: TFDConnection): iSimpleStoreProc;
    function NameStoreProc(Const aStoreProcName: String): iSimpleStoreProc;
    function Params(Const aNome: String; aValue: variant): iSimpleStoreProc;
    function ParamsImput(const aNome: String; aValue: variant)
      : iSimpleStoreProc;
    function ExecProc: iSimpleStoreProc;
    function ResultProc(aPrpRtti: TRttiProperty; aCampo: String): TValue;
    function Return(Const aNome: String; Out aValue: variant): iSimpleStoreProc;
  end;

implementation

{ TSimpleStoreProcFiredac<T> }

constructor TSimpleStoreProcFiredac.Create(aConnection: TFDConnection);
begin
  FStoreProce := TFDStoredProc.Create(nil);
  FConnection := aConnection;
  FStoreProce.Connection := FConnection;
end;

destructor TSimpleStoreProcFiredac.Destroy;
begin
  FreeAndNil(FStoreProce);
  inherited;
end;

function TSimpleStoreProcFiredac.ExecProc: iSimpleStoreProc;
begin
  Result := Self;
  FStoreProce.ExecProc;
end;

function TSimpleStoreProcFiredac.NameStoreProc(Const aStoreProcName: String)
  : iSimpleStoreProc;
begin
  Result := Self;
  FStoreProce.StoredProcName := aStoreProcName;
  FStoreProce.Prepare;
end;

class function TSimpleStoreProcFiredac.New(aConnection: TFDConnection)
  : iSimpleStoreProc;
begin
  Result := Self.Create(aConnection);
end;

function TSimpleStoreProcFiredac.Params(Const aNome: String; aValue: variant)
  : iSimpleStoreProc;
begin
  Result := Self;
  if FStoreProce.Params.FindParam(aNome) <> nil then
    FStoreProce.Params.ParamByName(aNome).Value := aValue
  else
    FStoreProce.Params.CreateParam(ftVariant, aNome, ptInput).Value := aValue;
end;

function TSimpleStoreProcFiredac.ResultProc(aPrpRtti: TRttiProperty;
  aCampo: String): TValue;
begin
  case aPrpRtti.PropertyType.TypeKind of
    tkUnknown:
      Result := FStoreProce.Params.ParamByName(aCampo).AsString;
    tkString, tkChar, tkUString:
      Result := FStoreProce.Params.ParamByName(aCampo).AsString;
    tkWChar:
      Result := FStoreProce.Params.ParamByName(aCampo).AsString;
    tkLString:
      Result := FStoreProce.Params.ParamByName(aCampo).AsString;
    tkWString:
      Result := FStoreProce.Params.ParamByName(aCampo).AsString;
    tkVariant:
      ;
    tkInt64:
      Result := FStoreProce.Params.ParamByName(aCampo).AsInteger;
    tkInteger:
      Result := FStoreProce.Params.ParamByName(aCampo).AsInteger;
    tkFloat:
      if CompareText('TDateTime', aPrpRtti.PropertyType.Name) = 0 then
        Result := FStoreProce.Params.ParamByName(aCampo).AsDateTime
      else
        Result := FStoreProce.Params.ParamByName(aCampo).AsFloat;
  end;
end;

function TSimpleStoreProcFiredac.ParamsImput(Const aNome: String;
  aValue: variant): iSimpleStoreProc;
begin
  Result := Self;
  if FStoreProce.Params.FindParam(aNome) <> nil then
    FStoreProce.Params.ParamByName(aNome).Value := aValue
  else
    FStoreProce.Params.CreateParam(ftVariant, aNome, ptInput).Value := aValue;
end;

function TSimpleStoreProcFiredac.Return(Const aNome: String;
  out aValue: variant): iSimpleStoreProc;
begin
  Result := Self;
  if FStoreProce.Params.FindParam(aNome) <> nil then
    aValue := FStoreProce.Params.ParamByName(aNome).Value
  else
    aValue := FStoreProce.Params.CreateParam(ftVariant, aNome, ptResult).Value;
end;

end.
