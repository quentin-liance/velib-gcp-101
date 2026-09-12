# Transports IDF GCP 101

Projet d'apprentissage GCP de bout en bout : ingestion, entreposage, modélisation et mise en production de prédictions sur les données temps réel du trafic des transports en commun d'Île-de-France (RER, métro, tram) via l'API PRIM d'Île-de-France Mobilités.

## Configuration

- Projet GCP : `velib-gcp-101-ql`
- Région : `europe-west1`
- Budget mensuel avec alertes à 10 € / 50 € / 100 €
- Source de données : [PRIM](https://prim.iledefrance-mobilites.fr/) (API `general-message`), lignes surveillées par défaut : RER A/B/C/D/E, Métro 1/4/14

## Plan (8 sprints)

- [x] Sprint 0 — Fondations (projet GCP, budget, région, repo, APIs)
- [x] Sprint 1 — Ingestion (Cloud Run Job + Scheduler → GCS → BigQuery)
- [x] Sprint 2 — Modélisation des données (raw / staging / marts)
- [ ] Sprint 3 — Baseline BigQuery ML
- [ ] Sprint 4 — Modèle custom sur Vertex AI
- [ ] Sprint 5 — Service de prédiction (Cloud Run)
- [ ] Sprint 6 — Orchestration (Vertex AI Pipelines)
- [ ] Sprint 7 — Monitoring et CI/CD
- [ ] Sprint 8 — Infrastructure as Code (Terraform)
