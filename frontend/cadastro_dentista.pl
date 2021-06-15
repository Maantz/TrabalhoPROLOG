:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).
:-ensure_loaded(gabarito(boot5rest)).


cadastroDentista(Pedido):-
    reply_html_page(
        boot5rest,
        [title('Clinica Odontologica')],
        [div(class(container),
            [   \html_requires(js('comum.js')),
                h1(class("my-5 text-center"),
                    'Cadastro de Dentista'),
            \cadastro_formulario_dentista,
            br(br),
            \retorna_home])]
    ).

cadastro_formulario_dentista -->
    html(form([id('dentista-form'),
                onsubmit("redirecionaResposta(event, '/' )"),
                action('/api/v1/dentistas/')],
                [   \metodo_de_envio('POST'),
                    \campo(cro, 'CRO', text),
                    \campo(login, 'Login', number),
                    \campo(senha, 'Senha', password),
                    \enviar_ou_cancelar('/')
                ])

    ).



