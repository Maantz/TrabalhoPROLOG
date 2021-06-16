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


insere_tupla_usuario( _{cpf:Cpf, nome:Nome, dt_nasc:Dt_nasc, estado:Estado, cidade:Cidade, bairro:Bairro, rua:Rua,
                         numero:Numero, cep:Cep, telefone:Telefone, celular:Celular, email:Email, tipo_Usuario:Tipo_Usuario,
                         login:Login, senha:Senha} ):-
    usuario:insere(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha)
    -> envia_tupla_usuario(Usuario_id)
    ;  throw(http_reply(bad_request('Usuario ja cadastrado'))).


atualiza_tupla_usuario( _{cpf:Cpf, nome:Nome, dt_nasc:Dt_nasc, estado:Estado, cidade:Cidade, bairro:Bairro, rua:Rua,
                         numero:Numero, cep:Cep, telefone:Telefone, celular:Celular, email:Email, tipo_Usuario:Tipo_Usuario,
                         login:Login, senha:Senha}, Usuario_id ):-
    usuario:atualiza(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login, Senha)
    -> envia_tupla_usuario(Usuario_id)
    ;  throw(http_reply(not_found(Usuario_id))).


envia_tupla_usuario(Usuario_id):-
    usuario:usuario(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login, Senha)
    -> reply_json_dict( _{ usuario_id:Usuario_id, cpf:Cpf, nome:Nome, dt_nasc:Dt_nasc, estado:Estado, cidade:Cidade, bairro:Bairro, rua:Rua,
                         numero:Numero, cep:Cep, telefone:Telefone, celular:Celular, email:Email, tipo_Usuario:Tipo_Usuario,
                         login:Login, senha:Senha} )
    ;  throw(http_reply(not_found(Usuario_id))).


envia_tabela_usuario :-
    findall( _{ usuario_id:Usuario_id, cpf:Cpf, nome:Nome, dt_nasc:Dt_nasc, estado:Estado, cidade:Cidade, bairro:Bairro, rua:Rua,
                         numero:Numero, cep:Cep, telefone:Telefone, celular:Celular, email:Email, tipo_Usuario:Tipo_Usuario,
                         login:Login, senha:Senha},
             usuario:usuario(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha),
            Tuplas),
    reply_json_dict(Tuplas).
