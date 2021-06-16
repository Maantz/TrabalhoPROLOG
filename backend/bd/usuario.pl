:-module(
    usuario,
    [
        carrega_tab/1,
        usuario/16,
        insere/16,
        remove/1,
        atualiza/16
    ]
).

:-use_module(library(persistency)).
:-use_module(library(crypto)).
:-use_module(chave, []).


:-persistent
    usuario(
        usuario_id:positive_integer,
        cpf:positive_integer,
        nome:string,
        dt_nasc: string,
        estado: string,
        cidade: string,
        bairro: string,
        rua: string,
        numero:positeve_integer,
        cep:positive_integer,
        telefone:positive_integer,
        celular:positive_integer,
        email:string,
        tipo_Usuario:string,
        login:string,
        senha:atom
    ).


:-initialization(at_halt(db_sync(gc(always)))).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Usuario_id, Cpf, Nome, Dt-nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha):-
    chave:pk(usuario, Usuario_id),
    with_mutex(usuario, (crypto_password_hash(Senha, Hash),
    assert_usuario(Usuario_id, Cpf, Nome, Dt-nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Hash))).


remove(Usuario_id):-
    with_mutex(
        usuario,
        retractall_usuario(Usuario_id, _Cpf, _Nome, _Dt-nasc, _Estado, _Cidade, _Bairro, _Rua, _Numero, _Cep, 
        _Telefone, _Celular, _Email, _Tipo_Usuario, _Login,  _Senha)
    ).


atualiza(Usuario_id, Cpf, Nome, Dt-nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha):-
    with_mutex(
        usuario,
        (   
            retractall_usuario(Usuario_id, _Cpf, _Nome, _Dt-nasc, _Estado, _Cidade, _Bairro, _Rua, _Numero, _Cep, 
        _Telefone, _Celular, _Email, _Tipo_Usuario, _Login, _Hash),
            crypto_password_hash(Senha, Hash),
            assert_usuario(Usuario_id, Cpf, Nome, Dt-nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login, Hash)
        )
    ).