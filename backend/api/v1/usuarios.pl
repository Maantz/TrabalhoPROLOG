:- module(
       usuarios,
       [
           usuarios/3
       ]
   ).

:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(usuario), []).



usuarios(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/usuarios/Id
   Retorna o usuário com Id 1 ou erro 404 caso o usuário não
   seja encontrado.
*/
usuarios(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/usuarios
   Adiciona um novo usuário. Os dados deverão ser passados no corpo da
   requisição no formato JSON. Por default, o usuário possui a funçao
   estudante

   Um erro 400 (BAD REQUEST) deve ser retornado caso algo dê errado
*/

usuarios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/usuarios/Id
  Atualiza o usuário com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
usuarios(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).
/*
   DELETE api/v1/usuarios/Id
   Apaga o bookmark com o Id informado
*/
usuarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Usuario_ID),
    !,
    usuario:remove(Usuario_ID),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

usuarios(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ nome:Nome, email:Email, senha:Senha }):-
    ( usuario:insere(Usuario_ID, Nome, Email, Senha)
      %atom_string(Função, StrFun),
      %função:função(Função_ID, Função, _, _),
      %usuário_função:insere(_, Usuário_ID, Função_ID)
    )
    -> envia_tupla(Usuario_ID)
    ;  throw(http_reply(bad_request('Email ja cadastrado'))).

atualiza_tupla( _{ nome:Nome, email:Email, senha:Senha}, Usuario_ID):-
    ( %atom_string(Função, StrFun),
      %função:função(Função_ID, Função, _, _),
      %usuário_função:usuário_função(UF_ID, Usuário_ID, _, _, _),
      usuario:atualiza(Usuario_ID, Nome, Email, Senha)
      %usuario:atualiza_senha(Usuário_ID, Senha),
      %usuario_função:atualiza(UF_ID, Usuário_ID, Função_ID)
    )
    -> envia_tupla(Usuario_ID)
    ;  throw(http_reply(not_found(Usuario_ID))).

envia_tupla(Id):-
    usuario:usuario(Id, Nome, Email, Senha)
    -> reply_json_dict( _{ id:Id, nome:Nome, email:Email, senha:Senha} )
    ;  throw(http_reply(not_found(Id))).


envia_tabela :-
    findall( _{ id:Id, nome:Nome, email:Email},
             usuario:usuario(Id, Nome, Email, _Senha),
            Tuplas),
    reply_json_dict(Tuplas).