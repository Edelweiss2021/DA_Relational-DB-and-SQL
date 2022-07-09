select top 3 * 
from nyc_sample_data_for_sql_sep_2015

-- Q1
select max(Total_amount) as Mx
from nyc_sample_data_for_sql_sep_2015
--Q2
select max(Total_amount/Trip_distance)
from nyc_sample_data_for_sql_sep_2015
where Trip_distance <> 0
--Q3
select *
from nyc_sample_data_for_sql_sep_2015
where Tip_amount = (select MAX(Tip_amount) as mxtip from nyc_sample_data_for_sql_sep_2015)
--Q4
select max(DATEDIFF(ms,lpep_pickup_datetime ,Lpep_dropoff_datetime))
from nyc_sample_data_for_sql_sep_2015
--Q5
select distinct datepart(hh,lpep_pickup_datetime), round(avg(Tip_amount) OVER (PARTITION by  datepart(hh,lpep_pickup_datetime)),2,2)
from nyc_sample_data_for_sql_sep_2015
order by 1
--Q7
select day_of_week, avg(tot_trip)
from (select distinct cast(lpep_pickup_datetime as date) date_
    ,DATEname(dw, lpep_pickup_datetime) day_of_week
    ,count(trip_id) over(PARTITION by DATEPART(dd, lpep_pickup_datetime)) tot_trip
from nyc_sample_data_for_sql_sep_2015) cnt
GROUP by day_of_week
--Q8
select distinct DATEPART(hh, lpep_pickup_datetime),count(trip_id) OVER(PARTITION by datepart(hh,lpep_pickup_datetime))
from nyc_sample_data_for_sql_sep_2015
--Q9
select avg(Passenger_count)
from nyc_sample_data_for_sql_sep_2015
--Q10
select distinct datepart(hh,lpep_pickup_datetime), AVG(Passenger_count) OVER(PARTITION by datepart(hh,lpep_pickup_datetime))
from nyc_sample_data_for_sql_sep_2015
--Q11
select distinct 
    case when RateCodeID = '1' then 'Standart Rate'
        when RateCodeID = '2' then 'JFK'
        when RateCodeID = '3' then 'Newark'
        when RateCodeID = '4' then 'Nassau or Westchester'
        when RateCodeID = '5' then 'Negoatiated Fare'
        when RateCodeID = '6' then 'Group Ride'
    end as RateCodeID,sum(Passenger_count) OVER(PARTITION by RateCodeID)
from nyc_sample_data_for_sql_sep_2015
where RateCodeID = 2 or RateCodeID = 3
--Q12
select sum(case when Total_amount is null then 1 else 0 end) count_nulls
from nyc_sample_data_for_sql_sep_2015
--
select COUNT(Total_amount)
from nyc_sample_data_for_sql_sep_2015
where Total_amount is null
--Q13
select sum(case when Trip_distance is not null then 1 else 0 end)
from nyc_sample_data_for_sql_sep_2015
--
select count(Trip_distance)
from nyc_sample_data_for_sql_sep_2015
where Trip_distance is not null
--Q14
select sum(case when Ehail_fee is null then 1 else 0 end)
from nyc_sample_data_for_sql_sep_2015
--
select count(Ehail_fee)
from nyc_sample_data_for_sql_sep_2015
where Ehail_fee is null
--
select count(*)
from (select Ehail_fee cnt
from nyc_sample_data_for_sql_sep_2015
where Ehail_fee is null
) dfs
--Q15
select *
from nyc_sample_data_for_sql_sep_2015
where Trip_distance <= 0.1 or Trip_distance >= 15
--
select *
from nyc_sample_data_for_sql_sep_2015
where Trip_distance <= 0.1
UNION ALL
select *
from nyc_sample_data_for_sql_sep_2015
WHERE Trip_distance >= 15
--
select Payment_Range_in_Dollars, COUNT(Total_amount)
from (select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
                    Total_amount
from nyc_sample_data_for_sql_sep_2015) fsa
GROUP by Payment_Range_in_Dollars
order by 1 

