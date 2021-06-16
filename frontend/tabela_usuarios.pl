:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(bd(usuario), []).
:- use_module(tabela_usuarios).


entrada_usuario(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Página dos Usuários')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \html_requires(js('comum.js')),
          h1('Espaco'),
          \navegacao('menu-topo'),
          \tabela_usuarios
        ]
    ).


tabela_usuarios -->
    html(div(class('row justify-content-center block-2'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Usuários', '/usuario'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho_usuarios,
                          tbody(\corpo_tabela_usuarios)
                        ])]))).


cabecalho_usuarios -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Nome'),
                    th([scope(col)], 'Email'),
                    th([scope(col)], 'Senha'),
                    th([scope(col)], 'Ações')
                  ]))).


corpo_tabela_usuarios-->
    {
        findall( tr([th(scope(row), Id), td(Nome), td(Email), td(Senha), td(Acoes)]),
                 linha_usuarios(Id, Nome, Email, Senha, Acoes),
                 Linhas )
    },
    html(Linhas).


linha_usuarios(Id, Nome, Email, Senha, Acoes):-
    usuario:usuario(Id, Nome, Email, Senha),
    acoes_usuarios(Id, Acoes).


acoes_usuarios(Id, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/usuario/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/usuarios/~w' - Id),
                  onClick("apagar( event, '/entrada_usuario' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
