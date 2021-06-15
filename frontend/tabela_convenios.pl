:- module(
       tabela_convenios,
       [
           tab_convenios//1
       ]
   ).


:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).


tabela_convenios(RotaDeRetorno) -->
    html(div(class('container-fluid py-2'),
             [ \tabela(RotaDeRetorno) ]
            )).


cabeca_da_tabela(Titulo, Link) -->
    html( div(class('d-flex p-1'),
              [ div(class('me-auto'), h2(b(Titulo))),
                div(class(''),
                    a([ href(Link), class('btn btn-primary')],
                      'Novo'))
              ]) ).


tabela(RotaDeRetorno) -->
    html(div(class('row justify-content-center'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Convenios', '/convenio'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho,
                          tbody(\corpo_tabela(RotaDeRetorno))
                        ])]))).


cabecalho -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Codigo do Convenio'),
                    th([scope(col)], 'Razao Social'),
                    th([scope(col)], 'Acoes')
                  ]))).


corpo_tabela(RotaDeRetorno) -->
    {
        findall( tr([th(scope(row), Id), td(Titulo), td(Link), td(Acoes)]),
                 linha(Id, Titulo, Link, Acoes, RotaDeRetorno),
                 Linhas )
    },
    html(Linhas).


linha(Id, Titulo, Link, Acoes, RotaDeRetorno):-
    convenio:convenio(Id, CodConvenio, RazaoSocial),
    acoes(Id, RotaDeRetorno, Acoes),
    Link = a([href(URL)], URL).


acoes(Id, RotaDeRetorno, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/convenio/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/convenios/~w' - Id),
                  onClick("apagar( event, '~w' )" - RotaDeRetorno),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
