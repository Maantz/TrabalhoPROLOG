:- module(
    convenio,
    [
        carrega_tab/1,
        convenio/3,
        insere/3,
        remove/1,
        atualiza/3
    ]
).


:- use_module(library(persistency)).
:- use_module(chave, []).


:- persistent
    convenio(
        convenio_id:positive_integer, % chave primária
        codCovenio:string,
        razaoSocial:string
    ).  


:- initialization( 
    at_halt(db_sync(gc(always)))    
    ).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Convenio_id, CodCovenio, RazaoSocial):-
    chave:pk(convenio, Convenio_id),
    with_mutex(
        convenio,
        assert_convenio(Convenio_id, CodCovenio, RazaoSocial)
    ).


remove(Convenio_id):-
    with_mutex(
        convenio,
        retractall_convenio(Convenio_id, _CodCovenio, _RazaoSocial)
    ).


atualiza(Convenio_id, CodCovenio, RazaoSocial):-
    with_mutex(
        convenio,
        (
            retract_convenio(Convenio_id, _CodCovenioAnt,_RazaoSocialAnt),
            assert_convenio(Convenio_id, CodCovenio, RazaoSocial)
        )
    ).