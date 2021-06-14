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
                \html_requires(js('pacientes.js')),
                h2('Cadastro de Novo Paciente'),
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
    atom_number(AtomId, Id_pac),
    ( paciente:paciente(Id_pac, LoginP, CodConvenio)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Novo Paciente')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('pacientes.js')),
                h1('Pacientes'),
                \form_paciente(Id_pac, LoginP, CodConvenio)
              ]) ])
    ; throw(http_reply(not_found(Id_pac)))
    ).


form_paciente(Id_pac, LoginP, CodConvenio) -->
    html(form([ id('paciente-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/pacientes/~w' - Id_pac) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(id_pac, 'Id_pac', text, Id_pac),
                \campo(loginP, 'Login do Paciente: ', text, LoginP),
                p(''),
                \campo(codConvenio, 'Codigo do Convenio: ', text, CodConvenio),
                p(''),
                \enviar
              ])).