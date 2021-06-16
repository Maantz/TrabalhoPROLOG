:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(paciente), []).


pacientes(get, '', _Pedido):- !,
    envia_tabela_paciente.


pacientes(get, AtomId, _Pedido):-
    atom_number(AtomId, Paciente_id),
    !,
    envia_tupla_paciente(Paciente_id).


pacientes(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_paciente(Dados).


pacientes(put, AtomId, Pedido):-
    atom_number(AtomId, Paciente_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_paciente(Dados, Paciente_id).


pacientes(delete, AtomId, _Pedido):-
    atom_number(AtomId, Paciente_id),
    !,
    paciente:remove(Paciente_id),
    throw(http_reply(no_content)).


pacientes(Metodo, Paciente_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Paciente_id))).


insere_tupla_paciente( _{loginP:LoginP, codConvenio:CodConvenio} ):-
    paciente:insere(Paciente_ID, LoginP, CodConvenio)
    -> envia_tupla_paciente(Paciente_ID)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla_paciente( _{loginP:LoginP, codConvenio:CodConvenio}, _Paciente_id ):-
       paciente:atualiza(Paciente_ID, LoginP, CodConvenio)
    -> envia_tupla_paciente(Paciente_ID)
    ;  throw(http_reply(not_found(_Paciente_ID))).


envia_tupla_paciente(Paciente_id):-
       paciente:paciente(Paciente_id, LoginP, CodConvenio)
    -> reply_json_dict( _{paciente_id:Paciente_id, loginP:LoginP, codConvenio:CodConvenio} )
    ;  throw(http_reply(not_found(Paciente_id))).


envia_tabela_paciente :-
    findall( _{paciente_id:Paciente_id, loginP:LoginP, codConvenio:CodConvenio},
             paciente:paciente(Paciente_id, LoginP, CodConvenio),
             Tuplas ),
    reply_json_dict(Tuplas).
