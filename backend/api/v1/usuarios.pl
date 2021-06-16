:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(usuario), []).



usuarios(get, '', _Pedido):- !,
    envia_tabela_usuario.


usuarios(get, AtomId, _Pedido):-
    atom_number(AtomId, Usuario_id),
    !,
    envia_tupla_usuario(Usuario_id).


usuarios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_usuario(Dados).


usuarios(put, AtomId, Pedido):-
    atom_number(AtomId, Usuario_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_usuario(Dados, Usuario_id).


usuarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Usuario_id),
    !,
    usuario:remove(Usuario_id),
    throw(http_reply(no_content)).


usuarios(Metodo, Usuario_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Usuario_id))).


insere_tupla_usuario( _{nome:Nome, email:Email, senha:Senha} ):-
    usuario:insere(Usuario_ID, Nome, Email, Senha)
    -> envia_tupla_usuario(Usuario_ID)
    ;  throw(http_reply(bad_request('Email ja cadastrado'))).


atualiza_tupla_usuario( _{nome:Nome, email:Email, senha:Senha}, Usuario_id ):-
    usuario:atualiza(Usuario_id, Nome, Email, Senha)
    -> envia_tupla_usuario(Usuario_id)
    ;  throw(http_reply(not_found(Usuario_id))).


envia_tupla_usuario(Usuario_id):-
    usuario:usuario(Usuario_id, Nome, Email, Senha)
    -> reply_json_dict( _{ usuario:id:Usuario_id, nome:Nome, email:Email, senha:Senha} )
    ;  throw(http_reply(not_found(Usuario_id))).


envia_tabela_usuario :-
    findall( _{ usuario:id:Usuario_id, nome:Nome, email:Email},
             usuario:usuario(Usuario_id, Nome, Email, _Senha),
            Tuplas),
    reply_json_dict(Tuplas).