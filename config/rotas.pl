:-use_module(library(http/http_dispatch)).
:-use_module(library(http/http_path)).


:- ensure_loaded(caminhos).


apelido_rota(Apelido, RotaCompleta):-
   http_absolute_location(Apelido, Rota, []),
   atom_concat(Rota, '/', RotaCompleta).


:-multifile http:location/3.
:-dynamic   http:location/3.


http:location(img, root(img), []).
http:location(api, root(api), []).
http:location(api1, api(v1), []).


:-http_handler( css(.),
                 serve_files_in_directory(dir_css), [prefix]).
:-http_handler( js(.),
                 serve_files_in_directory(dir_js),  [prefix]).
:- http_handler( img(.),
                 serve_files_in_directory(dir_img), [prefix]).
:- http_handler( '/favicon.ico',
                 http_reply_file(dir_img('favicon.ico'), []),
                 []).



:- http_handler(root(.), entrada,   []).
:- http_handler(root(entrada_dentista), entrada_dentista, []).
:- http_handler(root(entrada_usuario), entrada_usuario, []).
:- http_handler(root(entrada_agenda), entrada_agenda, []).
:- http_handler(root(entrada_anamnese), entrada_anamnese, []).
:- http_handler(root(entrada_convenio), entrada_convenio, []).
:- http_handler(root(entrada_paciente), entrada_paciente, []).

:- http_handler(root(dentista), dentista, []).
:- http_handler(root(usuario), usuario, []).
:- http_handler(root(schedule), agenda, []).
:- http_handler(root(anamnese), anamnese, []).
:- http_handler(root(convenio), convenio, []).
:- http_handler(root(paciente), paciente, []).

:- http_handler(root(dentista/editar/Id), editar_dentista(Id), []).
:- http_handler(root(usuario/editar/Id), editar_usuario(Id), []).
:- http_handler(root(schedule/editar/Id), editar_agenda(Id), []).
:- http_handler(root(anamnese/editar/Id), editar_anamnese(Id), []).
:- http_handler(root(convenio/editar/Id), editar_convenio(Id), []).
:- http_handler(root(paciente/editar/Id), editar_paciente(Id), []).


:- http_handler(api1(usuarios/Id), usuarios(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).


:- http_handler(api1(dentistas/Id), dentistas(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).


:- http_handler(api1(anamneses/Id), anamneses(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).


:- http_handler(api1(schedules/Id), schedules(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).


:- http_handler(api1(convenios/Id), convenios(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).


:- http_handler(api1(pacientes/Id), pacientes(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
