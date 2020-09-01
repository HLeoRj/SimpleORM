unit SimpleInterface;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  System.TypInfo,
{$IFNDEF CONSOLE}
  VCL.Forms,
{$ENDIF}
  System.SysUtils;

type
  iSimpleDAOSQLAttribute<T: class> = interface;

  iSimpleDAO<T: class> = interface
    ['{19261B52-6122-4C41-9DDE-D3A1247CC461}']
{$IFNDEF CONSOLE}
    function Insert: iSimpleDAO<T>; overload;
    function Update: iSimpleDAO<T>; overload;
    function Delete: iSimpleDAO<T>; overload;
{$ENDIF}
    function Insert(aValue: T): iSimpleDAO<T>; overload;
    function Update(aValue: T): iSimpleDAO<T>; overload;
    function Delete(aValue: T): iSimpleDAO<T>; overload;
    function Delete(aField: String; aValue: String): iSimpleDAO<T>; overload;
    function DataSource(aDataSource: TDataSource): iSimpleDAO<T>;
    function Find: iSimpleDAO<T>; overload;
    function Find(var aList: TObjectList<T>): iSimpleDAO<T>; overload;
    function Find(aId: Integer): T; overload;
    function SQL: iSimpleDAOSQLAttribute<T>;
{$IFNDEF CONSOLE}
    function BindForm(aForm: TForm): iSimpleDAO<T>;
{$ENDIF}
  end;

  iSimpleDAOSQLAttribute<T: class> = interface
    ['{5DE6F977-336B-4142-ABD1-EB0173FFF71F}']
    function Fields(aSQL: String): iSimpleDAOSQLAttribute<T>; overload;
    function Where(aSQL: String): iSimpleDAOSQLAttribute<T>; overload;
    function OrderBy(aSQL: String): iSimpleDAOSQLAttribute<T>; overload;
    function GroupBy(aSQL: String): iSimpleDAOSQLAttribute<T>; overload;
    function Join(aSQL: String): iSimpleDAOSQLAttribute<T>; overload;
    function Join: String; overload;
    function Fields: String; overload;
    function Where: String; overload;
    function OrderBy: String; overload;
    function GroupBy: String; overload;
    function Clear: iSimpleDAOSQLAttribute<T>;
    function &End: iSimpleDAO<T>;
  end;

  iSimpleRTTI<T: class> = interface
    ['{EEC49F47-24AC-4D82-9BEE-C259330A8993}']
    function TableName(var aTableName: String): iSimpleRTTI<T>;
    function ClassName(var aClassName: String): iSimpleRTTI<T>;
    function DictionaryFields(var aDictionary: TDictionary<string, variant>)
      : iSimpleRTTI<T>;
    function ListFields(var List: TList<String>): iSimpleRTTI<T>;
    function Update(var aUpdate: String): iSimpleRTTI<T>;
    function Where(var aWhere: String): iSimpleRTTI<T>;
    function Fields(var aFields: String): iSimpleRTTI<T>;
    function FieldsInsert(var aFields: String): iSimpleRTTI<T>;
    function Param(var aParam: String): iSimpleRTTI<T>;
    function DataSetToEntityList(aDataSet: TDataSet; var aList: TObjectList<T>)
      : iSimpleRTTI<T>;
    function DataSetToEntity(aDataSet: TDataSet; var aEntity: T)
      : iSimpleRTTI<T>;
    function StoreProcName(var aStoreProcName: String): iSimpleRTTI<T>;
    function StoreProcResult(var aResult: String): iSimpleRTTI<T>;
    function StoreProcSel(var aStoreProcName: String): iSimpleRTTI<T>;
    function StoreProcDel(var aStoreProcName: String): iSimpleRTTI<T>;
    function DictionaryFieldsImput(var aDictionary
      : TDictionary<string, variant>): iSimpleRTTI<T>;
{$IFNDEF CONSOLE}
    function BindClassToForm(aForm: TForm; const aEntity: T): iSimpleRTTI<T>;
    function BindFormToClass(aForm: TForm; var aEntity: T): iSimpleRTTI<T>;
{$ENDIF}
    function Instance: T;
  end;

  iSimpleSQL<T> = interface
    ['{1590A7C6-6E32-4579-9E60-38C966C1EB49}']
    function Insert(var aSQL: String): iSimpleSQL<T>;
    function Update(var aSQL: String): iSimpleSQL<T>;
    function Delete(var aSQL: String): iSimpleSQL<T>;
    function Select(var aSQL: String): iSimpleSQL<T>;
    function SelectId(var aSQL: String): iSimpleSQL<T>;
    function Fields(aSQL: String): iSimpleSQL<T>;
    function Where(aSQL: String): iSimpleSQL<T>;
    function OrderBy(aSQL: String): iSimpleSQL<T>;
    function GroupBy(aSQL: String): iSimpleSQL<T>;
    function Join(aSQL: String): iSimpleSQL<T>;
  end;

  iSimpleQuery = interface
    ['{6DCCA942-736D-4C66-AC9B-94151F14853A}']
    function SQL: TStrings;
    function Params: TParams;
    function ExecSQL: iSimpleQuery;
    function DataSet: TDataSet;
    function Open(aSQL: String): iSimpleQuery; overload;
    function Open: iSimpleQuery; overload;
  end;

  iSimpleStoreProcedure<T> = interface
    ['{616950F4-E01C-4E00-BDAD-35D67A569022}']
    function ProcName(Out aStoreProcName: String): iSimpleStoreProcedure<T>;
    function ProcResult(var aResult: String): iSimpleStoreProcedure<T>;
    function StoreProcName(var aStoreProcName: String)
      : iSimpleStoreProcedure<T>;
    function StoreProcNameSel(var aStoreProcName: String)
      : iSimpleStoreProcedure<T>;
    function StoreProcNameDel(var aStoreProcName: String)
      : iSimpleStoreProcedure<T>;
    function Instance: T;
  end;

implementation

end.
