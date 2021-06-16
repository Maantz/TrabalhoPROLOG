:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).
:- ensure_loaded(frontend(icones)).


navegacao(Id) -->
    html(nav([ class='navbar navbar-expand-lg navbar-light bg-light fixed-top block-3'],
             [ div(class('container-fluid'),
                   [ a([ class='navbar-brand ', href= #],
                       ['Clínica OdontoLOG']),
                     button([ class('navbar-toggler'),
                              type(button),
                              'data-bs-toggle'=collapse,
                              'data-bs-target'='#~w'-[Id],
                              'aria-controls'=Id,
                              'aria-expanded'=false,
                              'aria-label'='Toggle navigation'],
                            [span([class='navbar-toggler-icon'], [])]),
                     div([ class(['collapse', 'navbar-collapse']),
                           id=Id ],
                         [ ul([class='navbar-nav ms-auto mb-2 mb-lg-0'],
                              [ \nav_item('/', 'Início'),
                                \nav_item('/entrada_usuario', 'Usuário'), %arquivo(tabela_usuarios)
                                \nav_item('/entrada_dentista', 'Dentista'),
                                \nav_item('/entrada_agenda', 'Agenda'),
                                \nav_item('/entrada_anamnese', 'Anamnese'),
                                \nav_item('/entrada_paciente', 'Paciente'),
                                \nav_item('/entrada_convenio', 'Convenio')
                              ]) ])
                   ])
             ]) ).


nav_item(Link, Rotulo) -->
    html(li([ class='nav-item'],
            [ a([class='nav-link m-1 menu-item', href=Link], Rotulo) ])).
