created(1623818085.655337).
assert(chave(usuario,9)).
assert(chave(paciente,1)).
assert(chave(schedule,1)).
assert(chave(anamnese,1)).
assert(chave(usuario,10)).
retractall(chave(usuario,_),1).
assert(chave(usuario,11)).
