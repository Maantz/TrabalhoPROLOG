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
                    th([scope(col)], 'CPF'),
                    th([scope(col)], 'Nome'),
                    th([scope(col)], 'Data de Nascimento'),
                    th([scope(col)], 'Estado'),
                    th([scope(col)], 'Cidade'),
                    th([scope(col)], 'Bairro'),
                    th([scope(col)], 'Rua'),
                    th([scope(col)], 'Numero'),
                    th([scope(col)], 'Cep'),
                    th([scope(col)], 'Telefone'),
                    th([scope(col)], 'Celular'),
                    th([scope(col)], 'Email'),
                    th([scope(col)], 'Tipo de Usuário'),
                    th([scope(col)], 'Login'),
                    th([scope(col)], 'Senha'),
                    th([scope(col)], 'Ações')
                  ]))).

corpo_tabela_usuarios-->
    {
        findall( tr([th(scope(row), Id), td(Cpf), td(Nome), td(Dt_nasc),
        td(Estado), td(Cidade), td(Bairro), td(Rua), td(Numero),
        td(Cep), td(Telefone), td(Celular), 
        td(Email), td(Tipo_Usuario), td(Login), td(Senha), td(Acoes)]),
                 linha_usuarios(Id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, 
                 Rua, Numero, Cep, Telefone, Celular, Email, Tipo_Usuario, Login, Senha, Acoes),
                 Linhas )
    },
    html(Linhas).


linha_usuarios(Id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, 
                 Rua, Numero, Cep, Telefone, Celular, Email, Tipo_Usuario, Login, Senha, Acoes):-
    usuario:usuario(Id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, 
                 Rua, Numero, Cep, Telefone, Celular, Email, Tipo_Usuario, Login, Senha),
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
