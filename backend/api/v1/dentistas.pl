:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(dentista), []).


dentistas(get, '', _Pedido):- !,
    envia_tabela_dentista.


dentistas(get, AtomId, _Pedido):-
    atom_number(AtomId, Dentista_id),
    !,
    envia_tupla_dentista(Dentista_id).


dentistas(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_dentista(Dados).


dentistas(put, AtomId, Pedido):-
    atom_number(AtomId, Dentista_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_dentista(Dados, Dentista_id).


dentistas(delete, AtomId, _Pedido):-
    atom_number(AtomId, Dentista_id),
    !,
    dentista:remove(Dentista_id),
    throw(http_reply(no_content)).


dentistas(Metodo, Dentista_id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Dentista_id))).


insere_tupla_dentista( _{cro:CRO} ):-
    dentista:insere(Dentista_id, CRO)
    -> envia_tupla_dentista(Dentista_id)
    ;  throw(http_reply(bad_request('Dentista ja cadastrado'))).


atualiza_tupla_dentista( _{cro:CRO}, Dentista_id ):-
       dentista:atualiza(Dentista_id, CRO)
    -> envia_tupla_dentista(Dentista_id)
    ;  throw(http_reply(not_found(Dentista_id))).


envia_tupla_dentista(Dentista_id):-
    dentista:dentista(Dentista_id, CRO)
    -> reply_json_dict( _{ dentista_id:Dentista_id, cro:CRO} )
    ;  throw(http_reply(not_found(Dentista_id))).


envia_tabela_dentista:-
    findall( _{ dentista_id:Dentista_id, cro:CRO},
             dentista:dentista(Dentista_id, CRO),
            Tuplas ),
    reply_json_dict(Tuplas).