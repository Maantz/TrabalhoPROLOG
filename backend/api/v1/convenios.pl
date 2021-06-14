:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).


:- use_module(bd(convenio), []).


convenios(get, '', _Pedido):- !,
    envia_tabela_convenio.


convenios(get, AtomId, _Pedido):-
    atom_number(AtomId, Id_conv),
    !,
    envia_tupla_paciente(Id_conv).


convenios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_convenio(Dados).


convenios(put, AtomId, Pedido):-
    atom_number(AtomId, Id_conv),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_paciente(Dados, Id_conv).


convenios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id_conv),
    !,
    convenio:remove(Id_conv),
    throw(http_reply(no_content)).


convenios(Metodo, Id_conv, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id_conv))).


insere_tupla_convenio( _{codConvenio:CodConvenio, razaoSocial:RazaoSocial} ):-
    convenio:insere(Id_conv, CodConvenio, RazaoSocial)
    -> envia_tupla_convenio(Id_conv)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla_convenio( _{codConvenio:CodConvenio, razaoSocial:RazaoSocial}, Id_conv ):-
       convenio:atualiza(Id_conv, CodConvenio, RazaoSocial)
    -> envia_tupla_convenio(Id_conv)
    ;  throw(http_reply(not_found(Id_conv))).


envia_tupla_convenio(Id_conv):-
       convenio:convenio(Id_conv, CodConvenio, RazaoSocial)
    -> reply_json_dict( _{id_conv:Id_conv, codConvenio:CodConvenio, razaoSocial:RazaoSocial} )
    ;  throw(http_reply(not_found(Id_conv))).


envia_tabela_convenio :-
    findall( _{id_conv:Id_conv, codConvenio:CodConvenio, razaoSocial:RazaoSocial},
             convenio:convenio(Id_conv, CodConvenio,RazaoSocial),
             Tuplas ),
    reply_json_dict(Tuplas).