with cte as(select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
                    Total_amount
from nyc_sample_data_for_sql_sep_2015
) 
select Payment_Range_in_Dollars, sum(Total_amount) 
from cte
GROUP by Payment_Range_in_Dollars
order by 1
--Q17
select driver_id, Payment_Range_in_Dollars, count(*)
from (select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
                    Total_amount , driver_id
from nyc_sample_data_for_sql_sep_2015) aagf
group by driver_id, Payment_Range_in_Dollars
order by 1
--
WITH vte as (select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
                    Total_amount , driver_id
from nyc_sample_data_for_sql_sep_2015
)
select driver_id, Payment_Range_in_Dollars, COUNT(Total_amount)
from vte
GROUP by driver_id, Payment_Range_in_Dollars
order by 1 
--Q18
select *, sum(Total_amount) OVER(PARTITION by driver_id )
from (select driver_id ,total_amount, RANK() OVER(PARTITION by driver_id order by Total_amount desc) rnk
from nyc_sample_data_for_sql_sep_2015) aaf
where rnk <=3
--Q19
select *, sum(Total_amount) OVER(PARTITION by driver_id )
from (select trip_id,driver_id ,total_amount, RANK() OVER(PARTITION by driver_id order by Total_amount asc) rnk
from nyc_sample_data_for_sql_sep_2015) aaf
where rnk <=3
--Q20
select distinct top 10 Total_amount
from nyc_sample_data_for_sql_sep_2015
where driver_id = 1
order by Total_amount asc
--
select *
from(select Total_amount,driver_id, RANK() OVER(PARTITION by driver_id order by total_amount) rnk
from nyc_sample_data_for_sql_sep_2015) ffs 
where rnk <= 10 and driver_id = 1
--
select *
from(select Total_amount,driver_id, dense_RANK() OVER(PARTITION by driver_id order by total_amount) rnk
from nyc_sample_data_for_sql_sep_2015) ffs 
where rnk <= 10 and driver_id = 1
--Q21
SELECT lpep_pickup_datetime, Total_amount, Passenger_count, 
        sum(Total_amount) OVER(PARTITION by driver_id order by lpep_pickup_datetime) cumulative_sum
from nyc_sample_data_for_sql_sep_2015
where driver_id = 1
--Q22
select lpep_pickup_datetime, Total_amount, Passenger_count
from nyc_sample_data_for_sql_sep_2015
where
Total_amount = (select max(Total_amount) from nyc_sample_data_for_sql_sep_2015 where driver_id = 1) or 
Total_amount = (select min(Total_amount) from nyc_sample_data_for_sql_sep_2015 where driver_id = 1)
--
select lpep_pickup_datetime, Total_amount, Passenger_count
from (select top 1 *
    from nyc_sample_data_for_sql_sep_2015
    where driver_id = 1
    ORDER by Total_amount) akk
UNION ALL
SELECT lpep_pickup_datetime, Total_amount, Passenger_count
from (select top 1 *
    from nyc_sample_data_for_sql_sep_2015
    where driver_id = 1 
    order by Total_amount desc
) dfd 
--
select *
from (
    select total_amount, 
            RANK() over(partition by driver_id order by total_amount asc) rnk,
            RANK() OVER(partition by driver_id order by total_amount desc) inverse_rnk
    from nyc_sample_data_for_sql_sep_2015
    where driver_id = 1
) dfds
where rnk = 1 or inverse_rnk = 1
--Q23
SELECT lpep_pickup_datetime, driver_id,Total_amount,Passenger_count
from nyc_sample_data_for_sql_sep_2015
where driver_id = 1
ORDER by 3, 1
--Q24
select distinct driver_id
from nyc_sample_data_for_sql_oct_2015
where driver_id not in (select driver_id from nyc_sample_data_for_sql_sep_2015)
--
select driver_id
from nyc_sample_data_for_sql_oct_2015
EXCEPT
select driver_id
from nyc_sample_data_for_sql_sep_2015
--
SELECT distinct driver_id
from nyc_sample_data_for_sql_oct_2015 oct
where not exists (select distinct driver_id from nyc_sample_data_for_sql_sep_2015
                where driver_id = oct.driver_id)
--Q25
select oct_rev - sep_rev
from (select (select sum(total_amount) from nyc_sample_data_for_sql_sep_2015) sep_rev,
        (select sum(total_amount) from nyc_sample_data_for_sql_oct_2015) oct_rev) opo 

