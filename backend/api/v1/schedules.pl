/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(schedule), []).

/*
   GET api/v1/bookmarks/
   Retorna uma lista com todos os bookmarks.
*/

schedules(get, '', _Pedido):- !,
    envia_tabela_Schedule.

/*
   GET api/v1/bookmarks/Id
   Retorna o `bookmark` com Id 1 ou erro 404 caso o `bookmark` não
   seja encontrado.
*/

schedules(get, AtomId, _Pedido):-
    atom_number(AtomId, IdSchedule),
    !,
    envia_tupla_Schedule(IdSchedule).

/*
   POST api/v1/bookmarks
   Adiciona um novo bookmark. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
schedules(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_Schedule(Dados).

/*
  PUT api/v1/bookmarks/Id
  Atualiza o bookmark com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/

schedules(put, AtomId, Pedido):-
    atom_number(AtomId, IdSchedule),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_Schedule(Dados, IdSchedule).

/*
   DELETE api/v1/bookmarks/Id
   Apaga o bookmark com o Id informado
*/

schedules(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdSchedule),
    !,
    schedule:removeSchedule(IdSchedule),
    throw(http_reply(no_content)).
*/
/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

schedules(Metodo, IdSchedule, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdSchedule))).


insere_tupla_Schedule( _{ date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone }):-
    % Validar URL antes de inserir
    schedule:insereSchedule(IdSchedule, Date, Datetime, Reason, Notes, Phone)
    -> envia_tupla_Schedule(IdSchedule).

atualiza_tupla_Schedule( _{ date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone }, IdSchedule):-
       schedule:atualizaSchedule(IdSchedule, Date, Datetime, Reason, Notes, Phone)
    -> envia_tupla_Schedule(IdSchedule)
    ;  throw(http_reply(not_found(IdSchedule))).


envia_tupla_Schedule(IdSchedule):-
       schedule:schedule(IdSchedule, Date, Datetime, Reason, Notes, Phone)
    -> reply_json_dict( _{idSchedule:IdSchedule, date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone})
    ;  throw(http_reply(not_found(IdSchedule))).


envia_tabela_Schedule :-
    findall( _{idSchedule:IdSchedule, date:Date, datetime:Datetime,reason:Reason,notes:Notes,phone:Phone},
             schedule:schedule(IdSchedule,Date, Datetime, Reason, Notes, Phone),
             Tuplas ),
    reply_json_dict(Tuplas).
