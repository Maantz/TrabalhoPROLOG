created(1623872739.572004).
assert(dentista(10,"aaaaa")).
retract(dentista(10,"aaaaa")).
assert(dentista(10,"aaaa")).
retractall(dentista(10,_),1).