/* YANLIŞ ÇÖZÜM!!!
select sum(sep.Total_amount), sum(oct.Total_amount)
from nyc_sample_data_for_sql_sep_2015 sep, nyc_sample_data_for_sql_oct_2015 oct
where sep.driver_id = oct.driver_id*/

select distinct sum(sep.Total_amount) OVER(PARTITION by month(sep.lpep_pickup_datetime)) Sep_tot, 
        sum(oct.Total_amount) over(PARTITION by month(oct.lpep_pickup_datetime)) Oct_tot
from nyc_sample_data_for_sql_oct_2015 oct
JOIN nyc_sample_data_for_sql_sep_2015 sep on sep.trip_id = oct.trip_id

with cte as (
select lpep_pickup_datetime, Total_amount sep_r
from nyc_sample_data_for_sql_sep_2015
UNION ALL
select lpep_pickup_datetime, Total_amount 
from nyc_sample_data_for_sql_oct_2015 
) 
select distinct sum(sep_r) over(PARTITION by month(lpep_pickup_datetime))
from cte

-- İlknur Hoca'nun çözümleri
-- WF ile
with T1 as(
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_oct_2015
)
select distinct 
	sum(case when MONTH(lpep_pickup_datetime) = 9 then Total_amount end) over (partition by MONTH(lpep_pickup_datetime)) sep,
	sum(case when MONTH(lpep_pickup_datetime) = 10 then Total_amount end) over (partition by MONTH(lpep_pickup_datetime)) oct
from T1

--Groupby ile
with T1 as(
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_oct_2015
)
select  
	sum(case when MONTH(lpep_pickup_datetime) = 9 then Total_amount end) sep,
	sum(case when MONTH(lpep_pickup_datetime) = 10 then Total_amount end) oct
from T1
group by MONTH(lpep_pickup_datetime)

--Pivot ile
select *
from (
	select MONTH(lpep_pickup_datetime) AS DATE_, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select MONTH(lpep_pickup_datetime), Total_amount
	from nyc_sample_data_for_sql_oct_2015
) T1
PIVOT (
	SUM(Total_amount)
	FOR DATE_ IN ([9],[10])) AS PIVOT_TABLE;
--Q26
select t1.driver_id, t1.oct_tot, t2.sep_tot, round(t1.oct_tot - t2.sep_tot,2)
from
(select driver_id, round(sum(Total_amount),2) oct_tot
from nyc_sample_data_for_sql_oct_2015
GROUP by driver_id) t1
left join
(select driver_id, round(sum(Total_amount),2) sep_tot
from nyc_sample_data_for_sql_sep_2015
group by driver_id) t2
on t1.driver_id = t2.driver_id
order by 1

--Q27
select t1.driver_id, trip_coct, trip_csep, trip_coct - trip_csep
from
(select driver_id, count(trip_id) trip_coct
from nyc_sample_data_for_sql_oct_2015
group by driver_id) t1
left join 
(SELECT driver_id, count(trip_id) trip_csep
from nyc_sample_data_for_sql_sep_2015
group by driver_id) t2
on t1.driver_id = t2.driver_id
order by driver_id

--Q28
--Subquery ile çözüm

