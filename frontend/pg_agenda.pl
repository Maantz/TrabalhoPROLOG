:- use_module(library(http/thread_httpd)).
:- use_module(library(http/html_head)).
:- use_module(library(http/html_write)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).


agenda(Pedido) :-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [ title('Cadastro - Agenda')],
        [div(class(container),
            [   \html_requires(css('custom.css')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Nova Agenda'),
                \form_agenda(RotaDeRetorno),
                p(''),
                \retornar
            ])
        ]
    ).


form_agenda(RotaDeRetorno)-->
    html(form(
        [
            id('agenda-form'),
            onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
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


editar_agenda(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Schedule_id),
    ( schedule:schedule(Schedule_id, Date, Datetime, Reason, Notes, Phone)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Agenda')],
        [ div(class(container),
              [ \html_requires(js('comum.js')),
                \html_requires(css('custom.css')),
                h1(class("my-5 text-center pforms"),
                    'Agendas'),
                \form_edicao_agenda(Schedule_id, Date, Datetime, Reason, Notes, Phone, RotaDeRetorno),
                p(''),
                \retornar
              ]) ])
    ; throw(http_reply(not_found(Schedule_id)))
    ).


form_edicao_agenda(Schedule_id, Date, Datetime, Reason, Notes, Phone, RotaDeRetorno) -->
    html(form([ id('agenda-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/schedules/~w' - Schedule_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(schedule_id, 'Id', text, Schedule_id),
                \campo(date, 'Data: ', text, Date),
                p(''),
                \campo(datetime, 'Horarios: ', text, Datetime),
                p(''),
                \campo(reason, 'Motivo: ', text, Reason),
                p(''),
                \campo(notes, 'Anotacoes: ', text, Notes),
                p(''),
                \campo(phone, 'Telefone: ', text, Phone),
                p(''),
                \enviar
              ])).