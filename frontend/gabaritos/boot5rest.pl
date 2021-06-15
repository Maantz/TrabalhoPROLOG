:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).


:-multifile
    user:body//2.


user:body(bootstrap, Corpo) -->
       html(body([ \html_post(head,
                              [ meta([name(viewport),
                                      content(['width=device-width, initial-scale=1', 'shrink-to-fit=no'])])]),
                   \html_root_attribute(lang,'pt-br'),
                   \html_requires(css('bootstrap.min.css')),
                   \html_requires(js('rest.js')),

                   Corpo,

                   script([ src('js/bootstrap.bundle.min.js'),
                            type('text/javascript')], [])
                 ])
            ).