:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).


:-ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


dentista(_Pedido):-
    reply_html_page(
        boot5rest,
        [title('Clinica Odontologica')],
        [div(class(container),
            [   \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center"),
                    'Cadastro de Novo Dentista'),
            \form_dentista,
            p(''),
            \retornar])]
    ).


form_dentista -->
    html(form([id('dentista-form'),
                onsubmit("redirecionaResposta(event, '/' )"),
                action('/api/v1/dentistas/')],
                [   \metodo_de_envio('POST'),
                    \campo(cro, 'CRO', text),
                    p(''),
                    \enviar
                ])

    ).



editar_dentista(AtomId, _Pedido):-
    atom_number(AtomId, Dentista_id),
    ( dentista:dentista(Dentista_id, CRO)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Dentista')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                h1('Dentistas'),
                \form_dentista(Dentista_id, CRO)
              ]) ])
    ; throw(http_reply(not_found(Dentista_id)))
    ).


form_dentista(Dentista_id, CRO) -->
    html(form([ id('dentista-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/dentistas/~w' - Dentista_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(dentista_id, 'Dentista_id', text, Dentista_id),
                \campo(CRO, 'CRO: ', text, CRO),
                p(''),
                \enviar
              ])).