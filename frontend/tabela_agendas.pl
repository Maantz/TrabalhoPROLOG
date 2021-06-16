:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(bd(schedule), []).
:- use_module(tabela_agendas).


entrada_agenda(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina de Agendas')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \html_requires(js('comum.js')),
          h1('Espaco'),
          \navegacao('menu-topo'),
          \tabela_agendas
        ]
    ).


tabela_agendas-->
    html(div(class('row justify-content-center block-2'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Agendas', '/schedule'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho_agendas,
                          tbody(\corpo_tabela_agendas)
                        ])]))).


cabeca_da_tabela(Titulo, Link) -->
    html( div(class('d-flex p-1 headtables'),
              [ div(class('me-auto'), h2(b(Titulo))),
                div(class(''),
                    a([ href(Link), class('btn btn-primary botao')],
                      'Novo'))
              ]) ).


cabecalho_agendas -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Data'),
                    th([scope(col)], 'Horario'),
                    th([scope(col)], 'Motivo'),
                    th([scope(col)], 'Anotacoes'),
                    th([scope(col)], 'Telefone'),
                    th([scope(col)], 'Acoes')
                  ]))).


corpo_tabela_agendas -->
    {
        findall( tr([th(scope(row), Id), td(Date), td(Datetime), td(Reason), td(Notes), td(Phone), td(Acoes)]),
                 linha_agendas(Id, Date, Datetime, Reason, Notes, Phone, Acoes),
                 Linhas )
    },
    html(Linhas).


linha_agendas(Id, Date, Datetime, Reason, Notes, Phone, Acoes):-
    schedule:schedule(Id, Date, Datetime, Reason, Notes, Phone),
    acoes_agendas(Id, Acoes).


acoes_agendas(Id, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/schedule/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/schedules/~w' - Id),
                  onClick("apagar( event, '/entrada_agenda' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
