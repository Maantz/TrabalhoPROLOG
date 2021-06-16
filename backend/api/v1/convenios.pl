:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(convenio), []).


convenios(get, '', _Pedido):- !,
    envia_tabela_convenio.


convenios(get, AtomId, _Pedido):-
    atom_number(AtomId, Convenio_Id),
    !,
    envia_tupla_paciente(Convenio_Id).


convenios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_convenio(Dados).


convenios(put, AtomId, Pedido):-
    atom_number(AtomId, Convenio_Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_paciente(Dados, Convenio_Id).


convenios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Convenio_Id),
    !,
    convenio:remove(Convenio_Id),
    throw(http_reply(no_content)).


convenios(Metodo, Convenio_Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Convenio_Id))).


insere_tupla_convenio( _{codConvenio:CodConvenio, razaoSocial:RazaoSocial} ):-
    convenio:insere(Convenio_Id, CodConvenio, RazaoSocial)
    -> envia_tupla_convenio(Convenio_Id)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla_convenio( _{codConvenio:CodConvenio, razaoSocial:RazaoSocial}, Convenio_Id ):-
       convenio:atualiza(Convenio_Id, CodConvenio, RazaoSocial)
    -> envia_tupla_convenio(Convenio_Id)
    ;  throw(http_reply(not_found(Convenio_Id))).


envia_tupla_convenio(Convenio_Id):-
       convenio:convenio(Convenio_Id, CodConvenio, RazaoSocial)
    -> reply_json_dict( _{convenio_id:Convenio_Id, codConvenio:CodConvenio, razaoSocial:RazaoSocial} )
    ;  throw(http_reply(not_found(Convenio_Id))).


envia_tabela_convenio :-
    findall( _{convenio_id:Convenio_Id, codConvenio:CodConvenio, razaoSocial:RazaoSocial},
             convenio:convenio(Convenio_Id, CodConvenio,RazaoSocial),
             Tuplas ),
    reply_json_dict(Tuplas).
