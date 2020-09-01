unit Controller.Produto;

interface

uses
  Horse,
  System.JSON,
  IdHashMessageDigest;

procedure Registry(App: THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses Model.DaoGeneric, Model.Dao.StoreProc.Generic, Model.Entity.Produto,
  REST.JSON;

procedure Registry(App: THorse);
begin
  App.Get('/produto', Get);
  App.Get('/produto/:id', GetID);
  App.Post('/produto', Insert);
  App.Put('/produto/:id', Update);
  App.Delete('/produto/:id', Delete);
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TProduto>;
begin
  FDAO := TDAOGeneric<TProduto>.New;
  Res.Send<TJSonArray>(FDAO.Find);
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOStoreProcGeneric<TProduto>;
  LBody: TJSONObject;
begin
  LBody := Req.Body<TJSONObject>;
  FDAO := TDAOStoreProcGeneric<TProduto>.New;
  Res.Send<TJSONObject>(FDAO.Find(Req.Params.Items['id'], LBody));
end;

procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Update(Req, Res, Next);
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOStoreProcGeneric<TProduto>;
  LBody: TJSONObject;
begin
  LBody := Req.Body<TJSONObject>;
  FDAO := TDAOStoreProcGeneric<TProduto>.New;
  Res.Send<TJSONObject>(FDAO.Update(LBody));
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

end;

end.
