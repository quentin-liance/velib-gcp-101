-- Baseline de prévision : nombre de perturbations par ligne, dans le temps.
-- Entraîné sur tout l'historique SAUF le dernier jour, gardé de côté (holdout)
-- pour mesurer une vraie erreur de prévision dans evaluate_forecast_mae.sql.
CREATE OR REPLACE MODEL `velib-gcp-101-ql.idfm_marts.line_disruption_forecast`
OPTIONS(
  MODEL_TYPE = 'ARIMA_PLUS',
  TIME_SERIES_TIMESTAMP_COL = 'fetched_at',
  TIME_SERIES_DATA_COL = 'nb_messages',
  TIME_SERIES_ID_COL = 'line'
) AS
SELECT fetched_at, line, nb_messages
FROM `velib-gcp-101-ql.idfm_marts.line_status`
WHERE status = 'ok'
  AND fetched_at < (
    SELECT TIMESTAMP_SUB(MAX(fetched_at), INTERVAL 1 DAY)
    FROM `velib-gcp-101-ql.idfm_marts.line_status`
  );
