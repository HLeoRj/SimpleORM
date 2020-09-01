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
    function Find(const aID: String; var aObject: T): iDAOStoreProcGeneric<T>; overload;
    function Find(const aID: String): TJsonObject; overload;
    function Update(const aJsonObject: TJsonObject): TJsonObject; overload;
    function Update(const aObject: T): iDAOStoreProcGeneric<T>; overload;
    function DAO: iSimpleDAOStoreProc<T>;
    function DataSetAsJsonArray: TJsonArray;
    function DataSetAsJsonObject: TJsonObject;
    function DataSet: TDataSet;
  end;

  TDAOStoreProcGeneric<T: class, constructor> = class(TInterfacedObject, iDAOStoreProcGeneric<T>)
  private
    FIndexConn: Integer;
    FConn: iSimpleStoreProc;
    FDAO: iSimpleDAOStoreProc<T>;
    FDataSource: TDataSource;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iDAOStoreProcGeneric<T>;
    function Find(const aID: String; var aObject: T): iDAOStoreProcGeneric<T>; overload;
    function Find(const aID: String): TJsonObject; overload;
    function Update(const aJsonObject: TJsonObject): TJsonObject; overload;
    function Update(const aObject: T): iDAOStoreProcGeneric<T>; overload;
    function Delete(aField: String; aValue: String): TJsonObject;
    function DAO: iSimpleDAOStoreProc<T>;
    function DataSetAsJsonArray: TJsonArray;
    function DataSetAsJsonObject: TJsonObject;
    function DataSet: TDataSet;
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

function TDAOStoreProcGeneric<T>.DAO: iSimpleDAOStoreProc<T>;
begin
  Result := FDAO;
end;

function TDAOStoreProcGeneric<T>.DataSet: TDataSet;
begin
  Result := FDataSource.DataSet;
end;

function TDAOStoreProcGeneric<T>.DataSetAsJsonArray: TJsonArray;
begin
  Result := FDataSource.DataSet.AsJSONArray;
end;

function TDAOStoreProcGeneric<T>.DataSetAsJsonObject: TJsonObject;
begin
  Result := FDataSource.DataSet.AsJSONObject;
end;

function TDAOStoreProcGeneric<T>.Delete(aField, aValue: String): TJsonObject;
begin
  FDAO.Update(self);
  Result := FDataSource.DataSet.AsJSONObject;
end;

destructor TDAOStoreProcGeneric<T>.Destroy;
begin
  FDataSource.Free;
  Model.Connection.Disconnected(FIndexConn);
  inherited;
end;

function TDAOStoreProcGeneric<T>.Find(const aID: String; var aObject: T): iDAOStoreProcGeneric<T>;
begin
  Result := self;
  FDAO.Find(StrToInt(aID), aObject);
end;

function TDAOStoreProcGeneric<T>.Find(const aID: String): TJsonObject;
begin
  // FDAO.Find(StrToInt(aID), T );
  Result := FDataSource.DataSet.AsJSONObject;
end;

class function TDAOStoreProcGeneric<T>.New: iDAOStoreProcGeneric<T>;
begin
  Result := self.Create;
end;

function TDAOStoreProcGeneric<T>.Update(const aJsonObject: TJsonObject): TJsonObject;
begin
  FDAO.Update(TJson.JsonToObject<T>(aJsonObject));
  Result := TJson.ObjectToJsonObject( FDAO.StoreProcedureToEntity, [joDateIsUTC, joDateFormatISO8601] );
end;

function TDAOStoreProcGeneric<T>.Update(const aObject: T): iDAOStoreProcGeneric<T>;
begin
  FDAO.Update(aObject);
  Result := self;
end;

end.
