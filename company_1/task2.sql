/*
 Вывести отношение суммы квадратов разницы каждого числа и среднего
 всех чисел к количеству чисел c помощью оконных функций и подзапроса
 Формула должна быть такой: (Xср - X)^2 / Количество_строк
*/

-- create table tab (x integer);
--
-- insert into tab (x) values (1);
-- insert into tab (x) values (2);
-- insert into tab (x) values (3);
-- insert into tab (x) values (4);
-- insert into tab (x) values (5);

select sum(pow_avg_x_div)
from (select power(avg(x) over (order by x rows between unbounded preceding and unbounded following) - x, 2) /
             count(x) over (order by x rows between unbounded preceding and unbounded following) pow_avg_x_div
      from tab);
