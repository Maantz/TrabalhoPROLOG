created(1623868295.012634).
assert(dentista(10,"aaaaa")).
retract(dentista(10,"aaaaa")).
assert(dentista(10,"aaaa")).
retractall(dentista(10,_),1).
