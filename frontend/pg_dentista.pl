:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).


:-ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


dentista(Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [title('Clinica Odontologica')],
        [div(class(container),
            [   \html_requires(css('custom.css')),
                \html_requires(js('rest.js')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Novo Dentista'),
            \form_dentista(RotaDeRetorno),
            p(''),
            \retornar])]
    ).


form_dentista(RotaDeRetorno)-->
    html(form([id('dentista-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/dentistas/')],
                [   \metodo_de_envio('POST'),
                    \campo(cro, 'CRO', text),
                    p(''),
                    \enviar
                ])

    ).


editar_dentista(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Dentista_id),
    ( dentista:dentista(Dentista_id, CRO)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Dentista')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('comum.js')),
                h1('Dentistas'),
                \form_edicao_dentista(Dentista_id, CRO, RotaDeRetorno)
              ]) ])
    ; throw(http_reply(not_found(Dentista_id)))
    ).


form_edicao_dentista(Dentista_id, CRO, RotaDeRetorno) -->
    html(form([ id('dentista-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/dentistas/~w' - Dentista_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(dentista_id, 'Id', text, Dentista_id),
                p(''),
                \campo(cro, 'CRO: ', text, CRO),
                p(''),
                \enviar
              ])).