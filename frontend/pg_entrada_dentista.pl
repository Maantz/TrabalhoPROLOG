entrada_dentista(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina do Dentista')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \navegacao('menu-topo'),
          \tab_dentistas(RotaDeRetorno)
        ]
    ).
