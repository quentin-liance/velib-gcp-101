-- Une ligne par (fetch, ligne) : nombre de perturbations actives + flag.
-- Table d'analyse, grain identique à idfm_raw pour rester une série temporelle complète
-- (y compris les fetch sans perturbation, utile pour un futur modèle de prévision).
CREATE OR REPLACE TABLE `velib-gcp-101-ql.idfm_marts.line_status`
PARTITION BY DATE(fetched_at)
CLUSTER BY line AS
SELECT
  fetched_at,
  line,
  status,
  CASE WHEN status = 'ok'
    THEN ARRAY_LENGTH(JSON_QUERY_ARRAY(raw.Siri.ServiceDelivery.GeneralMessageDelivery[0].InfoMessage))
    ELSE NULL
  END AS nb_messages,
  CASE WHEN status = 'ok'
    THEN ARRAY_LENGTH(JSON_QUERY_ARRAY(raw.Siri.ServiceDelivery.GeneralMessageDelivery[0].InfoMessage)) > 0
    ELSE NULL
  END AS has_disruption
FROM `velib-gcp-101-ql.idfm_raw.trafic_messages`;
