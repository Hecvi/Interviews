/*
 Даны две таблицы. В обеих поле id содержит уникальные целые числа
 Напишите три способа выборки записей из 1-й таблицы исключающей значения
 по полю id содержащиеся во 2-й таблице
*/

-- create table first (id integer, val1 integer);
-- create table second (id integer, val2 integer);
--
-- insert into first (id, val1) values (1, 11);
-- insert into first (id, val1) values (2, 13);
-- insert into first (id, val1) values (3, 16);
-- insert into first (id, val1) values (4, 19);
-- insert into first (id, val1) values (5, 21);
-- insert into first (id, val1) values (6, 100);
-- insert into first (id, val1) values (7, 85);
-- insert into first (id, val1) values (8, 99);
-- insert into first (id, val1) values (9, 30);
-- insert into first (id, val1) values (10, 48);
--
-- insert into second (id, val2) values (1, 48);
-- insert into second (id, val2) values (2, 56);
-- insert into second (id, val2) values (3, 99);
-- insert into second (id, val2) values (4, 2342);
-- insert into second (id, val2) values (5, 43);

select f.id,
       val1
from first f
         left join second s
                   on f.id = s.id
where s.id is null;

select *
from first
where id not in (select id from second);

select *
from first
where id in (select id
             from first
                 except
             select id
             from second);

select *
from first
where id not in (select id
                 from first
                 intersect
                 select id
                 from second);
