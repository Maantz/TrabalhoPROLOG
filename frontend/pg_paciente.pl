:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


paciente(_Pedido) :-
    reply_html_page(
        boot5rest,
        [title('Cadastro - Paciente')],
        [div(class(container),
            [
                \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center"),
                    'Cadastro de Novo Paciente'),
                \form_paciente,
                p(''),
                \retornar
            ])
        ]
    ).


form_paciente -->
    html(form(
            [
                id('paciente-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
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


editar_paciente(AtomId, _Pedido):-
    atom_number(AtomId, Paciente_id),
    ( paciente:paciente(Paciente_id, LoginP, CodConvenio)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Novo Paciente')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                h1('Pacientes'),
                \form_paciente(Paciente_id, LoginP, CodConvenio)
              ]) ])
    ; throw(http_reply(not_found(Paciente_id)))
    ).


form_paciente(Paciente_id, LoginP, CodConvenio) -->
    html(form([ id('paciente-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/pacientes/~w' - Paciente_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(paciente_id, 'Paciente_id', text, Paciente_id),
                \campo(loginP, 'Login do Paciente: ', text, LoginP),
                p(''),
                \campo(codConvenio, 'Codigo do Convenio: ', text, CodConvenio),
                p(''),
                \enviar
              ])).