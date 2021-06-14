:-module(
    schedule,[
    carrega_tab/1,
    schedule/6,
    insereSchedule/6,
    removeSchedule/1,
    atualizaSchedule/6
]).

:-use_module(library(persistency)).

:-use_module(chaveSchedule, []).

:-persistent
    schedule(idSchedule:positive_integer,%primary_key
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

insereSchedule(IdSchedule,Date,DateTime,Reason,Notes,Phone):-
    chaveSchedule:pkSchedule(schedule,IdSchedule),
    with_mutex(schedule,
                 assert_schedule(IdSchedule,Date,DateTime,Reason,Notes,Phone)).

removeSchedule(IdSchedule):-
    with_mutex(schedule,
                retractall_schedule(IdSchedule,_Date,_DateTime,_Reason,_Notes,_Phone)).

atualizaSchedule(IdSchedule,Date,DateTime,Reason,Notes,Phone):-
    with_mutex(schedule,
                ( retract_schedule(IdSchedule,_DateAnti,_DateTimeAnti,_ReasonAnti,_NotesAnti,_PhoneAnti),
                  assert_schedule(IdSchedule,Date,DateTime,Reason,Notes,Phone))).