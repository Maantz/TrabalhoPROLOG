:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(bd(paciente), []).
:- use_module(tabela_pacientes).


entrada_paciente(_Pedido):-
    apelido_rota(root(entrada_paciente), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Pagina dos Pacientes')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          h2('Pagina dos Pacientes'),
          \navegacao('menu-topo'),
          \tabela_pacientes(RotaDeRetorno)
        ]
    ).


tabela_pacientes(RotaDeRetorno) -->
    html(div(class('row justify-content-center block-2'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Pacientes', '/paciente'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho_pacientes,
                          tbody(\corpo_tabela_pacientes(RotaDeRetorno))
                        ])]))).


cabecalho_pacientes -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Login do Paciente'),
                    th([scope(col)], 'Codigo do Convenio'),
                    th([scope(col)], 'Acoes')
                  ]))).


corpo_tabela_pacientes(RotaDeRetorno) -->
    {
        findall( tr([th(scope(row), Id), td(LoginP), td(CodConvenio), td(Acoes)]),
                 linha_pacientes(Id, LoginP, CodConvenio, Acoes, RotaDeRetorno),
                 Linhas )
    },
    html(Linhas).


linha_pacientes(Id, LoginP, CodConvenio, Acoes, RotaDeRetorno):-
    paciente:paciente(Id, LoginP, CodConvenio),
    acoes_pacientes(Id, RotaDeRetorno, Acoes).


acoes_pacientes(Id, RotaDeRetorno, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/paciente/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/pacientes/~w' - Id),
                  onClick("apagar( event, '~w' )" - RotaDeRetorno),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
