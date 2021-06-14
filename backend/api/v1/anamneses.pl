/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(anamnese), []).

/*
   GET api/v1/bookmarks/
   Retorna uma lista com todos os bookmarks.
*/

anamneses(get, '', _Pedido):- !,
    envia_tabela_Anamnese.

/*
   GET api/v1/bookmarks/Id
   Retorna o `bookmark` com Id 1 ou erro 404 caso o `bookmark` não
   seja encontrado.
*/

anamneses(get, AtomId, _Pedido):-
    atom_number(AtomId, IdAnamnese),
    !,
    envia_tupla_Anamnese(IdAnamnese).

/*
   POST api/v1/bookmarks
   Adiciona um novo bookmark. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/

anamneses(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_Anamnese(Dados).

/*
  PUT api/v1/bookmarks/Id
  Atualiza o bookmark com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/

anamneses(put, AtomId, Pedido):-
    atom_number(AtomId, IdAnamnese),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_Anamnese(Dados, IdAnamnese).

/*
   DELETE api/v1/bookmarks/Id
   Apaga o bookmark com o Id informado
*/

anameses(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdAnamnese),
    !,
    anamnese:removeAnamnese(IdAnamnese),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

anamneses(Metodo, IdAnamnese, _Pedido):-
    throw(http_reply(method_not_allowed(Metodo, IdAnamnese))).

insere_tupla_Anamnese(_{medicamento:Medicamento,tiposangue:Sangue,doenca:Doenca,alergia:Alergia,fumante:Fumante,gestante:Gestante}):-
    anamnese:insereAnamnese(IdAnamnese,Medicamento,Sangue,Doenca,Alergia,Fumante,Gestante)
    -> envia_tupla_Anamnese(IdAnamnese).

atualiza_tupla_Anamnese( _{medicamento:Medicamento,tiposangue:Sangue,doenca:Doenca,alergia:Alergia,fumante:Fumante,gestante:Gestante}, IdAnamnese):-
       anamnese:atualizaAnamnese(IdAnamnese,Medicamento,Sangue,Doenca,Alergia,Fumante,Gestante)
    -> envia_tupla_Anamnese(IdAnamnese)
    ;  throw(http_reply(not_found(IdAnamnese))).


envia_tupla_Anamnese(IdAnamnese):-
       anamnese:anamnese(IdAnamnese, Medicamento ,Sangue,Doenca,Alergia,Fumante,Gestante)
    -> reply_json_dict( _{idAnamnese:IdAnamnese, medicamento:Medicamento, tiposangue:Sangue, doenca:Doenca, alergia:Alergia, fumante:Fumante, gestante:Gestante})
    ;  throw(http_reply(not_found(IdAnamnese))).


envia_tabela_Anamnese :-
    findall( _{idAnamnese:IdAnamnese, medicamento:Medicamento, tiposangue:Sangue, doenca:Doenca, alergia:Alergia, fumante:Fumante, gestante:Gestante},
             anamnese:anamnese(IdAnamnese,Medicamento,Sangue,Doenca,Alergia,Fumante,Gestante),
             Tuplas ),
    reply_json_dict(Tuplas).
