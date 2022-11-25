{{ 
    config(
        materialized='table', 
        sort='date_day',
        dist='date_day',
        pre_hook="alter session set timezone = 'Europe/Madrid'; alter session set week_start = 7;" 
        ) }}

with date as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2021-01-01' as date)",
        end_date="cast('2022-01-01' as date)"
    )
    }}  
)


select
      year(date_day)*10000+month(date_day)*100+day(date_day) as id_date
    , date_day as fecha_forecast
    , year(date_day) as anio
    , month(date_day) as mes
    , monthname(date_day) as desc_mes
    , year(date_day)*100+month(date_day) as id_anio_mes

from date
order by
    date_day ASC