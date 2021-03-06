# SimpleORM
ORM Simples para Aplicações Delphi

O SimpleORM tem o Objetivo de facilitar suas implementações de CRUD, agilizando mais de 80% do seu processo de desenvolvimento de software.

Homologado para os drivers de Conexão Firedac e RestDataware.

Entidade do Banco de Dados Mapeada

```delphi
uses
  SimpleAttributes;

Type
  [Tabela('PEDIDO')]
  [ProceName('PEDIDO_IU')]  
  TPEDIDO = class
  private
    FID: Integer;
    FCLIENTE: String;
    FDATAPEDIDO: TDatetime;
    FVALORTOTAL: Currency;
    procedure SetID(const Value: Integer);
    procedure SetCLIENTE(const Value: String);
    procedure SetDATAPEDIDO(const Value: TDatetime);
    procedure SetVALORTOTAL(const Value: Currency);
  public
    constructor Create;
    destructor Destroy; override;
  published
    [Campo('ID'), Pk, AutoInc]
    [FieldResult('RESULTID')]	
    property ID: Integer read FID write SetID;
    [Campo('NOME')]
    property CLIENTE: String read FCLIENTE write SetCLIENTE;
    [Campo('DATA')]
    property DATAPEDIDO: TDatetime read FDATAPEDIDO write SetDATAPEDIDO;
    [Campo('VALOR')]
    property VALORTOTAL: Currency read FVALORTOTAL write SetVALORTOTAL;
  end;
```

## Atributos
`Tabela`  - Informa o Nome da Tabela no Banco em que a Classe faz o mapeamento.

`ProceName` - Informa o Nome da Store Procedure no Banco em que a Classe faz o mapeamento.

`Campo`   - Informa o Nome do Campo no Banco de Dados em que a property está fazendo Referência.

`PK`      - Informa se o Campo é PrimaryKey.

`AutoInc` - Informa se o Campo é AutoIncremento.

`Ignore`  - Ignorar o Campo nas Operações de CRUD.

`FieldResult` - Informa o nome do campo de retorno na Store Procedure.

# Principais Operações


## Instalação
Basta adicionar ao LibraryPatch o Caminho do SimpleORM, não precisa realizar a instalação de nenhum componente.

## Uses Necessárias

SimpleInterface,

SimpleDAO,

SimpleAttributes,

`Dependendo do seu driver de Conexão utilizar as Uses` SimpleQueryFiredac ou SimpleQueryRestDW

## Inicialização do SimpleORM

```delphi
var
  Conn : iSimpleQuery;
  DAOPedido : iSimpleDAO<TPEDIDO>;
begin
  Conn := TSimpleQueryFiredac.New(FDConnection1);
  DAOPedido := TSimpleDAO<TPEDIDO>
                  .New(Conn)
                  .DataSource(DataSource1)
                  .BindForm(Self);
end;
```

`Conn`      - Instancia a Interface iSimpleQuery passando o componente de conexão que o SimpleORM irá trabalhar.

`DAOPedido` - Instância o DAO para uma Entidade Mapeada, passando a Classe de Mapeamento como Atributo Genérico.

`New`       - Recebe a Interface de Conexão iSimpleQuery.

`DataSource`- Você pode informar um DataSource para que os dados sejam armazenados nele para facilitar seu processo de listagem de dados, podem linkar ao DBGrid para exibição dos mesmos.

`Bind`      - Você pode informar o formulário que deseja que o SimpleORM faça o Bind automatico entre a Classe e os Componentes da tela (Edit, Combo, CheckBox, RadioButton e etc...)

## Uses Necessárias para Store Procedure 

SimpleInterface,

SimpleDAOStoreProc,

SimpleAttributes,

SimpleStoreProcInterface,

SimpleStoreProcFiredac;

## Inicialização do SimpleORM com Store procedure

```delphi
var
  ConnSp : iSimpleStoreProc;
  DAOSPPedido : iSimpleDAOStoreProc<TPEDIDO>;
begin
  ConnSp := TSimpleStoreProcFiredac.New(FDConnection1);
  DAOSPPedido := TSimpleDAOStoreProc<TPEDIDO>
                  .New(ConnSp).&End;
end;
```

`ConnSp`      - Instancia a Interface iSimpleStoreProc passando o componente de conexão que o SimpleORM irá trabalhar.

`DAOSPPedido` - Instância o DAOSP para uma Entidade Mapeada, passando a Classe de Mapeamento como Atributo Genérico.

`New`       - Recebe a Interface de Conexão iSimpleStoreProc.


## MAPEAMENTO DO BIND DO FORMULÁRIO
Quando você fizer o mapeamento Bind do Formulário, não precisará ligar manualmente os campos da classe ao Edits, o SimpleORM faz isso
automáticamente, basta você realizar o mapeamento correto conforme abaixo.

```delphi
type
  TForm1 = class(TForm)
    [Bind('CLIENTE')]
    Edit1: TEdit;
    [Bind('ID')]
    Edit2: TEdit;
    [Bind('VALORTOTAL')]
    Edit3: TEdit;
    Button2: TButton;
    [Bind('DATAPEDIDO')]
    DateTimePicker1: TDateTimePicker;
```

No atributo Bind de cada campo, você deve informar o nome da Property correspondente na Classe Mapeada do Banco de Dados, ATENÇÃO é o nome
que você deu para a property da classe e não o nome do campo na tabela do banco de dados.

## INSERT COM BIND

```delphi
begin
  DAOPedido.Insert;
end;
```

