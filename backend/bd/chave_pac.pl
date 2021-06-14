:- module(
       chave_pac,
       [ carrega_tab/1,
         pk_pac/2,
         inicia_pk_pac/2 ]
   ).

:- use_module(library(persistency)).

:- persistent
   chave_pac( nome:atom,
          valor:positive_integer ).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


pk_pac(Nome, Valor):- !,
    atom_concat(pk_pac, Nome, Mutex),
    with_mutex(Mutex,
               (
                  (
                    chave_pac(Nome, ValorAtual) ->
                    ValorAntigo = ValorAtual;
                    ValorAntigo = 0 ),
                  Valor is ValorAntigo + 1,
                  retractall_chave_pac(Nome,_),
                  assert_chave_pac(Nome, Valor)
                )
              ).


inicia_pk_pac(Nome, ValorInicial):- !,
    atom_concat(pk_pac, Nome, Mutex),
    with_mutex(Mutex,
               (
                chave_pac(Nome, _) ->
                  true;
                  assert_chave_pac(Nome, ValorInicial)
                )
              ).
