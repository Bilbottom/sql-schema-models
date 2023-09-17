
-- https://simplemaps.com/data/world-cities


DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
    city_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    city_name TEXT NOT NULL /*UNIQUE*/,
    city_name_ascii TEXT NOT NULL /*UNIQUE*/,
    country_id INTEGER NOT NULL REFERENCES countries(country_id),
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    capital TEXT,
    population INTEGER  /* As at March 2022 */
);


-- INSERT INTO cities(city_name, city_name_ascii, country_id, latitude, longitude, capital, population)
--     SELECT
--         wc.city,
--         wc.city_ascii,
--         cm.country_id,
--         wc.lat,
--         wc.lng,
--         wc.capital,
--         wc.population
--     FROM worldcities AS wc
--         LEFT JOIN country_mapping AS cm
--             ON wc.country = cm.country_in_worldcities
--     ORDER BY
--         cm.country_id,
--         wc.city
-- ;
