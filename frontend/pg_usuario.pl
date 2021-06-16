:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).


:-load_files(gabarito(boot5rest)).


:- encoding(utf8).


usuario(Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    reply_html_page(
        boot5rest,
        [ title(' Cadastro de Usuários')],
        [ div(class(container),
              [ \html_requires(css('custom.css')),
                \html_requires(js('rest.js')),
                \html_requires(js('comum.js')),
                p(''),
                p(''),
                p(''),
                p(''),
                h1(class("my-5 text-center pforms"),
                    'Cadastro de Novo Usuario'),
                \form_usuario(RotaDeRetorno),
                 p(''),
                \retornar
              ]) ]).
              

form_usuario(RotaDeRetorno) -->
    html(form([ id('usuario-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/usuarios/') ],
              [ \metodo_de_envio('POST'),
                \campo(nome, 'Nome', text),
                \campo(email, 'E-mail', email),
                \campo(senha, 'Senha', password),
                \enviar
              ])).


editar_usuario(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Usuario_id),
    ( usuario:usuario(Usuario_id, Nome, Email, Senha)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Usuario')],
        [ div(class(container),
              [ 
                \html_requires(js('comum.js')),
                h1('Usuarios'),
                \form_edicao_usuario(Usuario_id, Nome, Email, Senha, RotaDeRetorno)
              ]) ])
    ; throw(http_reply(not_found(Usuario_id)))
    ).



form_edicao_usuario(Usuario_id, Nome, Email, _Senha, RotaDeRetorno) -->
    html(form([ id('usuario-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/usuarios/~w' - Usuario_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(usuario_id, 'Usuario_id', text, Usuario_id),
                p(''),
                \campo(nome,  'Nome',   text,  Nome),
                p(''),
                \campo(email, 'E-mail', email, Email),
                p(''),
                \campo(senha, 'Senha',  password, ''),
                p(''),
                \enviar
              ])).