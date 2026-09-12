-- Copie volontairement SANS partitionnement ni clustering, uniquement pour
-- comparer le coût (octets scannés) d'une même requête avant/après optimisation.
-- Voir sql/exercises/cost_comparison.md pour les requêtes de comparaison.
CREATE OR REPLACE TABLE `velib-gcp-101-ql.idfm_staging.trafic_messages_naive` AS
SELECT * FROM `velib-gcp-101-ql.idfm_raw.trafic_messages`;
