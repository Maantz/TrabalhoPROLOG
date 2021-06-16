:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(schedule), []).


schedules(get, '', _Pedido):- !,
    envia_tabela_schedule.


schedules(get, AtomId, _Pedido):-
    atom_number(AtomId, Schedule_id),
    !,
    envia_tupla_schedule(Schedule_id).


schedules(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_schedule(Dados).


schedules(put, AtomId, Pedido):-
    atom_number(AtomId, Schedule_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_schedule(Dados, Schedule_id).


schedules(delete, AtomId, _Pedido):-
    atom_number(AtomId, Schedule_id),
    !,
    schedule:remove(Schedule_id),
    throw(http_reply(no_content)).


schedules(Metodo, Schedule_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Schedule_id))).


insere_tupla_schedule( _{ date:Date, datetime:Datetime, reason:Reason, notes:Notes, phone:Phone }):-
    schedule:insere(Schedule_id, Date, Datetime, Reason, Notes, Phone)
    -> envia_tupla_schedule(Schedule_id)
    ;  throw(http_reply(bad_request('URL ausente'))).
    
 
atualiza_tupla_schedule( _{ date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone }, Schedule_id):-
       schedule:atualiza(Schedule_id, Date, Datetime, Reason, Notes, Phone)
    -> envia_tupla_schedule(Schedule_id)
    ;  throw(http_reply(not_found(Schedule_id))).


envia_tupla_schedule(Schedule_id):-
       schedule:schedule(Schedule_id, Date, Datetime, Reason, Notes, Phone)
    -> reply_json_dict( _{schedule_id:Schedule_id, date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone})
    ;  throw(http_reply(not_found(Schedule_id))).


envia_tabela_schedule :-
    findall( _{schedule_id:Schedule_id, date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone},
             schedule:schedule(Schedule_id,Date, Datetime, Reason, Notes, Phone),
             Tuplas ),
    reply_json_dict(Tuplas).

