:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).
:- ensure_loaded(frontend(icones)).


navegacao(Id) -->
    html(nav([ class='navbar navbar-expand-lg navbar-light bg-light fixed-top'],
             [ div(class('container-fluid'),
                   [ a([ class='navbar-brand', href= #],
                       ['Clinica Odontologica']),
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
                              [ \nav_item('/', 'Inicio'),
                                \nav_item('/usuario', 'Usuario'),
                                \nav_item('/dentista', 'Dentista'),
                                \nav_item('/agenda', 'Agenda'),
                                \nav_item('/anamnese', 'Anamnese'),
                                \nav_item('/paciente', 'Paciente'),
                                \nav_item('/convenio', 'Convenio')
                              ]) ])
                   ])
             ]) ).


nav_item(Link, Rotulo) -->
    html(li([ class='nav-item'],
            [ a([class='nav-link m-1 menu-item', href=Link], Rotulo) ])).