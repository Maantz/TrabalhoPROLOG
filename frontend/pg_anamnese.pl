:- use_module(library(http/thread_httpd)).
:- use_module(library(http/html_head)).
:- use_module(library(http/html_write)).


:- ensure_loaded(gabarito(boot5rest)).


:- encoding(utf8).
 
 
anamnese(Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [ title('Receitas - Paciente')],
        [div(class(container),
            [   \html_requires(css('custom.css')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Nova Anamnese'),
                \form_anamnese(RotaDeRetorno),
                p(''),
                \retornar
            ])
        ]
    ).


form_anamnese(RotaDeRetorno)-->
    html(form(
            [
                id('anamnese-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
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


editar_anamnese(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Anamnese_id),
    ( anamnese:anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Anamnese')],
        [ div(class(container),
              [ \html_requires(js('comum.js')),
                h1('Anamneses'),
                \form_edicao_anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante, RotaDeRetorno),
                p(''),
                \retornar
              ]) ])
    ; throw(http_reply(not_found(Anamnese_id)))
    ).


form_edicao_anamnese(Anamnese_id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante, RotaDeRetorno) -->
    html(form([ id('anamnese-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/anamneses/~w' - Anamnese_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(anamnese_id, 'Id', text, Anamnese_id),
                p(''),
                \campo(medicamento, 'Medicamento: ', text, Medicamento),
                p(''),
                \campo(tiposangue, 'Tipo Sanguineo: ', text, TipoSangue),
                p(''),
                \campo(doenca, 'Doenca: ', text, Doenca),
                p(''),
                \campo(alergia, 'Alergia: ', text, Alergia),
                p(''),
                \campo(fumante, 'Fumante: ', text, Fumante),
                p(''),
                \campo(gestante, 'Gestante: ', text, Gestante),
                p(''),
                \enviar
              ])).