unit Model.Dao.StoreProc.Generic;

interface

uses
  System.JSON,
  REST.JSON,
  SimpleInterface,
  SimpleDAO,
  SimpleAttributes,
  SimpleQueryFiredac,
  Data.DB,
  DataSetConverter4D,
  DataSetConverter4D.Impl,
  DataSetConverter4D.Helper,
  DataSetConverter4D.Util,
  SimpleStoreProcInterface;

type

  iDAOStoreProcGeneric<T: Class> = interface
    ['{9380EAF6-E43B-44DC-957A-392DD0479A3C}']
    function Find(const aID: String; var aObject: T)
      : iDAOStoreProcGeneric<T>; overload;
    function Find(const aID: Integer; var aObject: T)
      : iDAOStoreProcGeneric<T>; overload;
    function Find(const aID: String; const aJsonObject: TJsonObject)
      : TJsonObject; overload;
    function Find(const aID: Integer; const aJsonObject: TJsonObject)
      : TJsonObject; overload;
    function Update(const aJsonObject: TJsonObject): TJsonObject; overload;
    function Update(const aObject: T): iDAOStoreProcGeneric<T>; overload;
    function Dao: iSimpleDAOStoreProc<T>;
    function DataSetAsJsonObject: TJsonObject;
    function Instance: T;
  end;

  TDAOStoreProcGeneric<T: class, constructor> = class(TInterfacedObject,
    iDAOStoreProcGeneric<T>)
  private
    FIndexConn: Integer;
    FConn: iSimpleStoreProc;
    FDAO: iSimpleDAOStoreProc<T>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iDAOStoreProcGeneric<T>;
    function Find(const aID: String; var aObject: T)
      : iDAOStoreProcGeneric<T>; overload;
    function Find(const aID: Integer; var aObject: T)
      : iDAOStoreProcGeneric<T>; overload;
    function Find(const aID: String; const aJsonObject: TJsonObject)
      : TJsonObject; overload;
    function Find(const aID: Integer; const aJsonObject: TJsonObject)
      : TJsonObject; overload;
    function Update(const aJsonObject: TJsonObject): TJsonObject; overload;
    function Update(const aObject: T): iDAOStoreProcGeneric<T>; overload;
    function Delete(aField: String; aValue: String): TJsonObject;
    function Dao: iSimpleDAOStoreProc<T>;
    function DataSetAsJsonObject: TJsonObject;
    function Instance: T;
  end;

implementation

{ TDAOStoreProcGeneric<T> }

uses Model.Connection, System.SysUtils, SimpleStoreProcFiredac,
  SimpleDAOStoreProc;

constructor TDAOStoreProcGeneric<T>.Create;
begin
  FIndexConn := Model.Connection.Connected;
  FConn := TSimpleStoreProcFiredac.New(Model.Connection.FConnList.Items
    [FIndexConn]);
  FDAO := TSimpleDAOStoreProc<T>.New(FConn)
end;

function TDAOStoreProcGeneric<T>.Dao: iSimpleDAOStoreProc<T>;
begin
  Result := FDAO;
end;

function TDAOStoreProcGeneric<T>.DataSetAsJsonObject: TJsonObject;
begin
  Result := TJson.ObjectToJsonObject(FDAO.Instance,
    [joDateIsUTC, joDateFormatISO8601]);
end;

function TDAOStoreProcGeneric<T>.Delete(aField, aValue: String): TJsonObject;
begin
  FDAO.Update(self);
end;

destructor TDAOStoreProcGeneric<T>.Destroy;
begin
  Model.Connection.Disconnected(FIndexConn);
  inherited;
end;

function TDAOStoreProcGeneric<T>.Find(const aID: Integer;
  const aJsonObject: TJsonObject): TJsonObject;
begin
{  FDAO.Find(aID, TJson.JsonToObject<T>(aJsonObject));
  Result := self.DataSetAsJsonObject;}
end;

function TDAOStoreProcGeneric<T>.Find(const aID: String;
  const aJsonObject: TJsonObject): TJsonObject;
begin
{  FDAO.Find(aID, TJson.JsonToObject<T>(aJsonObject));
  Result := self.DataSetAsJsonObject;}
end;

function TDAOStoreProcGeneric<T>.Find(const aID: Integer; var aObject: T)
  : iDAOStoreProcGeneric<T>;
begin
  Result := self;
  FDAO.Find(aID, aObject);
end;

function TDAOStoreProcGeneric<T>.Find(const aID: String; var aObject: T)
  : iDAOStoreProcGeneric<T>;
begin
  Result := self;
  FDAO.Find(aID, aObject);
end;

function TDAOStoreProcGeneric<T>.Instance: T;
begin
  Result := FDAO.StoreProcedureToEntity;
end;

class function TDAOStoreProcGeneric<T>.New: iDAOStoreProcGeneric<T>;
begin
  Result := self.Create;
end;

function TDAOStoreProcGeneric<T>.Update(const aJsonObject: TJsonObject)
  : TJsonObject;
begin
  FDAO.Update(TJson.JsonToObject<T>(aJsonObject));
  Result := self.DataSetAsJsonObject;
end;

function TDAOStoreProcGeneric<T>.Update(const aObject: T)
  : iDAOStoreProcGeneric<T>;
begin
  Result := self;
  FDAO.Update(aObject);
end;

end.
