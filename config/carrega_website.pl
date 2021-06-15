:-load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).


:-initialization(servidor(9000)).



:-load_files([  gabarito(bootstrap5),         % <----------- ver essa questão(frontent)
                gabarito(boot5rest)%,
                %frontend(pg_entrada),
                %frontend(menu_topo),
                %frontend(icones)
              ],
              [ silent(true),
                if(not_loaded) ]).


:-load_files([
              api1(dentistas),
              api1(usuarios),
              api1(convenios),
              api1(pacientes),
              api1(anamneses),
              api1(schedules)
              ],
              [ silent(true),
                if(not_loaded) ]).