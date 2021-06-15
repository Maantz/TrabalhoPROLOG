%:-module(
       %cadastro_usuario,
       %[ cadastro/1]).

:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).
:-ensure_loaded(gabarito(boot5rest)).

cadastro(Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [ title(' Cadastro de usuários')],
        [ div(class(container),
              [ \html_requires(js('comum.js')),
                h1('Cadastro de Usuários'),
                \form_cadastro(RotaDeRetorno),
                \retorna_home
              ]) ]).

form_cadastro(RotaDeRetorno) -->
    html(form([ id('usuario-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/usuarios/') ],
              [ \metodo_de_envio('POST'),
                \campo(nome, 'Nome', text),
                \campo(email, 'E-mail', email),
                \campo(senha, 'Senha', password),
                %\escolha(função, 'Função',
                         %[ estudante:'Estudante',
                           %prof:'Professor',
                           %admin:'Administrador' ],
                        %estudante),
                \enviar_ou_cancelar(RotaDeRetorno)
              ])).

