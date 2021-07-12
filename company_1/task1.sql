/*
 Дана таблица с полем, содержащим ряд чисел от 1 до 100
 Для каждого числа вывести количество чисел, меньших текущего
 Числа могу повторяться
 */


-- create table digits (digit integer);
--
-- insert into digits (digit) values(1);
-- insert into digits (digit) values(10);
-- insert into digits (digit) values(100);
-- insert into digits (digit) values(15);
-- insert into digits (digit) values(5);
-- insert into digits (digit) values(20);
-- insert into digits (digit) values(25);
-- insert into digits (digit) values(10);
-- insert into digits (digit) values(35);
-- insert into digits (digit) values(40);
-- insert into digits (digit) values(45);
-- insert into digits (digit) values(55);

select digit,
       (select count(digit) quantity
        from digits d2
        where d1.digit > d2.digit)
from digits d1;
