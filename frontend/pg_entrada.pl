:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).

:-load_files(gabarito(boot5rest)).

entrada(_):-
    reply_html_page(
        boot5rest,
        [ title('Clínica Odontlógica')],
        [ div(class(container),
              [ 
                \html_requires(css('custom.css')),
                \navegacao('menu-topo'),
                \propaganda
              ]) ]).

propaganda -->
    html(div([ class='container-fluid' ],
             div([ id='propaganda',
                   class='py-5 text-center block block-1'],
                 [ h1(class('py-5'), 'Sistema para Gerenciamento de Agendamento de Clínica Odontológica'),
                   h2(class('py-5'), 'Seja bem vindo à nossa Clínica!'),
                   p(class(lead),
                     [ 'Muito obrigado por acreditar em nosso trabalho.']),
                   p(class(lead),
                     [ 'Número para entrar em contato: (34) 97070-7070 '
                     ]),
                   p(class(lead),
                     ['Email para entrar em contato: clinica_odonto@gmail.com']),
                   p(class(lead), 'Volte sempre!')
                ]))).


%%Predicados auxiliares para os forms:
enviar -->
    html(div([ class('btn-group botao'), role(group), 'aria-label'('Enviar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary botao')], 'Enviar')
            ])
        ).

campo_nao_editavel(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       value(Valor),
                       readonly ])
             ] )).


campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).

campo(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).


metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_método'), value(Metodo)])).


retornar -->
    html(div(class(row),
        a([class(['btn', 'btn-primary', 'botao']),
        href('/')],
        'Retornar ao menu inicial.')
        )
    ).
