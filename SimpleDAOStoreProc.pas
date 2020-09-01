{ ****************************************************************************** }
{ Projeto: Componente SimpleOrm }
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
{ Arquivo SimpleDAOStoreProc.pas }
{ Desenvolvido e escrito por : Henrique Leonardo - hleonardo@yahoo.com.br }
{ Skype / Telegram : hleorj }
{ Sendo a mesma doada ao Projeto: Componente SimpleOrm }
{ **************************************************************************** }

unit SimpleDAOStoreProc;

interface

uses
  System.RTTI,
  System.Generics.Collections,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  SimpleStoreProcInterface,
  Data.DB,
  SimpleAttributes,
  SimpleInterface,
  FireDAC.Stan.Param;

Type
  TSimpleDAOStoreProc<T: class, constructor> = class(TInterfacedObject,
    iSimpleDAOStoreProc<T>)
  private
    FStoreProc: iSimpleStoreProc;
    FiSimple: iSimpleStoreProcedure<T>;
    fValue: T;
    Function NamePk(Const aValue: String; var aObject: T): T;
    function FillParameterStoreProc(aInstance: T): iSimpleDAOStoreProc<T>;
    function StoreProcedureResultadoToEntity: T;
    function FillParameterStoreProcImput(aInstance: T): iSimpleDAOStoreProc<T>;
  public
    constructor Create(aStoreProc: iSimpleStoreProc);
    class function New(aStoreProc: iSimpleStoreProc): iSimpleDAOStoreProc<T>;
    destructor Destroy; override;
    function Find(const aID: Integer; var aObject: T)
      : iSimpleDAOStoreProc<T>; overload;
    function Find(const aID: String; var aObject: T)
      : iSimpleDAOStoreProc<T>; overload;
    function Update(aValue: T): iSimpleDAOStoreProc<T>;
    function StoreProcedureToEntity: T;
    function Instance: T;
    function &End: iSimpleDAOStoreProc<T>;
  end;

implementation

uses
  SimpleRTTI, SimpleSP;

{ TGenericDAO }

destructor TSimpleDAOStoreProc<T>.Destroy;
begin
  inherited;
end;

function TSimpleDAOStoreProc<T>.Update(aValue: T): iSimpleDAOStoreProc<T>;
var
  aStoreProcName: String;
begin
  Result := Self;
  fValue := aValue;
  FiSimple := TSimpleSP<T>.New(aValue).StoreProcName(aStoreProcName);
  FStoreProc.NameStoreProc(aStoreProcName);
  FillParameterStoreProc(fValue);
  FStoreProc.ExecProc;
  StoreProcedureResultadoToEntity;
end;

function TSimpleDAOStoreProc<T>.&End: iSimpleDAOStoreProc<T>;
begin
  Result := Self;
end;

constructor TSimpleDAOStoreProc<T>.Create(aStoreProc: iSimpleStoreProc);
begin
  FStoreProc := aStoreProc;
end;

class function TSimpleDAOStoreProc<T>.New(aStoreProc: iSimpleStoreProc)
  : iSimpleDAOStoreProc<T>;
begin
  Result := Self.Create(aStoreProc);
end;

function TSimpleDAOStoreProc<T>.FillParameterStoreProc(aInstance: T)
  : iSimpleDAOStoreProc<T>;
var
  Key: String;
  DictionaryFields: TDictionary<String, variant>;
begin
  Result := Self;
  DictionaryFields := TDictionary<String, variant>.Create;
  TSimpleRTTI<T>.New(aInstance).DictionaryFields(DictionaryFields);
  try
    for Key in DictionaryFields.Keys do
    begin
      FStoreProc.Params(Key, DictionaryFields.Items[Key]);
    end;
  finally
    FreeAndNil(DictionaryFields);
  end;
end;

function TSimpleDAOStoreProc<T>.Find(const aID: Integer; var aObject: T)
  : iSimpleDAOStoreProc<T>;
