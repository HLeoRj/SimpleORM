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
{ Arquivo SimpleSP.pas }
{ Desenvolvido e escrito por : Henrique Leonardo - hleonardo@yahoo.com.br }
{ Skype / Telegram : hleorj }
{ **************************************************************************** }

unit SimpleSP;

interface

uses
  SimpleInterface;

Type
  TSimpleSP<T: class, constructor> = class(TInterfacedObject, iSimpleStoreProcedure<T>)
  private
    FInstance: T;
  public
    constructor Create(aInstance: T);
    destructor Destroy; override;
    class function New(aInstance: T): iSimpleStoreProcedure<T>;
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

uses
  SimpleRTTI, System.Generics.Collections;

{ TSimpleStoreProcedure<T> }

constructor TSimpleSP<T>.Create(aInstance: T);
begin
  FInstance := aInstance;
end;

destructor TSimpleSP<T>.Destroy;
begin

  inherited;
end;

function TSimpleSP<T>.Instance: T;
begin
  result := FInstance;
end;

class function TSimpleSP<T>.New(aInstance: T): iSimpleStoreProcedure<T>;
begin
  result := Self.Create(aInstance);
end;

function TSimpleSP<T>.ProcName(out aStoreProcName: String)
  : iSimpleStoreProcedure<T>;
var
  lProcedureName: String;
begin
  result := Self;
  TSimpleRTTI<T>.New(FInstance).StoreProcName(lProcedureName);
  aStoreProcName := lProcedureName;
end;

function TSimpleSP<T>.ProcResult(var aResult: String): iSimpleStoreProcedure<T>;
var
  lResult: String;
begin
  result := Self;
  TSimpleRTTI<T>.New(FInstance).StoreProcResult(lResult);
  aResult := lResult;
end;

function TSimpleSP<T>.StoreProcName(var aStoreProcName: String)
  : iSimpleStoreProcedure<T>;
var
  lProcedureName: String;
begin
  result := Self;
  TSimpleRTTI<T>.New(FInstance).StoreProcName(lProcedureName);
  aStoreProcName := lProcedureName;
end;

function TSimpleSP<T>.StoreProcNameDel(var aStoreProcName: String)
  : iSimpleStoreProcedure<T>;
var
  lProcedureName: String;
begin
  result := Self;
  TSimpleRTTI<T>.New(FInstance).StoreProcDel(lProcedureName);
  aStoreProcName := lProcedureName;
end;

function TSimpleSP<T>.StoreProcNameSel(var aStoreProcName: String)
  : iSimpleStoreProcedure<T>;
var
  lProcedureName: String;
begin
  result := Self;
  TSimpleRTTI<T>.New(FInstance).StoreProcSel(lProcedureName);
  aStoreProcName := lProcedureName;
end;

end.
