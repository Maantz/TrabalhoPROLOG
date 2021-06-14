%Configuração do servidor

%Carrega o servidor e as rotas

:-load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).


:-initialization(servidor(9000)).


%Carrega o frontend
%temos que editar aqui conforme formos decidindo quais arquivos front manter
:-load_files([gabarito(bootstrap5),  
                gabarito(boot5rest),
                frontend(pg_entrada),
                frontend(cadastro_usuario),
                frontend(cadastro_dentista),
                frontend(menu_topo),
                frontend(icones),
                frontend(tabela_usuarios)
              ],
              [ silent(true),
                if(not_loaded) ]).

%Carrega o backend
%colocar a api de voces(by.:gustavo)
:-load_files([  %API REST
              api1(dentistas),
              api1(usuarios),
              api1(anameneses),
              api1(convenios),
              api1(pacientes),
              api1(schedules)
              ],
              [ silent(true),
                if(not_loaded) ]).