:- use_module(library(http/thread_httpd)).
:- use_module(library(http/html_head)).
:- use_module(library(http/html_write)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).
 
 
anamnese(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Receitas - Paciente')],
        [div(class(container),
            [ 
                \html_requires(js('rest.js')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center"),
                    'Cadastro de Nova Anamnese'),
                \form_anamnese,
                p(''),
                \retornar
            ])
        ]
    ).


form_anamnese -->
    html(form(
            [
                id('anamnese-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/anamneses/')
            ],
            [
                \metodo_de_envio('POST'),
                \campo(medicamento, 'Medicamento: ', text),
                \campo(tiposangue, 'Tipo Sanguineo: ', text),
                \campo(doenca, 'Doenca: ', text),
                \campo(alergia, 'Alergia: ', text),
                \campo(fumante, 'Fumante: ', text),
                \campo(gestante, 'Gestante: ', text),
                \enviar
            ]
            )
        ).


editar_anamnese(AtomId, _Pedido):-
    atom_number(AtomId, Anamnese_id),
    ( anamnese:anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Anamnese')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                h1('Anamneses'),
                \form_anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante)
              ]) ])
    ; throw(http_reply(not_found(Anamnese_id)))
    ).


form_anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante) -->
    html(form([ id('anamnese-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/anamneses/~w' - Anamnese_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(anamnese_id, 'Anamnese_id', text, Anamnese_id),
                \campo(Medicamento, 'Medicamento: ', text, Medicamento),
                p(''),
                \campo(TipoSangue, 'Tipo Sanguineo: ', text, TipoSangue),
                p(''),
                \campo(Doenca, 'Doenca: ', text, Doenca),
                p(''),
                \campo(Alergia, 'Alergia: ', text, Alergia),
                p(''),
                \campo(Fumante, 'Fumante: ', text, Fumante),
                p(''),
                \campo(Gestante, 'Gestante: ', text, Gestante),
                p(''),
                \enviar
              ])).