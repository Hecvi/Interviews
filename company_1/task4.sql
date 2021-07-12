/*
 Поле color таблицы t содержит всего три значения red, green, blue,
 которые могут повторяться сколько угодно раз Написать запрос, который
 формирует вывод вида:
 red|green|blue
 100| 200| 500
 */

-- create table t (color varchar2(8));
--
-- insert into t values('green');
-- insert into t values('green');
-- insert into t values('green');
-- insert into t values('red');
-- insert into t values('red');
-- insert into t values('blue');
-- insert into t values('blue');
-- insert into t values('blue');
-- insert into t values('blue');

with t1 as (
    select count(color) as red
    from t
    where color = 'red'),
     t2 as (
         select count(color) as green
         from t
         where color = 'green'),
     t3 as (
         select count(color) as blue
         from t
         where color = 'blue')
select red,
       green,
       blue
from t1,
     t2,
     t3;
