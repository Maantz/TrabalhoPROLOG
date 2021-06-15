:- multifile user:file_search_path/2.


user:file_search_path(dir_base, 'C:/aulas-si-remotas/prolog/github').


user:file_search_path(trabalho, dir_base(trabalho)).


user:file_search_path(config, trabalho(config)).


user:file_search_path(frontend, trabalho(frontend)).


user:file_search_path(dir_css, frontend(css)).
user:file_search_path(dir_js,  frontend(js)).
user:file_search_path(dir_img, frontend(img)).


user:file_search_path(gabarito, frontend(gabaritos)).


user:file_search_path(backend, trabalho(backend)).


user:file_search_path(bd, backend(bd)).
user:file_search_path(bd_tabs, bd(tabelas)).


user:file_search_path(api,  backend(api)).
user:file_search_path(api1, api(v1)).
