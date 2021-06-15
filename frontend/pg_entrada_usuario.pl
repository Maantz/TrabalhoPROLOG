entrada_usuario(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina do Usuario')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \navegacao('menu-topo'),
          \tab_usuarios(RotaDeRetorno)
        ]
    ).