## INSERT COM OBJETO
```delphi
var
  Pedido : TPEDIDO;
begin
  Pedido := TPEDIDO.Create;
  try
    Pedido.ID := StrToInt(Edit2.Text);
    Pedido.CLIENTE := Edit1.Text;
    Pedido.DATAPEDIDO := now;
    Pedido.VALORTOTAL := StrToCurr(Edit3.Text);
    DAOPedido.Insert(Pedido);
  finally
    Pedido.Free;
  end;
end;
```

## UPDATE COM BIND
```delphi
begin
  DAOPedido.Update;
end;
```

## UPDATE COM OBJETO
```delphi
var
  Pedido : TPEDIDO;
begin
  Pedido := TPEDIDO.Create;
  try
    Pedido.ID := StrToInt(Edit2.Text);
    Pedido.CLIENTE := Edit1.Text;
    Pedido.DATAPEDIDO := now;
    Pedido.VALORTOTAL := StrToCurr(Edit3.Text);
    DAOPedido.Update(Pedido);
  finally
    Pedido.Free;
  end;
end;
```

## DELETE COM BIND
```delphi
begin
  DAOPedido.Delete;
end;
```

## DELETE COM OBJETO
```delphi
 var
  Pedido : TPEDIDO;
begin
  Pedido := TPEDIDO.Create;
  try
    Pedido.ID := StrToInt(Edit2.Text);
    DAOPedido.Delete(Pedido);
  finally
    Pedido.Free;
  end;
end;
```

## SELECT 
Você pode executar desde operações simples como trazer todos os dados da tabela, como filtrar campos e outras instruções SQL, 

executando a instrução abaixo você retornará todos os dados da tabela
```delphi
  DAOPedido.Find;
```

Abaixo um exemplo de todas as operações possíveis no SimpleORM
```delphi
begin
  DAOPedido
    .SQL
      .Fields('Informe os Campos que deseja trazer separados por virgula')
      .Join('Informe a Instrução Join que desejar ex INNER JOIN CLIENTE ON CLIENTE.ID = PRODUTO.CLIENTE')
      .Where('Coloque a Clausula Where que desejar ex: CODIGO = 1')
      .OrderBy('Informe o nome do Campo que deseja ordenar ex: ID')
      .GroupBy('Informe os campos que deseja agrupar separados por virgula')
    .&End
  .Find;
end;
```

Você também pode retornar uma Lista de Objetos para trabalhar com ela manualmente, abaixo um exemplo de como trazer a lista e trabalhar com ela exibindo todos os valores em um Memo
```delphi
var
  Pedidos : TObjectList<TPEDIDO>;
  Pedido : TPEDIDO;
begin
  Pedidos := TObjectList<TPEDIDO>.Create;
  DAOPedido.Find(Pedidos);
  try
    for Pedido in Pedidos do
    begin
      Memo1.Lines.Add(Pedido.CLIENTE + DateToStr(Pedido.DATAPEDIDO));
    end;
  finally
    Pedidos.Free;
  end;
end;
```

## STORE PROCEDURE  
Para utilização de uma store procedure, este segue o padrão de mapeamento de uma classe com atributo ProceName, ver mapeamento acima.

```delphi

 ( [ProceName('PEDIDO_IU')] )

``` 

Exemplo do desenvolvimento de uma S.P. no Firebird

```delphi

create or alter procedure PEDIDO_IU (
    ID integer,
    NOME varchar(60),
    DATA timestamp,
    VALOR decimal(18,2))
as
begin
  if (exists(select id from pedido where (id = :id))) then
    update pedido
    set nome = :nome,
        data = :data,
        valor = :valor
    where (id = :id);
  else
    insert into pedido (
        id,
        nome,
        data,
        valor)
    values (
        :id,
        :nome,
        :data,
        :valor);

end

```

Abaixo um exemplo de execução no SimpleORM 

```delphi

var
  Pedido: TPEDIDO;
begin
  Pedido := TPEDIDO.Create;
  try
    Pedido.ID := StrToInt(Edit2.Text);
    Pedido.CLIENTE := Edit1.Text;
    Pedido.DATAPEDIDO := now;
    Pedido.VALORTOTAL := StrToCurr(Edit3.Text);

    DAOSPPedido.Execute(Pedido).&End;

  finally
    Pedido.Free;
  end;
end;

```

Você também pode retornar um valor , definindo o campo de retorno
```delphi

   [FieldRetorno('RESULTID')]	
    property ID: Integer read FID write SetID;

```

Exemplo do desenvolvimento de uma S.P. no Firebird com retorno de valor ( RESULTID com tipo Inteiro )
```delphi

create or alter procedure PEDIDO_IU_RESULT (
    ID integer,
    NOME varchar(60),
    DATA timestamp,
    VALOR decimal(18,2))
returns (
    RESULTID integer)
as
begin
  RESULTID  = :id;
  if (exists(select id from pedido where (id = :id))) then
    update pedido
    set nome = :nome,
        data = :data,
        valor = :valor
    where (id = :id);
  else
  begin
    RESULTID = gen_id(gen_pedido_id,1);
    insert into pedido (
        id,
        nome,
        data,
        valor)
    values (
        :RESULTID,
        :nome,
        :data,
        :valor);
    end
end

```
Abaixo um exemplo de execução com retorno ( .result ) de valor no SimpleORM 
```delphi

var
  Pedido: TPEDIDO;
begin
  EditResultId.Text := '';
  Pedido := TPEDIDO.Create;
  try
    Pedido.ID := StrToInt(Edit2.Text);
    Pedido.CLIENTE := Edit1.Text;
    Pedido.DATAPEDIDO := now;
    Pedido.VALORTOTAL := StrToCurr(Edit3.Text);
    DAOSPPedido.Execute(Pedido).Result.&End;

    EditResultId.Text := IntToStr(Pedido.ID);

  finally
    Pedido.Free;
  end;
end;

```


