WITH
  revenue AS (
    SELECT
      sp.continent,
      SUM(p.price) AS revenue,
      SUM(CASE WHEN device = 'mobile' THEN p.price END) AS revenue_from_mobile,
      SUM(CASE WHEN device = 'desktop' THEN p.price END) AS revenue_from_desktop
    FROM `DA.order` o
    JOIN `DA.product` p
      ON o.item_id = p.item_id
    JOIN `DA.session` s
      ON o.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp
      ON sp.ga_session_id = s.ga_session_id
    GROUP BY sp.continent
  ),
  revenue_percent AS (
    SELECT
      revenue.continent,
      revenue.revenue,
      revenue_from_mobile,
      revenue_from_desktop,
      revenue.revenue / SUM(revenue.revenue) OVER () * 100 AS revenue_from_total
    FROM revenue
  ),
  account AS (
    SELECT
      sp.continent,
      COUNT(acs.account_id) AS account_cnt,
      COUNT(CASE WHEN a.is_verified = 1 THEN account_id END)
        AS verified_account,
    FROM `DA.account_session` acs
    JOIN `DA.session_params` sp
      ON acs.ga_session_id = sp.ga_session_id
    JOIN `DA.account` a
      ON acs.account_id = a.id
    GROUP BY
      sp.continent
  ),
  session AS (
    SELECT
      continent,
      COUNT(*) AS session_cnt
    FROM
      `DA.session_params`
    GROUP BY
      continent
  )
SELECT
  session.continent,
  revenue_percent.revenue,
  revenue_percent.revenue_from_mobile,
  revenue_percent.revenue_from_desktop,
  revenue_percent.revenue_from_total,
  account.account_cnt,
  account.verified_account,
  session.session_cnt
FROM session
LEFT JOIN revenue_percent
  ON session.continent = revenue_percent.continent
LEFT JOIN account
  ON session.continent = account.continent
