# Exercice : coût d'une requête avant/après partitionnement + clustering

Requête de référence : compter les perturbations actives sur la ligne B, sur une journée donnée.
Même requête, deux tables : `idfm_staging.trafic_messages_naive` (aucune optimisation) vs
`idfm_raw.trafic_messages` (partitionnée par jour, clusterisée par ligne).

## Table naïve (sans partition ni cluster)

```
bq query --use_legacy_sql=false --dry_run '
SELECT COUNT(*)
FROM `velib-gcp-101-ql.idfm_staging.trafic_messages_naive`
WHERE DATE(fetched_at) = "2026-09-12" AND line = "B"
'
```

## Table optimisée (partition + cluster)

```
bq query --use_legacy_sql=false --dry_run '
SELECT COUNT(*)
FROM `velib-gcp-101-ql.idfm_raw.trafic_messages`
WHERE DATE(fetched_at) = "2026-09-12" AND line = "B"
'
```

Comparez le nombre d'octets ("This query will process X bytes") entre les deux : la table naïve doit
scanner l'intégralité des données, la table optimisée ne scanne que la partition du jour demandé.
L'écart va s'accentuer fortement avec le temps (plus de jours d'historique = plus de partitions
ignorées par la table naïve).
