# Vélib GCP 101

Projet d'apprentissage GCP de bout en bout : ingestion, entreposage, modélisation et mise en production de prédictions sur les données temps réel des stations Vélib' de Paris.

## Configuration

- Projet GCP : `velib-gcp-101-ql`
- Région : `europe-west1`
- Budget mensuel avec alertes à 10 € / 50 € / 100 €

## Plan (8 sprints)

- [x] Sprint 0 — Fondations (projet GCP, budget, région, repo, APIs)
- [ ] Sprint 1 — Ingestion (Cloud Run Job + Scheduler → GCS → BigQuery)
- [ ] Sprint 2 — Modélisation des données (raw / staging / marts)
- [ ] Sprint 3 — Baseline BigQuery ML
- [ ] Sprint 4 — Modèle custom sur Vertex AI
- [ ] Sprint 5 — Service de prédiction (Cloud Run)
- [ ] Sprint 6 — Orchestration (Vertex AI Pipelines)
- [ ] Sprint 7 — Monitoring et CI/CD
- [ ] Sprint 8 — Infrastructure as Code (Terraform)
