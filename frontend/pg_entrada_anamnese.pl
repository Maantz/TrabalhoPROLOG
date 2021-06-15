entrada_anamnese(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina da Anamnese')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \navegacao('menu-topo'),
          \tab_anamneses(RotaDeRetorno)
        ]
    ).
