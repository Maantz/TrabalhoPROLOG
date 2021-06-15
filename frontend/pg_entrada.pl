:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).

:-load_files(gabarito(boot5rest)).

entrada(_):-
    reply_html_page(
        boot5rest,
        [ title('Clinica Odontologica')],
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
                     [ 'Estamos felizes em você acreditar no nosso trabalho.']),
                   p(class(lead),
                     [ 'Numero para entrar em contato: '
                     ]),
                   p(class(lead),
                     ['Email para entrar em contato']),
                   p(class(lead), 'Volte sempre!'),
                   \home
                ]))).

home--> 
    html(div(
        [
            \link_cadastroUsuario,
            \link_cadastroDentista,
            \link_tabelaUsuario
            %\colocar os outros links para os outros formularios
        ]
    )).

link_cadastroUsuario -->
    html(a([class(['nav-link']),
            href('/usuario')],
            'Cadastro de Usuario')).

link_cadastroDentista-->
    html(a([class(['nav-link']),
            href('/dentista')],
            'Cadastro de Dentista')).

link_tabelaUsuario -->
    html(a([class(['nav-link']),
            href('/tab_usuarios')],
            'Tabela de Usuários')).


/*
cadastroUsuario(_Pedido):-
    reply_html_page(
        boot5rest,
        [title('Clinica Odontologica')],
        [div(class(container),
            [\html_requires(css('estilo.css')),
                h1(class("my-5 text-center"),
                    'Cadastro de Usuario'),
            \cadastro_formulario,
            br(br),
            \retorna_home])]
    ).
*/

campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).


enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_metodo'), value(Metodo)])).







/*
cadastro_formulario-->
    html(form([id('usuario-form'),
                onsubmit("redirecionaResposta(event, '/' )"),
                action('/api/v1/user')],
                [   \metodo_de_envio('POST'),
                    \campo(cpf, 'CPF', text),
                    \campo(nome, 'Nome', text),
                    \campo(dt_nasc, 'Data de nascimento', date),
                    \campo(estado, 'Estado', text),
                    \campo(cidade, 'Cidade', text),
                    \campo(bairro, 'Bairro', text),
                    \campo(rua, 'Rua', text),
                    \campo(numero, 'Numero', number),
                    \campo(cep, 'CEP', number),
                    \campo(telefone, 'Telefone', number),
                    \campo(celular, 'Celular', number),
                    \campo(email, 'Email', email),
                    \campo(tipo_usuario, 'Tipo de usuario', radio),
                    \campo(paciente, 'Paciente', radio),
                    \campo(dentista, 'Dentista', radio),
                    \campo(funcionario, 'Funcionario', radio),
                    \campo(admin, 'Administrador', radio),

                    \campo(login, 'Login', number),
                    \campo(senha, 'Senha', password),
                    \enviar_ou_cancelar('/')
                ])
    ).
*/

retorna_home -->
    html(div(class(row),
                a([class(['btn', 'btn-primary']), href('/')],
                    'Voltar para o Inicio')
            )
        ).

