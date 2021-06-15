:-load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).


:-initialization(servidor(8000)).



:-load_files([  gabarito(bootstrap5),
                gabarito(boot5rest),
                frontend(pg_entrada),
                frontend(pg_usuario),
                frontend(pg_dentista),
                frontend(pg_agenda),
                frontend(pg_anamnese),
                frontend(pg_convenio),
                frontend(pg_paciente),
                frontend(pg_dentista),
                frontend(pg_usuario),
                frontend(pg_entrada_agenda),
                frontend(pg_entrada_anamnese),
                frontend(pg_entrada_convenio),
                frontend(pg_entrada_paciente),
                frontend(pg_entrada_dentista),
                frontend(pg_entrada_usuario),
                frontend(menu_topo),
                frontend(icones)
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