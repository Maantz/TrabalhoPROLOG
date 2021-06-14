%Conforme no modelo Entidade e Relacionamento o banco "dentista"
%possui apenas um campo que eh o "cro"
%no servidor eu coloquei outros dois campos "Login" e "Senha"

:-module(
        dentista,
       [dentista/4, insere/4]
    ).

:-use_module(library(persistency)).
:-use_module(library(crypto)).
:-use_module(chave, []).

:-persistent
    dentista(
        dentista_id:positive_integer,
        cro: string,
        login: string,
        senha: atom
        ).

:-initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

%Criando alguns predicados para testar se db foi criado corretamente:
insere(Id, CRO, Login, Senha):-
    chave:pk(usuario, Id),
    with_mutex(dentista, (crypto_password_hash(Senha, Hash),
                            assert_dentista(Id, CRO, Login, Hash))).




