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
                \html_requires(js('bookmark.js')),
                \html_requires(js('rest.js')),
                h2('Cadastro de Receitas'),
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
                \campo(tiposangue, 'Tipo Sangue: ', text),
                \campo(doenca, 'Doenca: ', text),
                \campo(alergia, 'Alergia: ', text),
                \campo(fumante, 'Fumante: ', text),
                \campo(gestante, 'Gestante: ', text),
                \enviar_ou_cancelar('/')
            ]
            )
        ).
