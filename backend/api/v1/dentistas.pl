:- module(
       dentistas,
       [
           dentistas/3
       ]
   ).

:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(dentista), []).



%dentistas(get, '', _Pedido):- !,
    %envia_tabela.

/*
   GET api/v1/usuarios/Id
   Retorna o usuário com Id 1 ou erro 404 caso o usuário não
   seja encontrado.
*/
dentistas(get, AtomId, _Pedido):-
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

dentistas(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/usuarios/Id
  Atualiza o usuário com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
%dentistas(put, AtomId, Pedido):-
    %atom_number(AtomId, Id),
    %http_read_json_dict(Pedido, Dados),
    %!,
    %atualiza_tupla(Dados, Id).
/*
   DELETE api/v1/usuarios/Id
   Apaga o bookmark com o Id informado
*/
%dentistas(delete, AtomId, _Pedido):-
    %atom_number(AtomId, Usuario_ID),
    %!,
    %usuario:remove(Usuário_ID),
    %throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

dentistas(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ cro:CRO, login:Login, senha:Senha }):-
    ( dentista:insere(Dentista_ID, CRO, Login, Senha)
      %atom_string(Função, StrFun),
      %função:função(Função_ID, Função, _, _),
      %usuário_função:insere(_, Usuário_ID, Função_ID)
    )
    -> envia_tupla(Dentista_ID)
    ;  throw(http_reply(bad_request('Dentista já cadastrado'))).

%atualiza_tupla( _{ nome:Nome, email:Email, senha:Senha}, Usuario_ID):-
    %( %atom_string(Função, StrFun),
      %função:função(Função_ID, Função, _, _),
      %usuário_função:usuário_função(UF_ID, Usuário_ID, _, _, _),
      %usuário:atualiza(Usuário_ID, Nome, Email),
      %usuário:atualiza_senha(Usuário_ID, Senha),
      %usuário_função:atualiza(UF_ID, Usuário_ID, Função_ID)%
    %)
    %-> envia_tupla(Usuário_ID)
    %;  throw(http_reply(not_found(Usuário_ID))).

envia_tupla(Id):-
    dentista:dentista(Id, CRO, Login, Senha)
    -> reply_json_dict( _{ id:Id, cro:CRO, login:Login, senha:Senha} )
    ;  throw(http_reply(not_found(Id))).


%envia_tabela :-
    %findall( _{ id:Id, nome:Nome, email:Email,
                %data_cad: Data_Cad, data_mod: Data_Mod },
             %usuário:usuário(Id, Nome, Email, _Senha, Data_Cad, Data_Mod),
            %Tuplas ),
    %reply_json_dict(Tuplas).