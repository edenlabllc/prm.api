    SELECT days.day,
           count(case when DATE(inserted_at) = day then 1 end) as created,
           count(case when status = 'closed' and DATE(updated_at) = day then 1 end) as closed,
           count(case when status != 'closed' and DATE(inserted_at) <= day then 1 end) as total
      FROM declarations
RIGHT JOIN (
             SELECT date_trunc('day', series)::date AS day
             FROM generate_series('2017-03-10'::timestamp, '2017-03-29'::timestamp, '1 day'::interval) series
           ) days ON
                     doctor_id = 'be802077-ddf0-4980-a390-6bfb513381ae' AND
                     msp_id = '320e54d5-1f8f-4021-8449-c4378735d974' AND
                     inserted_at::date >= DATE('2017-03-10') AND
                     inserted_at::date <= DATE('2017-03-29')
  GROUP BY days.day
  ORDER BY days.day;

