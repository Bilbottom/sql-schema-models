
SELECT
    year_number,
    MAX(IIF(month_number = 3,  full_date, '1900-01-01') || ' 01:00:00') AS dst_start_time_utc,
    MAX(IIF(month_number = 10, full_date, '1900-01-01') || ' 01:00:00') AS dst_end_time_utc
FROM dates
WHERE day_of_the_week = 1  /* Sunday = 1, Saturday = 7 */
GROUP BY year_number
ORDER BY year_number
;