var
  aStoreProcName: String;
begin
  Result := Self;
  fValue := NamePk(IntToStr(aID), aObject);
  FiSimple := TSimpleSP<T>.New(fValue).StoreProcNameSel(aStoreProcName);
  FStoreProc.NameStoreProc(aStoreProcName);
  FillParameterStoreProcImput(fValue);
  FStoreProc.ExecProc;
  StoreProcedureToEntity;
end;

function TSimpleDAOStoreProc<T>.Find(const aID: String; var aObject: T)
  : iSimpleDAOStoreProc<T>;
var
  aStoreProcName: String;
begin
  Result := Self;
  fValue := NamePk(aID, aObject);
  FiSimple := TSimpleSP<T>.New(aObject).StoreProcNameSel(aStoreProcName);
  FStoreProc.NameStoreProc(aStoreProcName);
  FillParameterStoreProcImput(aObject);
  FStoreProc.ExecProc;
  StoreProcedureToEntity;
end;

function TSimpleDAOStoreProc<T>.StoreProcedureResultadoToEntity: T;
var
  ctxRtti: TRttiContext;
  typRtti: TRttiType;
  prpRtti: TRttiProperty;
  Info: PTypeInfo;
  Attribute: TCustomAttribute;
  vCampo: string;
  Value: TValue;
begin
  Result := FiSimple.Instance;
  Info := System.TypeInfo(T);
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(Info);
    for prpRtti in typRtti.GetProperties do
    begin
      vCampo := '';
      for Attribute in prpRtti.GetAttributes do
      begin
        if (Attribute is ResultProc) then
        begin
          vCampo := ResultProc(Attribute).Name;
          Value := FStoreProc.ResultProc(prpRtti, vCampo);
          prpRtti.SetValue(Pointer(Result), Value);
        end;
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TSimpleDAOStoreProc<T>.StoreProcedureToEntity: T;
var
  ctxRtti: TRttiContext;
  typRtti: TRttiType;
  prpRtti: TRttiProperty;
  Info: PTypeInfo;
  Attribute: TCustomAttribute;
  Aux: String;
  vCampo: string;
  Value: TValue;
begin
  Result := FiSimple.Instance;
  Info := System.TypeInfo(T);
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(Info);
    for prpRtti in typRtti.GetProperties do
    begin
      vCampo := '';
      for Attribute in prpRtti.GetAttributes do
      begin
        if (Attribute is Campo) then
        begin
          vCampo := Campo(Attribute).Name;
          Value := FStoreProc.ResultProc(prpRtti, vCampo);
          prpRtti.SetValue(Pointer(Result), Value);
        end;
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

Function TSimpleDAOStoreProc<T>.NamePk(const aValue: String; var aObject: T): T;
var
  ctxRtti: TRttiContext;
  typRtti: TRttiType;
  prpRtti: TRttiProperty;
  Info: PTypeInfo;
  Attribute: TCustomAttribute;
  Aux: String;
  vCampo: string;
  Value: TValue;
begin
  Result := aObject;
  Info := System.TypeInfo(T);
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(Info);
    for prpRtti in typRtti.GetProperties do
    begin
      vCampo := '';
      for Attribute in prpRtti.GetAttributes do
      begin
        if Attribute is Pk then
        begin
          vCampo := Campo(Attribute).Name;
          case prpRtti.PropertyType.TypeKind of
            tkUnknown:
              prpRtti.SetValue(Pointer(Result), aValue);
            tkString, tkChar, tkUString:
              prpRtti.SetValue(Pointer(Result), aValue);
            tkWChar:
              prpRtti.SetValue(Pointer(Result), aValue);
            tkLString:
              prpRtti.SetValue(Pointer(Result), aValue);
            tkWString:
              prpRtti.SetValue(Pointer(Result), aValue);
            tkVariant:
              ;
            tkInt64:
              prpRtti.SetValue(Pointer(Result), StrtoInt(aValue));
            tkInteger:
              prpRtti.SetValue(Pointer(Result), StrtoInt(aValue));
            tkFloat:
              if CompareText('TDateTime', prpRtti.PropertyType.Name) = 0 then
                prpRtti.SetValue(Pointer(Result), StrToDate(aValue));
          else
            prpRtti.SetValue(Pointer(Result), StrToFloat(aValue));
          end;
        end;
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TSimpleDAOStoreProc<T>.FillParameterStoreProcImput(aInstance: T)
  : iSimpleDAOStoreProc<T>;
