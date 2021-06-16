:- use_module(library(http/thread_httpd)).
:- use_module(library(http/html_head)).
:- use_module(library(http/html_write)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


agenda(_Pedido) :-
    reply_html_page(
        boot5rest,
        [ title('Cadastro - Agenda')],
        [div(class(container),
            [   
                \html_requires(css('custom.css')),
                \html_requires(js('rest.js')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Nova Agenda'),
                \form_agenda,
                p(''),
                \retornar
            ])
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
            \campo(notes, 'Anotacoes: ', text),
            \campo(phone, 'Telefone: ', text),
            \enviar
        ]
    )
).


editar_agenda(AtomId, _Pedido):-
    atom_number(AtomId, Schedule_id),
    ( schedule:schedule(Schedule_id, Date, Datetime, Reason, Notes, Phone)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Agenda')],
        [ div(class(container),
              [ \html_requires(js('rest.js')),
                \html_requires(js('custom.js')),
                h1('Agendas'),
                \form_agenda(Schedule_id, Date, Datetime, Reason, Notes, Phone)
              ]) ])
    ; throw(http_reply(not_found(Schedule_id)))
    ).


form_edicao_agenda(Schedule_id, Date, Datetime, Reason, Notes, Phone, RotaDeRetorno) -->
    html(form([ id('agenda-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/schedules/~w' - Schedule_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(schedule_id, 'Schedule_id', text, Schedule_id),
                \campo(Date, 'Data: ', text, Date),
                p(''),
                \campo(Datetime, 'Horarios: ', text, Datetime),
                p(''),
                \campo(Reason, 'Motivo: ', text, Reason),
                p(''),
                \campo(Notes, 'Anotacoes: ', text, Notes),
                p(''),
                \campo(Phone, 'Telefone: ', text, Phone),
                p(''),
                \enviar
              ])).