entrada_agenda(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina da Agenda')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \navegacao('menu-topo'),
          \tab_agenda(RotaDeRetorno)
        ]
    ).
