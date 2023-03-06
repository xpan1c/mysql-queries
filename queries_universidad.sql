-- Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM universidad.persona ORDER BY apellido1, apellido2, nombre ASC;
-- Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 FROM universidad.persona WHERE telefono IS NULL;
-- Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM universidad.persona WHERE YEAR(fecha_nacimiento) >= 1999;
-- Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT * FROM universidad.persona WHERE tipo = 'profesor' AND telefono IS NULL AND RIGHT(nif, 1) = 'k'; 
-- Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * FROM universidad.asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;
-- Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT apellido1, apellido2, nombre, pr.id_departamento FROM universidad.persona p JOIN universidad.profesor pr ON p.id = pr.id_profesor ORDER BY apellido1, apellido2, nombre ASC;
-- Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre, anyo_inicio, anyo_fin FROM universidad.alumno_se_matricula_asignatura am JOIN persona p ON am.id_alumno = p.id JOIN universidad.asignatura a ON am.id_asignatura = a.id JOIN universidad.curso_escolar c ON am.id_curso_escolar = c.id WHERE p.nif = '26902806M';
-- Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre FROM universidad.asignatura a JOIN universidad.profesor p ON a.id_profesor = p.id_profesor JOIN universidad.grado g ON a.id_grado = g.id JOIN universidad.departamento d ON p.id_departamento = d.id WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';
-- Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT apellido1, apellido2, nombre FROM universidad.alumno_se_matricula_asignatura a JOIN universidad.persona p ON a.id_alumno = p.id JOIN universidad.curso_escolar c ON a.id_curso_escolar = c.id WHERE YEAR(c.anyo_inicio) = 2018;
-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT d.nombre departamento, apellido1, apellido2, p.nombre FROM universidad.persona p LEFT JOIN universidad.profesor pr ON p.id = pr.id_profesor LEFT JOIN universidad.departamento d ON pr.id_departamento = d.id ORDER BY d.nombre, apellido1, apellido2, p.nombre ASC;
-- Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT apellido1, apellido2, p.nombre FROM universidad.persona p LEFT JOIN universidad.profesor pr ON p.id = pr.id_profesor LEFT JOIN universidad.departamento d ON pr.id_departamento = d.id WHERE d.nombre IS NOT NULL ORDER BY d.nombre, apellido1, apellido2, p.nombre ASC;
-- Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.nombre departamento FROM universidad.persona p RIGHT JOIN universidad.profesor pr ON p.id = pr.id_profesor RIGHT JOIN universidad.departamento d ON pr.id_departamento = d.id WHERE p.id IS NULL ORDER BY d.nombre ASC;
-- Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT p.apellido1, p.apellido2, p.nombre FROM universidad.persona p LEFT JOIN universidad.profesor pr ON p.id = pr.id_profesor LEFT JOIN universidad.asignatura a ON  pr.id_profesor = a.id_profesor WHERE a.id_profesor IS NULL;  
-- Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT a.nombre FROM universidad.asignatura a LEFT JOIN universidad.profesor pr ON a.id_profesor = pr.id_profesor WHERE a.id_profesor IS NULL;  
-- Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT d.nombre FROM universidad.departamento d LEFT JOIN universidad.profesor pr ON d.id = pr.id_departamento LEFT JOIN universidad.asignatura a ON pr.id_profesor = a.id_profesor WHERE a.id_profesor IS NULL;  
-- Consultes resum:

-- Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) total_alumnos FROM universidad.persona p WHERE p.tipo = 'alumno';  
-- Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) nacidos_1999 FROM universidad.persona p WHERE p.tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;  
-- Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nombre, COUNT(pr.id_profesor) num_profesores FROM universidad.departamento d JOIN universidad.profesor pr ON d.id = pr.id_departamento GROUP BY pr.id_departamento ORDER BY num_profesores DESC;
-- Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nombre, COUNT(pr.id_profesor) num_profesores FROM universidad.departamento d LEFT JOIN universidad.profesor pr ON d.id = pr.id_departamento GROUP BY pr.id_departamento ORDER BY num_profesores DESC;
-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures. 
SELECT g.nombre, COUNT(a.id) total_asignaturas FROM universidad.asignatura a RIGHT JOIN universidad.grado g ON g.id = a.id_grado GROUP BY g.id ORDER BY total_asignaturas DESC;   
-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre, COUNT(a.id) total_asignaturas FROM universidad.asignatura a RIGHT JOIN universidad.grado g ON g.id = a.id_grado GROUP BY g.id HAVING total_asignaturas >= 40 ORDER BY total_asignaturas DESC;   
-- Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT g.nombre, a.tipo, SUM(a.creditos) total_creditos FROM universidad.asignatura a JOIN universidad.grado g ON g.id = a.id_grado GROUP BY g.id, a.tipo ORDER BY total_creditos DESC;   
-- Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
-- Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
-- Retorna totes les dades de l'alumne/a més jove.
-- Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.