:-module(anamnese,[
    carrega_tab/1,
    anamnese/7,
    insereAnamnese/7,
    removeAnamnese/1,
    atualizaAnamnese/7
]).

:-use_module(library(persistency)).

:-use_module(chaveAnamnese, []).

:-persistent
    anamnese(idAnamnese:positive_integer,
             medicamento:string,
             tiposangue:string,
             doenca:string,
             alergia:string,
             fumante:string,
             gestante:string). 

:-initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insereAnamnese(IdAnamnese,Medicamento,TipoSangue, Doenca, Alergia, Fumante, Gestante):-
    chaveAnamnese:pkAnamnese(anamnese, IdAnamnese),
    with_mutex(anamnese,
         assert_anamnese(IdAnamnese,Medicamento,TipoSangue, Doenca, Alergia, Fumante, Gestante)).

removeAnamnese(IdAnamnese):-
    with_mutex(anamnese,
        retractall_anamnese(IdAnamnese,_Medicamento,_TipoSangue, _Doenca,_Alergia,_Fumante,_Gestante)).


atualizaAnamnese(IdAnamnese,Medicamento,TipoSangue, Doenca, Alergia, Fumante, Gestante):-
    with_mutex(anamnese,
        retract_anamnese(IdAnamnese,_MediAnti,_TipoSAnti, _DoencaAnti, _AlergiaAnti, _FumanteAnti, _GestanteAnti),
        assert_anamnese(IdAnamnese,Medicamento,TipoSangue, Doenca, Alergia, Fumante, Gestante)).