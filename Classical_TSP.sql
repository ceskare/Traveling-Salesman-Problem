CREATE TABLE tours_prices
(
    point1 CHAR,
    point2 CHAR,
    cost   INT
);

INSERT INTO tours_prices
VALUES ('a', 'b', 10),
       ('a', 'c', 15),
       ('a', 'd', 20),
       ('b', 'a', 10),
       ('b', 'c', 35),
       ('b', 'd', 25),
       ('c', 'a', 15),
       ('c', 'b', 35),
       ('c', 'd', 30),
       ('d', 'a', 20),
       ('d', 'b', 25),
       ('d', 'c', 30);

WITH RECURSIVE
    travel AS (SELECT point2,
                      '{' || point1 AS tour,
                      cost          AS total_cost,
                      1             AS visited
               FROM tours_prices
               WHERE point1 = 'a'
               UNION
               SELECT tours_prices.point2,
                      travel.tour || ',' || tours_prices.point1 AS tour,
                      travel.total_cost + tours_prices.cost     AS total_cost,
                      travel.visited + 1
               FROM tours_prices
                        INNER JOIN travel ON tours_prices.point1 = travel.point2
               WHERE tour NOT LIKE '%' || tours_prices.point1 || '%'),
    result AS (SELECT total_cost,
                      tour || ',' || travel.point2 || '}' AS tour
               FROM travel
               WHERE visited = 4
                 AND travel.point2 = 'a')
SELECT *
FROM result
WHERE total_cost = (SELECT MIN(total_cost)
                    FROM result)
ORDER BY total_cost, tour;