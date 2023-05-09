-- #1 --
select "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД", "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
from "Н_ТИПЫ_ВЕДОМОСТЕЙ"
join "Н_ВЕДОМОСТИ" on "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" = "Н_ВЕДОМОСТИ"."ВЕД_ИД"
where "Н_ТИПЫ_ВЕДОМОСТЕЙ"."НАИМЕНОВАНИЕ" > 'Ведомость' and "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" < 163249 and "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" > 142390;

-- #2 --
select "Н_ЛЮДИ"."ИМЯ", "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД", "Н_УЧЕНИКИ"."НАЧАЛО"
from "Н_ЛЮДИ"
right join "Н_ОБУЧЕНИЯ" on "Н_ЛЮДИ"."ИД" = "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД"
right join "Н_УЧЕНИКИ" on "Н_ОБУЧЕНИЯ"."ВИД_ОБУЧ_ИД" = "Н_УЧЕНИКИ"."ИД"
where "Н_ЛЮДИ"."ОТЧЕСТВО" > 'Сергеевич' and "Н_ОБУЧЕНИЯ"."НЗК" < '933232';

-- #3 --
select case when count(*) > 0 then 'Среди студентов вечерней формы обучения есть люди без ИНН.' -- Такой студент 1 --
    else 'Среди студентов вечерней формы обучения есть люди без ИНН.' end as результат
from "Н_ФОРМЫ_ОБУЧЕНИЯ" ф
join "Н_ПЛАНЫ" п on ф."ИД" = п."ФО_ИД"
join "Н_УЧЕНИКИ" у on п."ИД" = у."ПЛАН_ИД"
join "Н_ОБУЧЕНИЯ" о on у."ИД" = о."ЧЛВК_ИД"
join "Н_ЛЮДИ" л on о."ЧЛВК_ИД" = л."ИД"
where ф."НАИМЕНОВАНИЕ" = 'Очно-заочная(вечерняя)'
and л."ИНН" is null;

-- #4 --
SELECT ОТЧЕСТВО, COUNT(*) AS count
FROM Н_ЛЮДИ
join "Н_ОБУЧЕНИЯ" on "ЧЛВК_ИД" = Н_ЛЮДИ.ИД
JOIN Н_УЧЕНИКИ ON "Н_ОБУЧЕНИЯ".ЧЛВК_ИД = Н_УЧЕНИКИ.ЧЛВК_ИД
JOIN Н_ПЛАНЫ ON Н_УЧЕНИКИ.ПЛАН_ИД = Н_ПЛАНЫ.ИД
join "Н_ОТДЕЛЫ" on Н_ПЛАНЫ.ИД = "Н_ОТДЕЛЫ".ИД
WHERE Н_ОТДЕЛЫ.КОРОТКОЕ_ИМЯ = 'КТиУ'
GROUP BY Н_ЛЮДИ.ОТЧЕСТВО;

-- №5 --
WITH max_score AS (
SELECT MAX(CASE l."ОЦЕНКА" WHEN 'зачет' THEN 5 WHEN 'незач' THEN 2 END) AS max_score
FROM "Н_УЧЕНИКИ" st
INNER JOIN "Н_ОБУЧЕНИЯ" ed ON ed."ЧЛВК_ИД" = st."ЧЛВК_ИД"
INNER JOIN "Н_ВЕДОМОСТИ" l ON l."ЧЛВК_ИД" = ed."ЧЛВК_ИД"
WHERE st."ГРУППА" = '3100'
)
SELECT
st."ИД",
concat(p."ФАМИЛИЯ", ' ', p."ИМЯ", ' ', p."ОТЧЕСТВО") AS "ФИО",
avg(CASE l."ОЦЕНКА" WHEN 'зачет' THEN 5 WHEN 'незач' THEN 2 END) AS "Ср_оценка"
FROM "Н_УЧЕНИКИ" st
INNER JOIN "Н_ОБУЧЕНИЯ" ed ON ed."ЧЛВК_ИД" = st."ЧЛВК_ИД"
INNER JOIN "Н_ЛЮДИ" p ON p."ИД" = ed."ЧЛВК_ИД"
INNER JOIN "Н_ВЕДОМОСТИ" l ON l."ЧЛВК_ИД" = p."ИД"
WHERE st."ГРУППА" = '4100'
GROUP BY st."ИД", p."ФАМИЛИЯ", p."ИМЯ", p."ОТЧЕСТВО"
HAVING avg(CASE l."ОЦЕНКА" WHEN 'зачет' THEN 5 WHEN 'незач' THEN 2 END) <= (
SELECT max_score.max_score FROM max_score
)
ORDER BY st."ИД";


-- for tests --
select * from "Н_УЧЕНИКИ";
select * from "Н_ОБУЧЕНИЯ";
select * from "Н_ЛЮДИ";
select * from "Н_ФОРМЫ_ОБУЧЕНИЯ";
select * from "Н_КВАЛИФИКАЦИИ";
select * from "Н_ПЛАНЫ";
select * from "Н_ОТДЕЛЫ";
