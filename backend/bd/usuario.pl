:-module(
    usuario,
    [
        carrega_tab/1,
        usuario/4,
        insere/4,
        remove/1,
        atualiza/4
    ]
).

:-use_module(library(persistency)).
:-use_module(library(crypto)).
:-use_module(chave, []).


:-persistent
    usuario(
        usuario_id:positive_integer,
        %cpf:positive_integer,
        nome:string,
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
        senha:atom
    ).


:-initialization(at_halt(db_sync(gc(always)))).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Usuario_id, Nome, Email, Senha):-
    chave:pk(usuario, Usuario_id),
    with_mutex(usuario, (crypto_password_hash(Senha, Hash),
    assert_usuario(Usuario_id, Nome, Email, Hash))).


remove(Usuario_id):-
    with_mutex(
        usuario,
        retractall_usuario(Usuario_id, _Nome, _Email, _Senha)
    ).


atualiza(Usuario_id, Nome, Email, Senha):-
    with_mutex(
        usuario,
        (
            retractall_usuario(Usuario_id, _NomeAnt, _EmailAnt, _SenhaAnt),
            assert_usuario(Usuario_id, Nome, Email, Senha)
        )
    ).