select t1.driver_id, rev_per_trip_oct, rev_per_trip_sep, (rev_per_trip_oct - rev_per_trip_sep)
from
(select driver_id, sum(Total_amount) / count(trip_id) rev_per_trip_oct
from nyc_sample_data_for_sql_oct_2015
GROUP by driver_id) t1
left join
(select driver_id, sum(Total_amount) / COUNT(trip_id) rev_per_trip_sep
from nyc_sample_data_for_sql_sep_2015
GROUP by driver_id) t2
on t1.driver_id = t2.driver_id
order by 1
-- CTE ile çözüm
with tab2 as (
    select t1.driver_id, t1.oct_tot, t2.sep_tot, round(t1.oct_tot - t2.sep_tot,2) rnd
from
(select driver_id, round(sum(Total_amount),2) oct_tot
from nyc_sample_data_for_sql_oct_2015
GROUP by driver_id) t1
left join
(select driver_id, round(sum(Total_amount),2) sep_tot
from nyc_sample_data_for_sql_sep_2015
group by driver_id) t2
on t1.driver_id = t2.driver_id
),
tab1 as(
    select t1.driver_id, trip_coct, trip_csep, trip_coct - trip_csep dif_trip
from
(select driver_id, count(trip_id) trip_coct
from nyc_sample_data_for_sql_oct_2015
group by driver_id) t1
left join 
(SELECT driver_id, count(trip_id) trip_csep
from nyc_sample_data_for_sql_sep_2015
group by driver_id) t2
on t1.driver_id = t2.driver_id
)
select tab1.driver_id, (oct_tot / trip_coct) rev_per_trip_oct, (sep_tot / trip_csep) rev_per_trip_sep
from tab1, tab2 
where tab1.driver_id = tab2.driver_id
order by driver_id
--Q29
select t1.Dates, oct_tot_per_day, sep_tot_per_day, oct_tot_per_day - sep_tot_per_day diff
from
(select distinct DATENAME(dw,lpep_pickup_datetime) Dates,
     sum(Total_amount) OVER(PARTITION by DATENAME(dw,lpep_pickup_datetime)) oct_tot_per_day
from nyc_sample_data_for_sql_oct_2015 )t1
left join
(select distinct DATENAME(dw, lpep_pickup_datetime) Dates, 
    sum(Total_amount) OVER(PARTITION by DATENAME(dw, lpep_pickup_datetime) ) sep_tot_per_day
from nyc_sample_data_for_sql_sep_2015) t2
on t1.dates = t2.dates
--Q30
select t1.driver_id,t1.Dates, oct_tot_per_day, sep_tot_per_day, oct_tot_per_day - sep_tot_per_day diff
from
(select distinct driver_id, DATENAME(dw,lpep_pickup_datetime) Dates,
     sum(Total_amount) OVER(PARTITION by driver_id, DATENAME(dw,lpep_pickup_datetime)) oct_tot_per_day
from nyc_sample_data_for_sql_oct_2015 )t1
left join
(select distinct driver_id, DATENAME(dw, lpep_pickup_datetime) Dates, 
    sum(Total_amount) OVER(PARTITION by driver_id ,DATENAME(dw, lpep_pickup_datetime) ) sep_tot_per_day
from nyc_sample_data_for_sql_sep_2015) t2
on t1.dates = t2.dates and t1.driver_id = t2.driver_id
--Q31
SELECT t1.VendorID, tot_amnt_oct, tot_amnt_sep, tot_amnt_oct - tot_amnt_sep difference_amount,
        tot_trip_oct, tot_trip_sep, tot_trip_oct - tot_trip_sep difference_trip
from
(select distinct VendorID, sum(Total_amount) OVER(PARTITION by VendorID) tot_amnt_oct,
        COUNT(trip_id) OVER(PARTITION by VendorID) tot_trip_oct
from nyc_sample_data_for_sql_oct_2015) t1
left join
(select distinct VendorID, sum(Total_amount) OVER(PARTITION by VendorID) tot_amnt_sep,
        COUNT(trip_id) over(PARTITION by VendorID) tot_trip_sep
from nyc_sample_data_for_sql_sep_2015) t2
on t1.VendorID = t2.VendorID
--Q32
select *
from nyc_sample_data_for_sql_sep_2015
where trip_id in
(select next_id
from
(select sep.trip_id prev_id, sep1.trip_id next_id, 
    DATEDIFF(ms,sep.lpep_pickup_datetime,sep.Lpep_dropoff_datetime) prev_duration, 
    DATEDIFF(ms,sep1.lpep_pickup_datetime,sep1.Lpep_dropoff_datetime) next_duration
from nyc_sample_data_for_sql_sep_2015 sep
JOIN
nyc_sample_data_for_sql_sep_2015 sep1
on sep.trip_id = sep1.trip_id - 1) tab1
where next_duration > prev_duration)
-----------
select *, LEAD(trip_id) OVER()
from
(select trip_id ,
    DATEDIFF(ms,lpep_pickup_datetime,Lpep_dropoff_datetime) duration
from nyc_sample_data_for_sql_sep_2015 sep)tab1
-------
with cte as(
    select trip_id ,
    DATEDIFF(ms,lpep_pickup_datetime,Lpep_dropoff_datetime) duration
from nyc_sample_data_for_sql_sep_2015 sep
), cte2 as(
select trip_id, duration, 
    LEAD(duration) OVER(order by TRIp_id) liiiid, iif(LEAD(duration) OVER(order by TRIp_id) - duration > 0,1,0) diff
from cte)
select *
from cte2
where diff = 1
--Q33

