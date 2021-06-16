:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(convenio), []).


convenios(get, '', _Pedido):- !,
    envia_tabela_convenio.


convenios(get, AtomId, _Pedido):-
    atom_number(AtomId, Convenio_id),
    !,
    envia_tupla_convenio(Convenio_id).


convenios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_convenio(Dados).


convenios(put, AtomId, Pedido):-
    atom_number(AtomId, Convenio_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_convenio(Dados, Convenio_id).


convenios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Convenio_id),
    !,
    convenio:remove(Convenio_id),
    throw(http_reply(no_content)).


convenios(Metodo, Convenio_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Convenio_id))).


insere_tupla_convenio( _{codConvenio:CodConvenio, razaoSocial:RazaoSocial} ):-
    convenio:insere(Convenio_id, CodConvenio, RazaoSocial)
    -> envia_tupla_convenio(Convenio_id)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla_convenio( _{codConvenio:CodConvenio, razaoSocial:RazaoSocial}, Convenio_id ):-
       convenio:atualiza(Convenio_id, CodConvenio, RazaoSocial)
    -> envia_tupla_convenio(Convenio_id)
    ;  throw(http_reply(not_found(Convenio_id))).


envia_tupla_convenio(Convenio_id):-
       convenio:convenio(Convenio_id, CodConvenio, RazaoSocial)
    -> reply_json_dict( _{convenio_id:Convenio_id, codConvenio:CodConvenio, razaoSocial:RazaoSocial} )
    ;  throw(http_reply(not_found(Convenio_id))).


envia_tabela_convenio :-
    findall( _{convenio_id:Convenio_id, codConvenio:CodConvenio, razaoSocial:RazaoSocial},
             convenio:convenio(Convenio_id, CodConvenio, RazaoSocial),
             Tuplas ),
    reply_json_dict(Tuplas).