var
  Key: String;
  DictionaryFields: TDictionary<String, variant>;
begin
  DictionaryFields := TDictionary<String, variant>.Create;
  TSimpleRTTI<T>.New(aInstance).DictionaryFieldsImput(DictionaryFields);
  try
    for Key in DictionaryFields.Keys do
    begin
      FStoreProc.Params(Key, DictionaryFields.Items[Key]);
    end;
  finally
    FreeAndNil(DictionaryFields);
  end;
end;

function TSimpleDAOStoreProc<T>.Instance: T;
begin
  Result := FiSimple.Instance;
end;

{
  function TSimpleDAOStoreProc<T>.NamePkId(const aValue: String): T;
  var
  ctxRtti: TRttiContext;
  typRtti: TRttiType;
  prpRtti: TRttiProperty;
  Info: PTypeInfo;
  Attribute: TCustomAttribute;
  Aux: String;
  vCampo: string;
  Value: TValue;
  begin
  Result := Instance;
  Info := System.TypeInfo(T);
  ctxRtti := TRttiContext.Create;
  try
  typRtti := ctxRtti.GetType(Info);
  for prpRtti in typRtti.GetProperties do
  begin
  vCampo := '';
  for Attribute in prpRtti.GetAttributes do
  begin
  if Attribute is Pk then
  begin
  vCampo := Campo(Attribute).Name;
  case prpRtti.PropertyType.TypeKind of
  tkUnknown:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkString, tkChar, tkUString:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkWChar:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkLString:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkWString:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkVariant:
  ;
  tkInt64:
  prpRtti.SetValue(Pointer(Result), StrtoInt(aValue));
  tkInteger:
  prpRtti.SetValue(Pointer(Result), StrtoInt(aValue));
  tkFloat:
  if CompareText('TDateTime', prpRtti.PropertyType.Name) = 0 then
  prpRtti.SetValue(Pointer(Result), StrToDate(aValue));
  else
  prpRtti.SetValue(Pointer(Result), StrToFloat(aValue));
  end;
  end;
  end;
  end;
  finally
  ctxRtti.Free;
  end;

  end;

  function TSimpleDAOStoreProc<T>.NamePkId(const aValue: Integer): T;
  var
  ctxRtti: TRttiContext;
  typRtti: TRttiType;
  prpRtti: TRttiProperty;
  Info: PTypeInfo;
  Attribute: TCustomAttribute;
  Aux: String;
  vCampo: string;
  Value: TValue;
  begin
  Result := Instance;
  Info := System.TypeInfo(T);
  ctxRtti := TRttiContext.Create;
  try
  typRtti := ctxRtti.GetType(Info);
  for prpRtti in typRtti.GetProperties do
  begin
  vCampo := '';
  for Attribute in prpRtti.GetAttributes do
  begin
  if Attribute is Pk then
  begin
  vCampo := Campo(Attribute).Name;
  case prpRtti.PropertyType.TypeKind of
  tkUnknown:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkString, tkChar, tkUString:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkWChar:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkLString:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkWString:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkVariant:
  ;
  tkInt64:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkInteger:
  prpRtti.SetValue(Pointer(Result), aValue);
  tkFloat:
  prpRtti.SetValue(Pointer(Result), aValue);
  end;
  end;
  end;
  end;
  finally
  ctxRtti.Free;
  end;

  end;
}
end.
