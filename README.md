# Data Fodase ETL

Data Fodase is an ETL project to migrate the He4rt Bot database from v2 (MySQL 8.0) to v3 (PostgreSQL 16). The migration is implemented as a set of Bruin pipelines that extract data from the legacy MySQL schema, transform/match it to the new PostgreSQL schema, and load it into a v3 instance while applying tenant population and structural changes.

Status: Work-in-progress — migration assets and schema mappings are present under pipelines/v3-migration and the repository contains comprehensive SQL schema dumps for both old and new schemas in docs/.

Table of contents
- Overview
- Goals
- Repository structure
- Prerequisites
- Quickstart (local/dev)
- Typical migration workflow
- Validation & sanity checks
- Contributing
- References & useful links
- License

Overview
--------
This repository centralizes the artifacts needed to perform a one-time (or repeatable) data migration from He4rt Bot v2 (MySQL) to He4rt Bot v3 (Postgres). Bruin is used as the orchestration framework to keep ingestion, transformations and checks organized.

Goals
-----
- Safely migrate production data from MySQL (v2) to PostgreSQL (v3).
- Preserve referential integrity, relationships and data semantics.
- Add multi-tenant fields required by v3 and assign data to the default tenant (He4rt Developers).
- Provide repeatable, auditable migration pipelines and SQL assets.
- Include data quality checks and documentation for review.

Repository structure
--------------------
- pipelines/
  - v3-migration/
    - pipeline.yml        — Bruin pipeline definition for the v3 migration.
    - assets/             — SQL migration assets and skeletons:
      - tenants_init.sql
      - users.sql
      - providers.sql
      - characters.sql
      - badges.sql
      - meetings.sql
      - messages.sql
    - macros/             — Reusable SQL macros used by assets.
    - README.md           — Pipeline-specific notes and checklist.
- docs/
  - OLD-DATABASE.md      — Full MySQL v2 schema dump / table definitions.
  - NEW-DATABASE.md      — Full PostgreSQL v3 schema dump / table definitions.
- README.md              — This file.
- (other files and manifests)

Prerequisites
-------------
- A working MySQL 8.0 dump or access to the v2 MySQL instance.
- PostgreSQL 16 instance ready to receive migrated data.
- Bruin installed (see Bruin docs at https://getbruin.com).
- psql, mysql client or equivalent tooling to inspect and run SQL files when needed.
- Optional: Docker / docker-compose to run local database instances for testing.

Quickstart (local/dev)
----------------------
1. Clone the repository:
   git clone https://github.com/he4rt/data-fodase.git
   cd data-fodase

2. Prepare databases:
   - Create a v3 Postgres database (Postgres 16) and a user with appropriate privileges.
   - Obtain a dump or access to the v2 MySQL database.

3. Configure environment:
   Create a .env (or export environment variables) with connection strings and settings Bruin/your environment expects. Example environment variables (adapt to your environment):
   - V2_MYSQL_DSN="mysql://user:pass@host:3306/dev_he4rt"
   - V3_PG_DSN="postgres://user:pass@host:5432/he4rt_v3"
   - BRUIN_ENV=development

   Note: Bruin supports multiple configuration approaches — consult pipeline/v3-migration/pipeline.yml and Bruin docs for exact variable names.

4. Review pipeline assets:
   Inspect pipelines/v3-migration/assets/* and pipelines/v3-migration/macros/* to confirm mappings and custom SQL transformations.

5. Dry run & test:
   - Option A: Run the pipeline against a small subset / staging copies of v2/v3 databases.
   - Option B: Run transformations locally on exported CSVs or SQL extracts.

6. Run the Bruin migration:
   Use Bruin to execute the v3 migration pipeline. Example (replace with your Bruin command if different):
   - bruin run -f pipelines/v3-migration/pipeline.yml
   Consult Bruin CLI docs for the exact invocation if your environment differs.

Typical migration workflow
--------------------------
1. Populate the initial tenant in v3 (tenants_init.sql) — v3 is multi-tenant and requires all data to be associated with a tenant.
2. Migrate core users and provider accounts.
3. Migrate profile and address information.
4. Migrate RPG system data: characters, badges, voice messages (ensure tenant_id is set).
5. Migrate community data: seasons, messages, meetings, rankings.
6. Run post-load consistency checks and data quality queries.
7. Manually verify critical relationships (e.g., characters -> users, messages -> providers).
8. Run the application in read-only mode (if possible) against migrated data and perform functional tests.
9. Cutover plan: coordinate downtime, final delta sync, and switch application to v3.

Validation & sanity checks
--------------------------
- Use the SQL schema dumps in docs/OLD-DATABASE.md and docs/NEW-DATABASE.md to compare columns, types and constraints.
- Implement and run row-count checks per important table before and after migration.
- Validate foreign-key relationships and cascade behavior (where applicable).
- Spot-check sensitive records (admins, owners, sample users).
- Consider data-quality rules for dates, nullability, uniqueness, and tenant assignment.

Notes & migration concerns
--------------------------
- v3 is multi-tenant: every migrated row must be assigned to a tenant (see the v3 pipeline checklist).
- Some MySQL types / collations may require explicit casting or normalization for Postgres.
- UUID handling: v2 uses char(36) in many tables; v3 uses uuid for IDs — confirm casting and data format.
- Timestamps: v3 uses timestamp(0) in many places — align timezone concerns during migration.
- Evaluate large tables (messages, voice_messages) for chunked migration and performance (batching).

Contributing
------------
- Please open issues for bugs, missing mappings, or migration edge cases.
- For code or SQL changes, open a pull request against this repository with a clear description and migration impact.
- If you add or change any asset, include:
  - rationale for the change,
  - a link to the affected v2 and v3 schema definitions,
  - a small test plan to validate the change.

References & useful links
-------------------------
- Bruin: https://getbruin.com
- docs/OLD-DATABASE.md: ./docs/OLD-DATABASE.md
- docs/NEW-DATABASE.md: ./docs/NEW-DATABASE.md
- pipelines/v3-migration README: ./pipelines/v3-migration/README.md

License
-------
See the LICENSE file in this repository for license terms. If there is no LICENSE file, add one appropriate for your project before public distribution.

Maintainers / Contacts
---------------------
- He4rt organization (repository maintainers). Use Issues or PRs for questions and code changes.

Acknowledgements
----------------
This repository and migration were prepared to support He4rt Bot v3. The migration skeletons and schemas were authored to preserve data semantics while moving to a multi-tenant, Postgres-native design.
