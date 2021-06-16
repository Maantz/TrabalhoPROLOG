created(1623872739.568004).
assert(paciente(4,"teste","123")).
retract(paciente(4,"teste","123")).
assert(paciente(4,"teste","1234")).
retractall(paciente(4,_,_),1).
