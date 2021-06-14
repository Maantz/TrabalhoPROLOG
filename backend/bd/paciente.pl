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


:- use_module(chave_pac, []).


:- persistent
    paciente(
        id_pac:positive_integer, % chave primária
        loginP:string,
        codConvenio:string
    ).  


:- initialization(
    at_halt(db_sync(gc(always)))
    ).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Id_pac, LoginP, CodConvenio):-
    chave_pac:pk_pac(paciente, Id_pac),
    with_mutex(
        paciente,
        assert_paciente(Id_pac, LoginP, CodConvenio)
    ).

remove(Id_pac):-
    with_mutex(
        paciente,
        retractall_paciente(Id_pac, _LoginP, _CodConvenio)
    ).


atualiza(Id_pac, LoginP, CodConvenio):-
    with_mutex(
        paciente,
        (
            retract_paciente(Id_pac, _LoginPAnt, _CodConvenioAnt),
            assert_paciente(Id_pac, LoginP, CodConvenio)
        )
    ).