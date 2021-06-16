:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


convenio(Pedido) :-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [title('Cadastro - Convenio')],
        [div(class(container),
            [   \html_requires(css('custom.css')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Novo Convenio'),
                \form_convenio(RotaDeRetorno),
                p(''),
                \retornar
            ])
        ]
    ).


form_convenio(RotaDeRetorno)-->
    html(form(
            [
                id('convenio-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
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


editar_convenio(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Convenio_id),
    ( convenio:convenio(Convenio_id, CodConvenio, RazaoSocial)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Novo Convenio')],
        [ div(class(container),
              [ \html_requires(js('comum.js')),
                \html_requires(css('custom.css')),
                h1(class("my-5 text-center pforms"),
                    'Convenios'),
                \form_edicao_convenio(Convenio_id, CodConvenio, RazaoSocial, RotaDeRetorno)
              ]) ])
    ; throw(http_reply(not_found(Convenio_id)))
    ).


form_edicao_convenio(Convenio_id, CodConvenio, RazaoSocial, RotaDeRetorno) -->
    html(form([ id('convenio-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/convenios/~w' - Convenio_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(convenio_id, 'Id', text, Convenio_id),
                p(''),
                \campo(codConvenio, 'Codigo do Convenio: ', text, CodConvenio),
                p(''),
                \campo(razaoSocial, 'Razao Social: ', text, RazaoSocial),
                p(''),
                \enviar
              ])).


