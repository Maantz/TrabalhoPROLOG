:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(bd(anamnese), []).
:- use_module(tabela_anamneses).


entrada_anamnese(_Pedido):-
    apelido_rota(root(entrada_anamnese), RotaDeRetorno),
    reply_html_page(
        boot5rest,
        [ title('Pagina de Anamneses')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          h2('Pagina de Anamneses'),
          \navegacao('menu-topo'),
          \tabela_anamneses(RotaDeRetorno)
        ]
    ).


tabela_anamneses(RotaDeRetorno) -->
    html(div(class('row justify-content-center'),
             div( class('col-md-8'),
                  [ \cabeca_da_tabela('Anamneses', '/anamnese'),
                    table(class('table table-striped table-responsive-md'),
                        [ \cabecalho_anamneses,
                          tbody(\corpo_tabela_anamneses(RotaDeRetorno))
                        ])]))).


cabecalho_anamneses -->
    html(thead(tr([ th([scope(col)], '#'),
                    th([scope(col)], 'Medicamento'),
                    th([scope(col)], 'Tipo Sanguineo'),
                    th([scope(col)], 'Doenca'),
                    th([scope(col)], 'Alergia'),
                    th([scope(col)], 'Fumante'),
                    th([scope(col)], 'Gestante'),
                    th([scope(col)], 'Acoes')
                  ]))).


corpo_tabela_anamneses(RotaDeRetorno) -->
    {
        findall( tr([th(scope(row), Id), td(Medicamento), td(TipoSangue), td(Doenca), td(Alergia), td(Fumante), td(Gestante),td(Acoes)]),
                 linha_anamneses(Id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante, Acoes, RotaDeRetorno),
                 Linhas )
    },
    html(Linhas).


linha_anamneses(Id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante, Acoes, RotaDeRetorno):-
    anamnese:anamnese(Id, Medicamento, TipoSangue, Doenca, Alergia, Fumante, Gestante),
    acoes_anamneses(Id, RotaDeRetorno, Acoes).


acoes_anamneses(Id, RotaDeRetorno, Campo):-
    Campo = [ a([ class('text-success'), title('Alterar'),
                  href('/anamnese/editar/~w' - Id),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([ class('text-danger ms-2'), title('Excluir'),
                  href('/api/v1/anamneses/~w' - Id),
                  onClick("apagar( event, '~w' )" - RotaDeRetorno),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].
