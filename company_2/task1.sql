create table Clients
(
    Id_client   smallserial,
    Last_name   varchar(32),
    First_name  varchar(32),
    Middle_name varchar(32),
    Birth_date  date,
    Mobile_num  varchar(32)
);

insert into Clients (Id_client,
                     Last_name,
                     First_name,
                     Middle_name,
                     Birth_date,
                     Mobile_num)
values (1,
        'Иванов',
        'Иван',
        'Иванович',
        to_date('01.05.1965', 'DD.MM.YYYY'),
        '79009334567');

insert into Clients (Id_client,
                     Last_name,
                     First_name,
                     Middle_name,
                     Birth_date,
                     Mobile_num)
values (2,
        'Петров',
        'Петр',
        'Петрович',
        to_date('16.09.2000', 'DD.MM.YYYY'),
        '+79013214151');

insert into Clients (Id_client,
                     Last_name,
                     First_name,
                     Middle_name,
                     Birth_date,
                     Mobile_num)
values (3,
        'Сидоров',
        'Сидр',
        'Сидорович',
        to_date('05.11.1951', 'DD.MM.YYYY'),
        '89009876543');

insert into Clients (Id_client,
                     Last_name,
                     First_name,
                     Middle_name,
                     Birth_date,
                     Mobile_num)
values (4,
        'Смирнов',
        'Роман',
        'Юрьевич',
        to_date('23.03.1935', 'DD.MM.YYYY'),
        '8 933 654 73 73');

insert into Clients (Id_client,
                     Last_name,
                     First_name,
                     Middle_name,
                     Birth_date,
                     Mobile_num)
values (5,
        'Пчелкин',
        'Илья',
        'Александрович',
        to_date('12.06.2001', 'DD.MM.YYYY'),
        '92464456');

/*
 Объяснение по поводу текущего возраста. У меня есть возможность получить количество дней, как разность текущей даты и
 даты рождения. Если бы в году было 365 дней, то задача решалась бы элементарно, путем деления на 365 дней. Но у нас
 существуют високосные года и тогда, при делении, мы теряем точность. Решение выглядит сложно, но это один из самых
 точных способов получения нужного нам результата. Мы считаем полное количество лет между двумя датами, оставляя про
 запас один год (позже объясню зачем) Пример: вместо 2021 используем 01.01.2020 - 01.01.1965. Итого: 55 лет.
 Теперь считаем сколько дней у нас от начала каждой из этих дат, до текущей и дня рождения соответственно.
 К первому количеству дней прибавляем количество дней из прошлого года. Вычисляем разность дней. Если у нас текущие
 месяц и дата были меньше, чем месяц и дата рождения, то мы просто делим количество дней (они получаются меньше
 количества дней в году) на 365.25 (на какое число делить - это единственный момент, который стоит обговорить), если
 текущий месяц и дата были больше, то мы вычитаем из них количество дней из заимствованного предыдущего года (при этом
 добавляем год, то есть теперь человеку 56 лет) и также делим на 365.25. Получается некое дробное число, например 0,76.
 Прибаляем к нему 56
*/

-- По поводу номеров телефонов: невалидные я не трогаю --

select Id_client,
       upper(Last_name)   as                                                     Last_name,
       upper(First_name)  as                                                     First_name,
       upper(Middle_name) as                                                     Middle_name,
       Birth_date,
       case
           when length(replace(replace(Mobile_num, '+', ''), ' ', '')) = 11
               then '7' || substring(replace(replace(Mobile_num, '+', ''), ' ', ''), 2, length(Mobile_num))
           else Mobile_num
           end            as                                                     Mobile_num,
       upper(Last_name) || ' ' || upper(First_name) || ' ' || upper(Middle_name) full_name,
       case
           when current_date - to_date('01.01.' || (extract(year from current_date) - 1), 'DD.MM.YYYY') -
                (Birth_date - to_date('01.01.' || (extract(year from Birth_date)), 'DD.MM.YYYY')) >=
                to_date('31.12.' || (extract(year from current_date) - 1), 'DD.MM.YYYY') -
                to_date('01.01.' || (extract(year from current_date) - 1), 'DD.MM.YYYY')
               then round(
                   cast((current_date - to_date('01.01.' || (extract(year from current_date) - 1), 'DD.MM.YYYY') -
                         (Birth_date - to_date('01.01.' || (extract(year from Birth_date)), 'DD.MM.YYYY')) -
                         (to_date('31.12.' || (extract(year from current_date) - 1), 'DD.MM.YYYY') -
                          to_date('01.01.' || (extract(year from current_date) - 1), 'DD.MM.YYYY'))) / 365.25 +
                        extract(year from current_date) - extract(year from Birth_date) as decimal), 2)
           else round(cast((current_date - to_date('01.01.' || (extract(year from current_date) - 1), 'DD.MM.YYYY') -
                            (Birth_date - to_date('01.01.' || (extract(year from Birth_date)), 'DD.MM.YYYY'))) /
                           365.25 +
                           extract(year from current_date) - 1 - extract(year from Birth_date) as decimal), 2)
           end            as                                                     age
from Clients
where Birth_date + interval '20' year < current_date
  and Birth_date + interval '70' year >= current_date;

