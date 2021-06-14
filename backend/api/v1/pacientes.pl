:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).


:- use_module(bd(paciente), []).


pacientes(get, '', _Pedido):- !,
    envia_tabela_paciente.


pacientes(get, AtomId, _Pedido):-
    atom_number(AtomId, Id_pac),
    !,
    envia_tupla_paciente(Id_pac).


pacientes(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_paciente(Dados).


pacientes(put, AtomId, Pedido):-
    atom_number(AtomId, Id_pac),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_paciente(Dados, Id_pac).


pacientes(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id_pac),
    !,
    paciente:remove(Id_pac).


pacientes(Metodo, Id_pac, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id_pac))).


insere_tupla_paciente(_{loginP:LoginP, codConvenio:CodConvenio}):-
    paciente:insere(Id_pac, LoginP, CodConvenio)
    -> envia_tupla_paciente(Id_pac)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla(_{loginP:LoginP, codConvenio:CodConvenio}, Id_pac):-
       paciente:atualiza(Id_pac, LoginP, CodConvenio)
    -> envia_tupla_paciente(Id_pac)
    ;  throw(http_reply(not_found(Id_pac))).


envia_tupla_paciente(Id_pac):-
       paciente:paciente(Id_pac, LoginP, CodConvenio)
    -> reply_json_dict( _{id_pac:Id_pac, loginP:LoginP, codConvenio:CodConvenio} )
    ;  throw(http_reply(not_found(Id_pac))).


envia_tabela_paciente :-
    findall( _{id_pac:Id_pac, loginP:LoginP, codConvenio:CodConvenio},
             paciente:paciente(Id_pac, LoginP, CodConvenio),
             Tuplas ),
    reply_json_dict(Tuplas).
