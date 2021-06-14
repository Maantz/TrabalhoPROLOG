%Banco de dados

%Coloque aqui todas as tabelas do banco.
%inserir as outras tabelas no arquivo (bd/tabelas/...)
tabela(chave).
tabela(usuario).
tabela(dentista).



%Não mexa daqui em diante

:-initialization(carrega_tabelas).


carrega_tabelas():-
    findall(Tab, tabela(Tab), Tabs),
    maplist(carrega_tab,Tabs).

carrega_tab(Tabela):-
    use_module(bd(Tabela),[]),
    atomic_list_concat(['tbl_', Tabela, '.pl'], ArqTab),
    expand_file_search_path(bd_tabs(ArqTab), CaminhoTab),
    Tabela:carrega_tab(CaminhoTab).