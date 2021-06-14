:-use_module(library(http/http_dispatch)).
:-use_module(library(http/http_path)).

:-load_files(projeto(caminhos)).

%ainda nao vi a utilidade desse predicado(by.:gustavo)
apelido_rota(Apelido, RotaCompleta):-
   http_absolute_location(Apelido, Rota, []),
   atom_concat(Rota, '/', RotaCompleta).

:-multifile http:location/3.
:-dynamic   http:location/3.

%http:location(Apelido, Rota, Opções)
%      Apelido é como será chamada uma Rota do servidor.
%      Os apelidos css, icons e js já estão definidos na
%      biblioteca http/http_server_files, os demais precisam
%      ser definidos.


http:location(api, root(api), []).
http:location(api1, api(v1), []).

%Recursos estáticos
:-http_handler( css(.),
                 serve_files_in_directory(dir_css), [prefix]).

:-http_handler( js(.),
                 serve_files_in_directory(dir_js),  [prefix]).

%===========================================================
%Rotas do Frontend(editar aqui conforme formos avançando no frontend)

:-http_handler(root(.), entrada,   []).
%:- http_handler( root(.), pg_entrada:entrada, []).
:- http_handler(root(home), home, []).
%:- http_handler(root(cadastroUsuario), cadastroUsuario, []).
:- http_handler(root(cadastroDentista), cadastroDentista, []).

:-http_handler(root(cadastro), cadastro, []).
:-http_handler(root(tab_usuarios), tab_usuarios, []).

%% A página de cadastro de novos usuários
%:- http_handler( root(cadastro), cadastro_usuario:cadastro, []).

%===========================================================

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Rotas da API(inserir a api de vocês, by.:gustavo)

:- http_handler(api1(usuarios/Id), usuarios:usuarios(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler(api1(dentistas/Id), dentistas:dentistas(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
