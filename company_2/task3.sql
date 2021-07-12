create table dep_agreement
(
    sk             integer,
    agrmnt_id      integer,
    actual_from_dt date,
    actual_to_dt   date,
    client_id      varchar2(8),
    product_id     varchar2(8),
    interest_rate  varchar2(8),
    card_id        varchar2(8)
);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (1,
        101,
        to_date('01.01.2015', 'DD.MM.YYYY'),
        to_date('20.02.2015', 'DD.MM.YYYY'),
        20,
        305,
        '3.5%',
        402);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (2,
        101,
        to_date('21.02.2015', 'DD.MM.YYYY'),
        to_date('17.05.2015', 'DD.MM.YYYY'),
        20,
        345,
        '4%',
        402);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (3,
        101,
        to_date('18.05.2015', 'DD.MM.YYYY'),
        to_date('05.07.2015', 'DD.MM.YYYY'),
        20,
        345,
        '4%',
        402);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (4,
        101,
        to_date('06.07.2015', 'DD.MM.YYYY'),
        to_date('22.08.2015', 'DD.MM.YYYY'),
        20,
        539,
        '6%',
        308);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (5,
        101,
        to_date('23.08.2015', 'DD.MM.YYYY'),
        to_date('31.12.9999', 'DD.MM.YYYY'),
        20,
        345,
        '4%',
        402);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (6,
        102,
        to_date('01.01.2016', 'DD.MM.YYYY'),
        to_date('30.06.2016', 'DD.MM.YYYY'),
        25,
        333,
        '3.7%',
        108);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (7,
        102,
        to_date('01.07.2016', 'DD.MM.YYYY'),
        to_date('25.07.2016', 'DD.MM.YYYY'),
        25,
        333,
        '3.7%',
        108);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (8,
        102,
        to_date('26.07.2016', 'DD.MM.YYYY'),
        to_date('15.09.2016', 'DD.MM.YYYY'),
        25,
        333,
        '3.7%',
        108);

insert into dep_agreement (sk,
                           agrmnt_id,
                           actual_from_dt,
                           actual_to_dt,
                           client_id,
                           product_id,
                           interest_rate,
                           card_id)
values (9,
        102,
        to_date('16.09.2016', 'DD.MM.YYYY'),
        to_date('31.12.9999', 'DD.MM.YYYY'),
        25,
        560,
        '5.9%',
        102);


/*
Во внутреннем запросе через оконные функции я создаю поля, которые будут брать предыдущие строки полей.
Оконные функции нужны, чтобы отсортировать строки по группам (agrmnt_id) и по времени (actual_from_dt).
Coalesce использую, чтобы первое поле, которое не существует заменилось на пробел, например.
Во внешнем запросе помимо прочего создаю поле actual_to_dt, так как старое отбросил. Оно будет брать
следующий actual_from_dt и отнимать один день. Если следующего actual_from_dt нет, то создаю дату
31.12.9999. Ну и самое главное: сравниваю текущие поля с предыдущими и, если они одинаковые, отбрасываю
P.s. использовал синтаксис Oracle
P.p.s. в одной из строк поля actual_to_dt было значение 31.12.999. Счел его значением 31.12.9999
*/

create table agrmnt_compacted as
select sk,
       agrmnt_id,
       actual_from_dt,
       coalesce(lead(actual_from_dt) over (partition by agrmnt_id order by actual_from_dt) - interval '1' day,
                to_date('31.12.9999', 'DD.MM.YYYY')) as actual_to_dt,
       client_id,
       product_id,
       interest_rate,
       card_id
from (
         select sk,
                agrmnt_id,
                actual_from_dt,
                client_id,
                product_id,
                interest_rate,
                card_id,
                coalesce(lag(client_id) over (partition by agrmnt_id order by actual_from_dt),
                         cast(' ' as char(1))) as prev_client_id,
                coalesce(lag(product_id) over (partition by agrmnt_id order by actual_from_dt),
                         cast(' ' as char(1))) as prev_product_id,
                coalesce(lag(interest_rate) over (partition by agrmnt_id order by actual_from_dt),
                         cast(' ' as char(1))) as prev_interest_rate,
                coalesce(lag(card_id) over (partition by agrmnt_id order by actual_from_dt),
                         cast(' ' as char(1))) as prev_card_id
         from dep_agreement)
where client_id <> prev_client_id
   or product_id <> prev_product_id
   or interest_rate <> prev_interest_rate
   or card_id <> prev_card_id;
