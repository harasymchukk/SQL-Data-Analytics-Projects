WITH
  sent_date AS (
    SELECT
      DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS email_sent_date,
      es.id_account,
      es.id_message,
      DATE(
        EXTRACT(YEAR FROM DATE_ADD(s.date, INTERVAL es.sent_date DAY)),
        EXTRACT(MONTH FROM DATE_ADD(s.date, INTERVAL es.sent_date DAY)),
        1) AS sent_month
    FROM `DA.email_sent` es
    JOIN `DA.account_session` acs
      ON es.id_account = acs.account_id
    JOIN `DA.session` s
      ON acs.ga_session_id = s.ga_session_id
  ),
  emails_sent_by_month AS (
    SELECT sent_month, COUNT(id_message) AS sent_by_month
    FROM sent_date
    GROUP BY sent_month
  ),
  acc_monthly AS (
    SELECT
      sent_month,
      id_account,
      COUNT(id_message) msg_cnt,
      MIN(email_sent_date) AS first_sent_date,
      MAX(email_sent_date) AS last_sent_date
    FROM sent_date
    GROUP BY sent_month, id_account
  )
SELECT
  acc_monthly.sent_month,
  acc_monthly.id_account,
  acc_monthly.msg_cnt / emails_sent_by_month.sent_by_month * 100
    AS sent_msg_percent_from_this_month,
  first_sent_date,
  last_sent_date
FROM acc_monthly
JOIN emails_sent_by_month
  ON acc_monthly.sent_month = emails_sent_by_month.sent_month
ORDER BY acc_monthly.sent_month
