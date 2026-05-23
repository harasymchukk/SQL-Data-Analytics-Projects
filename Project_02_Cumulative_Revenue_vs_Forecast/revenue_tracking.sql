SELECT
  date,
  cumulative_revenue / cumulative_predict_revenue * 100
    AS predict_to_revenue_percent
FROM
  (
    SELECT
      date,
      total_revenue,
      total_predict_revenue,
      SUM(total_revenue) OVER (ORDER BY date) AS cumulative_revenue,
      SUM(total_predict_revenue)
        OVER (ORDER BY date) AS cumulative_predict_revenue
    FROM
      (
        SELECT
          date,
          sum(revenue) AS total_revenue,
          sum(predict_revenue) AS total_predict_revenue
        FROM
          (
            SELECT date, sum(p.price) AS revenue, 0 AS predict_revenue
            FROM `DA.order` o
            JOIN `DA.product` p
              ON o.item_id = p.item_id
            JOIN `DA.session` s
              ON o.ga_session_id = s.ga_session_id
            GROUP BY date
            UNION ALL
            SELECT date, 0 AS revenue, sum(predict) AS predict_revenue
            FROM `DA.revenue_predict`
            GROUP BY date
          )
        GROUP BY date
      )
  )
ORDER BY date
