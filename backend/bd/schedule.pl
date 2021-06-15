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


insere(IdSchedule,Date,DateTime,Reason,Notes,Phone):-
    chave:pk(schedule,IdSchedule),
    with_mutex(schedule,
                 assert_schedule(IdSchedule,Date,DateTime,Reason,Notes,Phone)).

remove(IdSchedule):-
    with_mutex(schedule,
                retractall_schedule(IdSchedule,_Date,_DateTime,_Reason,_Notes,_Phone)).

atualiza(IdSchedule,Date,DateTime,Reason,Notes,Phone):-
    with_mutex(schedule,
                ( retract_schedule(IdSchedule,_DateAnti,_DateTimeAnti,_ReasonAnti,_NotesAnti,_PhoneAnti),
                  assert_schedule(IdSchedule,Date,DateTime,Reason,Notes,Phone))).