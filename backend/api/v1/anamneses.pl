:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(bd(anamnese), []).


anamneses(get, '', _Pedido):- !,
    envia_tabela_anamnese.


anamneses(get, AtomId, _Pedido):-
    atom_number(AtomId, Anamnese_id),
    !,
    envia_tupla_anamnese(Anamnese_id).


anamneses(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_anamnese(Dados).


anamneses(put, AtomId, Pedido):-
    atom_number(AtomId, Anamnese_id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_anamnese(Dados, Anamnese_id).


anamneses(delete, AtomId, _Pedido):-
    atom_number(AtomId, Anamnese_id),
    !,
    anamnese:remove(Anamnese_id),
    throw(http_reply(no_content)).


anamneses(Metodo, Anamnese_id, _Pedido):-
    throw(http_reply(method_not_allowed(Metodo, Anamnese_id))).


insere_tupla_anamnese(_{medicamento:Medicamento, tiposangue:Sangue, doenca:Doenca, alergia:Alergia, fumante:Fumante, gestante:Gestante}):-
    anamnese:insere(Anamnese_id, Medicamento, Sangue, Doenca, Alergia, Fumante, Gestante)
    -> envia_tupla_anamnese(Anamnese_id).

atualiza_tupla_anamnese( _{medicamento:Medicamento, tiposangue:Sangue, doenca:Doenca, alergia:Alergia, fumante:Fumante, gestante:Gestante}, Anamnese_id):-
       anamnese:atualiza(Anamnese_id, Medicamento, Sangue, Doenca, Alergia, Fumante, Gestante)
    -> envia_tupla_anamnese(Anamnese_id)
    ;  throw(http_reply(not_found(Anamnese_id))).


envia_tupla_anamnese(Anamnese_id):-
       anamnese:anamnese(Anamnese_id, Medicamento, Sangue, Doenca, Alergia, Fumante, Gestante)
    -> reply_json_dict( _{anamnese_id:Anamnese_id, medicamento:Medicamento, tiposangue:Sangue, doenca:Doenca, alergia:Alergia, fumante:Fumante, gestante:Gestante})
    ;  throw(http_reply(not_found(Anamnese_id))).


envia_tabela_anamnese:-
    findall( _{anamnese_id:Anamnese_id, medicamento:Medicamento, tiposangue:Sangue, doenca:Doenca, alergia:Alergia, fumante:Fumante, gestante:Gestante},
             anamnese:anamnese(Anamnese_id, Medicamento, Sangue, Doenca, Alergia, Fumante, Gestante),
             Tuplas ),
    reply_json_dict(Tuplas).
