create table Clients
(
    Id_client   smallserial,
    Last_name   varchar(32),
    First_name  varchar(32),
    Middle_name varchar(32),
    Birth_date  date,
    Mobile_num  varchar(32)
);

create table Payments
(
    id_client    smallserial,
    pay_date     date,
    pay_sum      integer,
    pay_currency varchar(8),
    pay_sum_rur  integer
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

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (1,
        to_date('11.12.2020', 'DD.MM.YYYY'),
        161,
        'RUR',
        161);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (2,
        to_date('02.01.2021', 'DD.MM.YYYY'),
        690,
        'RUR',
        690);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (2,
        to_date('03.01.2021', 'DD.MM.YYYY'),
        259,
        'RUR',
        259);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (1,
        to_date('14.01.2021', 'DD.MM.YYYY'),
        146,
        'USD',
        10220);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (3,
        to_date('05.12.2020', 'DD.MM.YYYY'),
        450,
        'RUR',
        450);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (3,
        to_date('06.01.2021', 'DD.MM.YYYY'),
        1034,
        'RUR',
        1034);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (4,
        to_date('07.03.2021', 'DD.MM.YYYY'),
        153,
        'EUR',
        13770);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (4,
        to_date('15.04.2021', 'DD.MM.YYYY'),
        174,
        'RUR',
        174);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (5,
        to_date('08.01.2021', 'DD.MM.YYYY'),
        180,
        'RUR',
        180);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (5,
        to_date('09.05.2021', 'DD.MM.YYYY'),
        105,
        'USD',
        7350);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (1,
        to_date('10.05.2021', 'DD.MM.YYYY'),
        186,
        'RUR',
        186);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (4,
        to_date('11.06.2021', 'DD.MM.YYYY'),
        123,
        'RUR',
        123);

insert into Payments (id_client,
                      pay_date,
                      pay_sum,
                      pay_currency,
                      pay_sum_rur)
values (6,
        to_date('12.06.2021', 'DD.MM.YYYY'),
        129,
        'RUR',
        129);

create table data_mart as
select pay.id_client,
       count(pay.id_client) Trx_cnt,
       sum(pay_sum_rur)     Trx_sum_rur
from Payments pay
         left join Clients
                   on pay.id_client = Clients.Id_client
where Birth_date + Interval '20' year < current_date
  and pay_date between to_date('01.01.2021', 'DD.MM.YYYY') and to_date('31.05.2021', 'DD.MM.YYYY')
group by pay.id_client
having sum(pay_sum_rur) > 1000;
