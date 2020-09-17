{ ****************************************************************************** }
{ Projeto: Componente }
{ Colaboradores nesse arquivo: }
{ }
{ Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior. }

{ Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT) }

{ Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto }
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc., }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA. }
{ Você também pode obter uma copia da licença em: }
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
