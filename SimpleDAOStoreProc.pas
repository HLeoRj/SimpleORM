{******************************************************************************}
{ Projeto: Componente SimpleOrm                                                }
{ Colaboradores nesse arquivo:                                                 }
{ }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{******************************************************************************}
{ Arquivo SimpleDAOStoreProc.pas                                               }
{ Desenvolvido e escrito por : Henrique Leonardo - hleonardo@yahoo.com.br      }
{   Skype / Telegram : hleorj                                                  }
{ Sendo a mesma doada ao Projeto: Componente SimpleOrm                         }
{ **************************************************************************** }

unit SimpleDAOStoreProc;

interface

uses
  System.RTTI,
  System.Generics.Collections,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  SimpleStoreProcInterface;

Type
  TSimpleDAOStoreProc<T: class, constructor> = class(TInterfacedObject, iSimpleDAOStoreProc<T>)
  private
    FStoreProc: iSimpleStoreProc;
    function FillParameterStoreProc(aInstance: T): iSimpleDAOStoreProc<T>;
  public
    constructor Create(aStoreProc: iSimpleStoreProc);
    class function New(aStoreProc: iSimpleStoreProc): iSimpleDAOStoreProc<T>;
    destructor Destroy; override;
    function Update(aValue: T): iSimpleDAOStoreProc<T>;
    function &End: iSimpleDAOStoreProc<T>;
  end;

implementation

uses
  SimpleRTTI,
  SimpleSQL;

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
  TSimpleSQL<T>.New(aValue).StoreProcName(aStoreProcName);
  FStoreProc.NameStoreProc(aStoreProcName);
  Self.FillParameterStoreProc(aValue);
  FStoreProc.ExecProc;
end;

function TSimpleDAOStoreProc<T>.&End: iSimpleDAOStoreProc<T>;
begin
  result := self;
end;

constructor TSimpleDAOStoreProc<T>.Create(aStoreProc: iSimpleStoreProc);
begin
  FStoreProc := aStoreProc;
end;

class function TSimpleDAOStoreProc<T>.New(aStoreProc: iSimpleStoreProc): iSimpleDAOStoreProc<T>;
begin
  Result := Self.Create(aStoreProc);
end;

function TSimpleDAOStoreProc<T>.FillParameterStoreProc(aInstance: T): iSimpleDAOStoreProc<T>;
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

end.