(select *
from
(select sep.driver_id, sep.trip_id prev_id, sep1.trip_id next_id, 
    DATEDIFF(ms,sep.lpep_pickup_datetime,sep.Lpep_dropoff_datetime) prev_duration, 
    DATEDIFF(ms,sep1.lpep_pickup_datetime,sep1.Lpep_dropoff_datetime) next_duration,
from nyc_sample_data_for_sql_sep_2015 sep
JOIN
nyc_sample_data_for_sql_sep_2015 sep1
on sep.trip_id = sep1.trip_id - 1) tab1
where next_duration > prev_duration and driver_id = 1)
----------
with cte as(
    select trip_id ,driver_id,
    DATEDIFF(ms,lpep_pickup_datetime,Lpep_dropoff_datetime) duration
from nyc_sample_data_for_sql_sep_2015 sep

), cte2 as(
select trip_id, duration, driver_id,
    LEAD(duration) OVER(partition by driver_id order by TRIp_id) liiiid, iif(LEAD(duration) OVER(order by TRIp_id) > duration ,1,0) diff
from cte)
select *
from cte2
where diff = 1 and driver_id = 1
--Q34
select driver_id, Trip_distance, cast(lpep_pickup_datetime as datetime) dates, 
    DATEDIFF(s,lpep_pickup_datetime, Lpep_dropoff_datetime) duration,
    rank() OVER(PARTITION by driver_id order by lpep_pickup_datetime) rnk
from nyc_sample_data_for_sql_sep_2015
-------
with cte as(
    select driver_id, Trip_distance, lpep_pickup_datetime,cast(lpep_pickup_datetime as datetime) dates, 
    DATEDIFF(s,lpep_pickup_datetime, Lpep_dropoff_datetime) duration,
    rank() OVER(PARTITION by driver_id order by lpep_pickup_datetime) rnk
from nyc_sample_data_for_sql_sep_2015
)
select t1.driver_id, t1.lpep_pickup_datetime prev_time, t2.lpep_pickup_datetime next_time,
    t1.duration prev_duration, t2.duration next_duration, t1.rnk prev_rnk, t2.rnk next_rnk
from cte t1
join cte t2
on t1.driver_id = t2.driver_id and t1.rnk = t2.rnk - 1
------
with cte as(
    select driver_id, Trip_distance, lpep_pickup_datetime,cast(lpep_pickup_datetime as datetime) dates, 
    DATEDIFF(s,lpep_pickup_datetime, Lpep_dropoff_datetime) duration,
    rank() OVER(PARTITION by driver_id order by lpep_pickup_datetime) rnk
from nyc_sample_data_for_sql_sep_2015
)

select driver_id, min(next_duration - prev_duration)
from (
select t1.driver_id, t1.lpep_pickup_datetime prev_time, t2.lpep_pickup_datetime next_time,
    t1.duration prev_duration, t2.duration next_duration, t1.rnk prev_rnk, t2.rnk next_rnk
from cte t1
join cte t2
on t1.driver_id = t2.driver_id and t1.rnk = t2.rnk - 1) aaa 
GROUP by driver_id
--Q35
with cte as(
    select driver_id, Total_amount, lpep_pickup_datetime,cast(lpep_pickup_datetime as datetime) dates, 
    DATEDIFF(s,lpep_pickup_datetime, Lpep_dropoff_datetime) duration,
    rank() OVER(PARTITION by driver_id order by lpep_pickup_datetime,Total_amount) rnk
from nyc_sample_data_for_sql_sep_2015
)

select driver_id, prev_amnt,next_amnt, next_amnt - prev_amnt
from (
select t1.driver_id, 
    t1.Total_amount prev_amnt, t2.Total_amount next_amnt, t1.rnk prev_rnk, t2.rnk next_rnk
from cte t1
join cte t2
on t1.driver_id = t2.driver_id and t1.rnk = t2.rnk - 1) aaa 