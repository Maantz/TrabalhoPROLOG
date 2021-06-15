:- module(
    paciente,
    [
        carrega_tab/1,
        paciente/3,
        insere/3,
        remove/1,
        atualiza/3
    ]
).


:- use_module(library(persistency)).
:- use_module(chave, []).


:- persistent
    paciente(
        paciente_id:positive_integer, % chave primária
        loginP:string,
        codConvenio:string
    ).  


:- initialization(
    at_halt(db_sync(gc(always)))
    ).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Paciente_id, LoginP, CodConvenio):-
    chave:pk(paciente, Paciente_id),
    with_mutex(
        paciente,
        assert_paciente(Paciente_id, LoginP, CodConvenio)
    ).


remove(Paciente_id):-
    with_mutex(
        paciente,
        retractall_paciente(Paciente_id, _LoginP, _CodConvenio)
    ).


atualiza(Paciente_id, LoginP, CodConvenio):-
    with_mutex(
        paciente,
        (
            retract_paciente(Paciente_id, _LoginPAnt, _CodConvenioAnt),
            assert_paciente(Paciente_id, LoginP, CodConvenio)
        )
    ).