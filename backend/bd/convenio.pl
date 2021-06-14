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


:- use_module(chave_conv, []).


:- persistent
    convenio(
        id_conv:positive_integer, % chave primária
        codCovenio:string,
        razaoSocial:string
    ).  


:- initialization( 
    at_halt(db_sync(gc(always)))    
    ).


carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Id_conv, CodCovenio, RazaoSocial):-
    chave_conv:pk_conv(convenio, Id_conv),
    with_mutex(
        convenio,
        assert_convenio(Id_conv, CodCovenio, RazaoSocial)
    ).


remove(Id_conv):-
    with_mutex(
        convenio,
        retractall_convenio(Id_conv, _CodCovenio, _RazaoSocial)
    ).


atualiza(Id_conv, CodCovenio, RazaoSocial):-
    with_mutex(
        convenio,
        (
            retract_convenio(Id_conv, _CodCovenioAnt,_RazaoSocialAnt),
            assert_convenio(Id_conv, CodCovenio, RazaoSocial)
        )
    ).