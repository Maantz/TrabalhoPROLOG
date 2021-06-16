created(1623868295.007634).
assert(paciente(4,"teste","123")).
retract(paciente(4,"teste","123")).
assert(paciente(4,"teste","1234")).
retractall(paciente(4,_,_),1).
