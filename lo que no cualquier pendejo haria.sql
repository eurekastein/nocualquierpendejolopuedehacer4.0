update ciudades set grado_carretera = j.count
from
(select h.id_c, count(h.nombre)
from
(select gu.id_c, nombre
from
(select c.id as id_c, rp.id, rp.geom, rp.nombre, rp.codigo from red_primaria as rp
join ciudades as c
on st_crosses (rp.geom, c.geom)) as gu 
group by nombre, id_c ) as h
group by id_c) as j
where ciudades.id = j.id_c



update parques_industriales set grado_ferrocarril=g.cnt
from
(select f.id_parque, c.cnt
from 
(select p.id as id_parque, (
select n.id 
from via_ferrea_vertices_pgr As n
order by p.geom <-> n.the_geom LIMIT 1
)as closest_node 
from  
(select * from parques_industriales 
where grado_ferrocarril is null ) as p ) as f
join via_ferrea_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_parque = parques_industriales.id

update parques_industriales set grado_total = grado_carretera + grado_ferrocarril
