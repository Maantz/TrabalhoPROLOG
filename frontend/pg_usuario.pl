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


form_usuario(RotaDeRetorno)-->
    html(form([ id('usuario-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/usuarios/') ],
              [ \metodo_de_envio('POST'),
                \campo(nome, 'Nome', text),
                \campo(cpf, 'CPF', text),
                \campo(dt_nasc, 'Data de nascimento', text),
                \campo(estado, 'Estado', text),
                \campo(cidade, 'Cidade', text),
                \campo(bairro, 'Bairro', text),
                \campo(rua, 'rua', text),
                \campo(numero, 'Número', text),
                \campo(cep, 'CEP', text),
                \campo(telefone, 'Telefone', text),
                \campo(celular, 'Celular', text),
                \campo(email, 'E-mail', email),
                \campo(tipo_Usuario, 'Tipo de Usuario(paciente, dentista, adm, funcionario)', text),
                \campo(login, 'Login', text),
                \campo(senha, 'Senha', password),
                \enviar
              ])).

editar_usuario(AtomId, Pedido):-
    (memberchk(referer(RotaDeRetorno), Pedido) ; RotaDeRetorno = '/' ),
    atom_number(AtomId, Usuario_id),
    ( usuario:usuario(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Usuario')],
        [ div(class(container),
              [ \html_requires(js('comum.js')),
                \html_requires(css('custom.css')),
                h1(class("my-5 text-center pforms"),
                  'Usuarios'),
                \form_edicao_usuario(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha, RotaDeRetorno),
                p(''),
                \retornar
              ]) ])
    ; throw(http_reply(not_found(Usuario_id)))
    ).

form_edicao_usuario(Usuario_id, Cpf, Nome, Dt_nasc, Estado, Cidade, Bairro, Rua, Numero, Cep, 
        Telefone, Celular, Email, Tipo_Usuario, Login,  Senha, RotaDeRetorno) -->
    html(form([ id('usuario-form'),
                onsubmit("redirecionaResposta( event, '~w' )" - RotaDeRetorno),
                action('/api/v1/usuarios/~w' - Usuario_id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(usuario_id, 'Id', text, Usuario_id),
                p(''),
                 \campo_nao_editavel(cpf, 'CPF', text, Cpf),
                 p(''),
                \campo(nome,  'Nome', text,  Nome),
                p(''),
                \campo(dt_nasc,  'Data de nascimento', text,  Dt_nasc),
                p(''),
                \campo(estado,  'estado', text,  Estado),
                p(''),
                \campo(cidade,  'Cidade', text,  Cidade),
                p(''),
                \campo(bairro,  'Bairro', text,  Bairro),
                p(''),
                \campo(rua,  'Rua', text,  Rua),
                p(''),
                \campo(bairro,  'Bairro', text,  Bairro),
                p(''),
                \campo(rua,  'Rua', text,  Rua),
                p(''),
                \campo(numero,  'Número', text, Numero),
                p(''),
                \campo(cep,  'CEP', text,  Cep),
                p(''),
                \campo(telefone,  'Telefone', text, Telefone),
                 p(''),
                \campo(celular,  'Celular', text,  Celular),
                 p(''),
                \campo(email, 'E-mail', email, Email),
                p(''),
                \campo(tipo_Usuario, 'Tipo de usuário(paciente, dentista, admin, funcionario)', text, Tipo_Usuario),
                p(''),
                \campo(login, 'Login', text, Login),
                p(''),
                \campo(senha, 'Senha', password, Senha),
                p(''),
                \enviar
              ])).