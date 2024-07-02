WITH

direct_flights AS (
    SELECT
        f.start_time,
        f.end_time,
        EXTRACT(EPOCH FROM (f.end_time - f.start_time)) / 60 AS flight_time
    FROM flights f
    JOIN airports a1 ON f.start_port = a1.port_code
    JOIN airports a2 ON f.end_port = a2.port_code
    WHERE a1.city_name = 'New York' AND a2.city_name = 'Tokyo'
),

transit_flights AS (
    SELECT
        f1.start_time AS first_leg_start,
        f2.end_time AS second_leg_end,
        EXTRACT(EPOCH FROM (f1.end_time - f1.start_time)) / 60 + 
        EXTRACT(EPOCH FROM (f2.end_time - f2.start_time)) / 60 + 
        EXTRACT(EPOCH FROM (f2.start_time - f1.end_time)) / 60 AS flight_time
    FROM flights f1
    JOIN flights f2 ON f1.end_port = f2.start_port
    JOIN airports a1 ON f1.start_port = a1.port_code
    JOIN airports a2 ON f2.end_port = a2.port_code
    JOIN airports a3 ON f1.end_port = a3.port_code
    WHERE a1.city_name = 'New York' 
      AND a2.city_name = 'Tokyo' 
      AND a3.city_name NOT IN ('New York', 'Tokyo')
      AND f1.end_time <= f2.start_time
),

all_flights AS (
    SELECT flight_time FROM direct_flights
    UNION ALL
    SELECT flight_time FROM transit_flights
)

SELECT MIN(flight_time)
FROM all_flights;