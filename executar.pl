:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_path)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_log)).
:- use_module(library(http/http_json)).


:- multifile http_json/1.


http_json:json_type('application/x-javascript').
http_json:json_type('text/javascript').
http_json:json_type('text/x-javascript').
http_json:json_type('text/x-json').


:- load_files([
                caminhos,
                config(banco_de_dados),
                config(carrega_website)
              ],
              [
                silent(true),
                if(not_loaded)
              ]
            ).
