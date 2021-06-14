:- module(
       chaveSchedule,
       [ carrega_tab/1,
         pkSchedule/2,
         inicia_pk_Schedule/2 ]
   ).

:- use_module(library(persistency)).

:- persistent
   chaveSchedule( nome:atom,
                  valor:positive_integer ).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


pkSchedule(Nome, Valor):- !,
    atom_concat(pk, Nome, Mutex),
    with_mutex(Mutex,
               (
                   ( chaveSchedule(Nome, ValorAtual) ->
                     ValorAntigo = ValorAtual;
                     ValorAntigo = 0 ),
                   Valor is ValorAntigo + 1,
                   retractall_chaveSchedule(Nome,_), % remove o valor antigo
                   assert_chaveSchedule(Nome, Valor)) ). % atualiza com o novo


% Talvez você queira um valor inicial diferente de 1

inicia_pk_Schedule(Nome, ValorInicial):- !,
    atom_concat(pkSchedule, Nome, Mutex),
    with_mutex(Mutex,
               ( chaveSchedule(Nome, _) ->
                 true; % Não inicializa caso a chave já exista
                 assert_chaveSchedule(Nome, ValorInicial) ) ).
