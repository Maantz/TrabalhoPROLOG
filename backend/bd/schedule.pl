:-module(
    schedule,[
    carrega_tab/1,
    schedule/6,
    insere/6,
    remove/1,
    atualiza/6
]).


:-use_module(library(persistency)).
:-use_module(chave, []).


:-persistent
    schedule(schedule_id:positive_integer,%primary_key
             date:string,
             datetime:string,
             reason:string,
             notes:string,
             phone:string
    ).


:-initialization( 
    at_halt(db_sync(gc(always)))
    ).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Schedule_id,Date,DateTime,Reason,Notes,Phone):-
    chave:pk(schedule,Schedule_id),
    with_mutex(schedule,
                 assert_schedule(Schedule_id,Date,DateTime,Reason,Notes,Phone)).

remove(Schedule_id):-
    with_mutex(schedule,
                retractall_schedule(Schedule_id,_Date,_DateTime,_Reason,_Notes,_Phone)).

atualiza(Schedule_id,Date,DateTime,Reason,Notes,Phone):-
    with_mutex(schedule,
                ( retract_schedule(Schedule_id,_DateAnt,_DateTimeAnt,_ReasonAnt,_NotesAnt,_PhoneAnt),
                  assert_schedule(Schedule_id,Date,DateTime,Reason,Notes,Phone))).