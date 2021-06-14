:-module(usuario, 
        [carrega_tab/1, usuario/4, insere/4]).

:-use_module(library(persistency)).
:-use_module(library(crypto)).
:-use_module(chave, []).

:-persistent
    usuario(
        usuario_id: positive_integer,
        %cpf:positive_integer,
        nome: string,
        %dt_nasc: string,
        %estado: string,
        %cidade: string,
        %bairro: string
        %rua: string,
        %numero:positeve_integer,
        %cep:positive_integer,
        %telefone:positive_integer,
        %celular:positive_integer,
        email:string,
        %tipo_Usuario:string,
        %login:string,
        senha: atom
    ).

:-initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

%Criando alguns predicados para testar se db foi criado corretamente:

insere(Id, Nome, Email, Senha):-
    chave:pk(usuario, Id),
    with_mutex(usuario, (crypto_password_hash(Senha, Hash),
    assert_usuario(Id, Nome, Email, Hash))).


%insere(Id, Cpf, Nome, Dt_Nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        %Telefone, Celular, Email, Tipo_Usuario, Login, Senha):-
            %chave:pk(usuario, Id);
            %with_mutex(usuario, crypto_password(Senha, Hash), assert_usuario(Id, Cpf, Nome, Dt_Nasc, Estado, 
                %Cidade, Bairro, Rua, Numero, Cep, Telefone, Celular, Email, Tipo_Usuario, Login, Hash)).

%remove(Login):-
%usar sempre a chave primaria para remover
    %with_mutex(usuario, retract_usuario(_Cpf, _Nome, _Dt_Nasc, _Estado, _Cidade, _Bairro, _Rua, _Numero, _Cep, 
        %_Telefone, _Celular, _Email, _Tipo_Usuario, Login, _Senha)).