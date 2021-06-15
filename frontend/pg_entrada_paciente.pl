entrada_paciente(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Pagina do Paciente')],
        [ \html_requires(css('custom.css')),
          \html_requires(css('entrada.css')),
          \navegacao('menu-topo'),
          \tab_paciente(RotaDeRetorno)
        ]
    ).
