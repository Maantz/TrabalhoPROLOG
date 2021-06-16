:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(bd(dentista), []).
:- use_module(tabela_dentistas).


entrada_dentista(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina dos Dentista')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \html_requires(js('comum.js')),
          h1('Espaco'),
          \navegacao('menu-topo'),
          \tabela_dentistas
        ]
    ).


tabela_dentistas -->
    html(div(class('row justify-content-center block-2'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Dentistas', '/dentista'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho_dentistas,
                          tbody(\corpo_tabela_dentistas)
                        ])]))).


cabecalho_dentistas -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'CRO'),
                    th([scope(col)], 'Acoes')
                  ]))).


corpo_tabela_dentistas -->
    {
        findall( tr([th(scope(row), Id), td(CRO), td(Acoes)]),
                 linha_dentistas(Id, CRO, Acoes),
                 Linhas )
    },
    html(Linhas).


linha_dentistas(Id, CRO, Acoes):-
    dentista:dentista(Id, CRO),
    acoes_dentistas(Id, Acoes).


acoes_dentistas(Id, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/dentista/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/dentistas/~w' - Id),
                  onClick("apagar( event, '/entrada_dentista' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
