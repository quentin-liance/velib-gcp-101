-- Une ligne par message de perturbation réel (pas par fetch/ligne).
-- Une ligne "ok" sans perturbation ne produit aucune ligne ici (UNNEST d'un tableau vide).
CREATE OR REPLACE TABLE `velib-gcp-101-ql.idfm_staging.messages`
PARTITION BY DATE(fetched_at)
CLUSTER BY line AS
SELECT
  fetched_at,
  line,
  JSON_VALUE(msg.InfoMessageIdentifier.value) AS message_id,
  JSON_VALUE(msg.InfoChannelRef.value) AS channel,
  SAFE.TIMESTAMP(JSON_VALUE(msg.RecordedAtTime)) AS recorded_at,
  SAFE.TIMESTAMP(JSON_VALUE(msg.ValidUntilTime)) AS valid_until,
  (
    SELECT JSON_VALUE(m2.MessageText.value)
    FROM UNNEST(JSON_QUERY_ARRAY(msg.Content.Message)) AS m2
    WHERE JSON_VALUE(m2.MessageType) = 'SHORT_MESSAGE'
    LIMIT 1
  ) AS message_short
FROM `velib-gcp-101-ql.idfm_raw.trafic_messages`,
UNNEST(JSON_QUERY_ARRAY(raw.Siri.ServiceDelivery.GeneralMessageDelivery[0].InfoMessage)) AS msg
WHERE status = 'ok';
