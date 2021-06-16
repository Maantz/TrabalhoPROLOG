:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


convenio(_Pedido) :-
    reply_html_page(
        boot5rest,
        [title('Cadastro - Convenio')],
        [div(class(container),
            [
                \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center"),
                    'Cadastro de Novo Convenio'),
                \form_convenio,
                p(''),
                \retornar
            ])
        ]
    ).


form_convenio -->
    html(form(
            [
                id('convenio-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/convenios/')
            ],
            [
                \metodo_de_envio('POST'),
                \campo(codConvenio, 'Codigo do Convenio: ', text),
                p(''),
                \campo(razaoSocial, 'Razao Social: ', text),
                p(''),
                \enviar
            ]
            )
        ).


editar_convenio(AtomId, _Pedido):-
    atom_number(AtomId, Convenio_id),
    ( convenio:convenio(Convenio_id, CodConvenio, RazaoSocial)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Novo Convenio')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('comum.js')),
                h1('Convenios'),
                \form_convenio(Convenio_id, CodConvenio, RazaoSocial)
              ]) ])
    ; throw(http_reply(not_found(Convenio_id)))
    ).


form_convenio(Convenio_id, CodConvenio, RazaoSocial) -->
    html(form([ id('convenio-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/convenios/~w' - Convenio_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(convenio_id, 'Convenio_id', text, Convenio_id),
                \campo(codConvenio, 'Codigo do Convenio: ', text, CodConvenio),
                p(''),
                \campo(razaoSocial, 'Razao Social: ', text, RazaoSocial),
                p(''),
                \enviar
              ])).


