:-module(
        dentista,
        [
           dentista/2,
           insere/2,
           remove/1,
           atualiza/2
        ]
    ).


:-use_module(library(persistency)).
:-use_module(chave, []).


:-persistent
    dentista(
        dentista_id:positive_integer,
        cro:string
    ).


:-initialization(at_halt(db_sync(gc(always)))).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Dentista_id, CRO):-
    chave:pk(usuario, Dentista_id),
    with_mutex(dentista,
                assert_dentista(Dentista_id, CRO)
    ).


remove(Dentista_id):-
    with_mutex(
        dentista,
        retractall_dentista(Dentista_id, _CRO)
    ).


atualiza(Dentista_id, CRO):-
    with_mutex(
        dentista,
        (
            retract_dentista(Dentista_id, _CROAnt),
            assert_dentista(Dentista_id, CRO)
        )
    ).




