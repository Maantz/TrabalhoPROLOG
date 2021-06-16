:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


paciente(Pedido) :-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [title('Cadastro - Paciente')],
        [div(class(container),
            [   \html_requires(css('custom.css')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Novo Paciente'),
                \form_paciente(RotaDeRetorno),
                p(''),
                \retornar
            ])
        ]
    ).


form_paciente(RotaDeRetorno)-->
    html(form(
            [
                id('paciente-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/pacientes/')
            ],
            [
                \metodo_de_envio('POST'),
                \campo(loginP, 'Login do Paciente: ', text),
                p(''),
                \campo(codConvenio, 'Codigo do Convenio: ', text),
                p(''),
                \enviar
            ]
            )
        ).


editar_paciente(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Paciente_id),
    ( paciente:paciente(Paciente_id, LoginP, CodConvenio)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Novo Paciente')],
        [ div(class(container),
              [ \html_requires(js('comum.js')),
                h1('Pacientes'),
                \form_edicao_paciente(Paciente_id, LoginP, CodConvenio, RotaDeRetorno),
                p(''),
                \retornar
              ]) ])
    ; throw(http_reply(not_found(Paciente_id)))
    ).


form_edicao_paciente(Paciente_id, LoginP, CodConvenio, RotaDeRetorno) -->
    html(form([ id('paciente-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/pacientes/~w' - Paciente_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(paciente_id, 'Id', text, Paciente_id),
                p(''),
                \campo(loginP, 'Login do Paciente: ', text, LoginP),
                p(''),
                \campo(codConvenio, 'Codigo do Convenio: ', text, CodConvenio),
                p(''),
                \enviar
              ])).