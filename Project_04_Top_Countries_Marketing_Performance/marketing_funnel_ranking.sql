WITH
  ste AS (
    SELECT
      DATE_ADD(s.date, INTERVAL sent_date DAY) AS date,
      sp.country,
      a.send_interval,
      a.is_verified,
      a.is_unsubscribed,
      0 AS account_cnt,
      COUNT(es.id_message) AS sent_msg,
      COUNT(ev.id_message) AS visit_msg,
      COUNT(eo.id_message) AS open_msg,
    FROM `DA.email_sent` es
    LEFT JOIN `DA.email_visit` ev
      ON es.id_message = ev.id_message
    LEFT JOIN `DA.email_open` eo
      ON es.id_message = eo.id_message
    JOIN `DA.account_session` acs
      ON es.id_account = acs.account_id
    JOIN `DA.account` a
      ON a.id = acs.account_id
    JOIN `DA.session` s
      ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp
      ON s.ga_session_id = sp.ga_session_id
    GROUP BY date, sp.country, a.send_interval, a.is_verified, a.is_unsubscribed
    UNION ALL
    SELECT 
      s.date,
      sp.country,
      a.send_interval,
      a.is_verified,
      a.is_unsubscribed,
      COUNT(a.id) AS account_cnt,
      0 AS sent_msg,
      0 AS visit_msg,
      0 AS open_msg
    FROM `DA.account` a
    JOIN `DA.account_session` acs
      ON a.id = acs.account_id
    JOIN `DA.session` s
      ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp
      ON s.ga_session_id = sp.ga_session_id
    GROUP BY
      s.date, sp.country, a.send_interval, a.is_verified, a.is_unsubscribed
  ),
  grouped_ste AS (
    SELECT
      date,
      country,
      send_interval,
      is_verified,
      is_unsubscribed,
      SUM(account_cnt) AS account_cnt,
      SUM(sent_msg) AS sent_msg,
      SUM(open_msg) AS open_msg,
      SUM(visit_msg) AS visit_msg,
    FROM ste
    GROUP BY 1, 2, 3, 4, 5
  ),
  totals_precalculated
  AS (  
    SELECT
      *,
      SUM(account_cnt) OVER (PARTITION BY country) AS total_country_account_cnt,
      SUM(sent_msg) OVER (PARTITION BY country) AS total_country_sent_cnt
    FROM grouped_ste
  ),
  ranking AS (  
    SELECT
      *,
      DENSE_RANK()
        OVER (ORDER BY total_country_account_cnt DESC)
        AS rank_total_country_account_cnt,
      DENSE_RANK()
        OVER (ORDER BY total_country_sent_cnt DESC)
        AS rank_total_country_sent_cnt
    FROM totals_precalculated
  )
SELECT *
FROM ranking
WHERE
  rank_total_country_account_cnt <= 10
  OR rank_total_country_sent_cnt <= 10
ORDER BY date DESC;
