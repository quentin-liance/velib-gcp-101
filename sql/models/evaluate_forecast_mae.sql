-- MAE du modèle sur le jour laissé de côté à l'entraînement.
-- Les timestamps réels et prévus sont arrondis au quart d'heure le plus proche
-- (ARIMA_PLUS régularise la fréquence, les vrais fetch ont un peu de gigue).
WITH forecast AS (
  SELECT
    line,
    TIMESTAMP_SECONDS(DIV(UNIX_SECONDS(forecast_timestamp), 900) * 900) AS ts_bucket,
    forecast_value
  FROM ML.FORECAST(
    MODEL `velib-gcp-101-ql.idfm_marts.line_disruption_forecast`,
    STRUCT(96 AS horizon)
  )
),
actual AS (
  SELECT
    line,
    TIMESTAMP_SECONDS(DIV(UNIX_SECONDS(fetched_at), 900) * 900) AS ts_bucket,
    nb_messages
  FROM `velib-gcp-101-ql.idfm_marts.line_status`
  WHERE status = 'ok'
    AND fetched_at >= (
      SELECT TIMESTAMP_SUB(MAX(fetched_at), INTERVAL 1 DAY)
      FROM `velib-gcp-101-ql.idfm_marts.line_status`
    )
),
joined AS (
  SELECT f.line, ABS(f.forecast_value - a.nb_messages) AS abs_error
  FROM forecast f
  JOIN actual a USING (line, ts_bucket)
)
SELECT line, COUNT(*) AS n_points, ROUND(AVG(abs_error), 3) AS mae
FROM joined
GROUP BY line
UNION ALL
SELECT 'TOTAL', COUNT(*), ROUND(AVG(abs_error), 3)
FROM joined
ORDER BY mae DESC;
