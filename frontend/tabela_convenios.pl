:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(bd(convenio), []).
:- use_module(tabela_convenios).


entrada_convenio(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina de Convenios')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \html_requires(js('comum.js')),
          h1('Espaco'),
          \navegacao('menu-topo'),
          \tabela_convenios
        ]
    ).


tabela_convenios -->
    html(div(class('row justify-content-center block-2'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Convenios', '/convenio'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho_convenios,
                          tbody(\corpo_tabela_convenios)
                        ])]))).


cabecalho_convenios -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Codigo do Convenio'),
                    th([scope(col)], 'Razao Social'),
                    th([scope(col)], 'Acoes')
                  ]))).


corpo_tabela_convenios-->
    {
        findall( tr([th(scope(row), Id), td(CodConvenio), td(RazaoSocial), td(Acoes)]),
                 linha_convenios(Id, CodConvenio, RazaoSocial, Acoes),
                 Linhas )
    },
    html(Linhas).


linha_convenios(Id, CodConvenio, RazaoSocial, Acoes):-
    convenio:convenio(Id, CodConvenio, RazaoSocial),
    acoes_convenios(Id, Acoes).


acoes_convenios(Id, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/convenio/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/convenios/~w' - Id),
                  onClick("apagar( event, '/entrada_convenio' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
