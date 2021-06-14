:- module(
    chaveAnamnese,
    [ carrega_tab/1,
      pkAnamnese/2,
      inicia_pk_Anamnese/2 ]
).

:- use_module(library(persistency)).

:- persistent
chaveAnamnese( nome:atom,
               valor:positive_integer ).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
 db_attach(ArqTabela, []).


pkAnamnese(Nome, Valor):- !,
 atom_concat(pkAnamnese, Nome, Mutex),
 with_mutex(Mutex,
            (
                ( chaveAnamnese(Nome, ValorAtual) ->
                  ValorAntigo = ValorAtual;
                  ValorAntigo = 0 ),
                Valor is ValorAntigo + 1,
                retractall_chaveAnamnese(Nome,_), % remove o valor antigo
                assert_chaveAnamnese(Nome, Valor)) ). % atualiza com o novo


% Talvez você queira um valor inicial diferente de 1

inicia_pk_Anamnese(Nome, ValorInicial):- !,
 atom_concat(pkAnamnese, Nome, Mutex),
 with_mutex(Mutex,
            ( chaveAnamnese(Nome, _) ->
              true; % Não inicializa caso a chave já exista
              assert_chaveAnamnese(Nome, ValorInicial) ) ).
