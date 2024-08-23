import { readFileSync, writeFileSync} from 'fs'

const order = [
  "instrucciones/DDL+drop.sql",
  "instrucciones/relationsInsertFile.sql",
  "Vistas/VISTA_1.sql",
  "Vistas/VISTA_2.sql",
  "Vistas/VISTA_3.sql",
  "Vistas/VISTA_4.sql",
  "Vistas/VISTA_5.sql",
  "Vistas/VISTA_6.sql",
  "Vistas/VISTA_7.sql",
  "instrucciones/Privileges.sql"
]

let fileContent = ""

for(let i in order) {
  const path = order[i]

  fileContent += "-- Inicio " + path + "\n"
  fileContent += "  " + readFileSync(path, 'utf-8').trim().split("\n").join("\n  ") + "\n"
  fileContent += "-- Fin " + path + "\n" + "\n"
}

writeFileSync('query.sql', fileContent, 'utf-8')