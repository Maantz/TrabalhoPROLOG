:-module(
    anamnese,
    [
        carrega_tab/1,
        anamnese/7,
        insere/7,
        remove/1,
        atualiza/7
    ]
).


:-use_module(library(persistency)).
:-use_module(chave, []).


:-persistent
    anamnese(anamnese_id:positive_integer,
             medicamento:string,
             tiposangue:string,
             doenca:string,
             alergia:string,
             fumante:string,
             gestante:string).


:- initialization( 
    at_halt(db_sync(gc(always)))    
    ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante):-
    chave:pk(anamnese, Anamnese_id),
    with_mutex(anamnese,
         assert_anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante)).

remove(Anamnese_id):-
    with_mutex(anamnese,
        retractall_anamnese(Anamnese_id, _Medicamento, _TipoSangue, _Doenca, _Alergia, _Fumante, _Gestante)).


atualiza(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante):-
    with_mutex(anamnese,
        retract_anamnese(Anamnese_id, _MediAnt, _TipoSAnt, _DoencaAnt, _AlergiaAnt, _FumanteAnt, _GestanteAnt),
        assert_anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante)).