:- use_module(library(http/thread_httpd)).

:- use_module(library(http/html_head)).

:- use_module(library(http/html_write)).

:- ensure_loaded(gabarito(boot5rest)).

:- encoding(utf8).

agenda(_Pedido) :-
    reply_html_page(
        boot5rest,
        [ title('Cadastro - Agendamento')],
        [
         \html_requires(js('bookmark.js')),
          \html_requires(js('rest.js')),
        h2('Cadastro de Horarios'),
        \form_agenda
]
).


form_agenda -->
html(form(
    [
        id('agenda-form'),
        onsubmit("redirecionaResposta( event, '/' )"),
        action('/api/v1/schedules/')
    ],
    [
        \metodo_de_envio('POST'),
        \campo(date, 'Data: ', text),
        \campo(datetime, 'Horario: ', text),
        \campo(reason, 'Motivo: ', text),
        \campo(notes, 'Anotacao: ', text),
        \campo(phone, 'Telefone: ', text),
        \enviar_ou_cancelar('/')
    ]
    )
).


