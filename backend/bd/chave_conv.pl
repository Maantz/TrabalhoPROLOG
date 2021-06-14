:- module(
       chave_conv,
       [ carrega_tab/1,
         pk_conv/2,
         inicia_pk_conv/2 ]
   ).

:- use_module(library(persistency)).

:- persistent
   chave_conv( nome:atom,
          valor:positive_integer ).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


pk_conv(Nome, Valor):- !,
    atom_concat(pk_conv, Nome, Mutex),
    with_mutex(Mutex,
               (
                  (
                    chave_conv(Nome, ValorAtual) ->
                    ValorAntigo = ValorAtual;
                    ValorAntigo = 0 ),
                  Valor is ValorAntigo + 1,
                  retractall_chave_conv(Nome,_),
                  assert_chave_conv(Nome, Valor)
                )
              ).


inicia_pk_conv(Nome, ValorInicial):- !,
    atom_concat(pk_conv, Nome, Mutex),
    with_mutex(Mutex,
               (
                chave_conv(Nome, _) ->
                  true;
                  assert_chave_conv(Nome, ValorInicial)
                )
              ).
