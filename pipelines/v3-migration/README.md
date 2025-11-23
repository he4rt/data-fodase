# V3 Migration

This project manages the database migration from He4rt Bot v2 (MySQL 8.0) to He4rt Bot v3 (PostgreSQL 16). The migration process is orchestrated using [Bruin](https://getbruin.com), a robust data pipeline tool.

## About Bruin

Bruin is an end-to-end data pipeline framework that unifies data ingestion, transformation (SQL & Python), and quality assurance. It is designed to simplify the management of data flows across different environments.

In the context of this project, Bruin handles:
- **Data Ingestion**: Reading data from the legacy MySQL database.
- **Transformation**: Mapping and transforming data to fit the new PostgreSQL schema.
- **Quality Checks**: Ensuring data integrity during the migration.

### Bruin Usage

To run the migration pipeline, you will need to have the Bruin CLI installed.

#### Connections setup

Before running any asset, configure two Bruin connections that point to your databases:

- mysql_v2: MySQL 8.0 (legacy He4rt v2)
- postgres_v3: PostgreSQL 16 (target He4rt v3)

You can create and test them with:

```bash
bruin connections add
bruin connections list
bruin connections ping mysql_v2
bruin connections ping postgres_v3
```

1.  **Run the Pipeline**:
    ```bash
    bruin run pipelines/v3-migration
    ```

2.  **Validate Assets**:
    ```bash
    bruin validate pipelines/v3-migration
    ```

3.  **Check Lineage**:
    ```bash
    bruin lineage pipelines/v3-migration
    ```

4.  **Seed default tenant (first run)**:
    ```bash
    bruin run pipelines/v3-migration/assets/tenants_init.sql
    ```

### File Structure

The migration project is structured as follows:

```
pipelines/
  v3-migration/
    pipeline.yml          # Pipeline configuration
    assets/               # SQL assets for migration
      tenants_init.sql    # Seeds the default tenant in v3
      users.sql           # Users migration skeleton
      providers.sql       # Providers migration skeleton
      characters.sql      # Characters migration skeleton
      badges.sql          # Badges migration skeleton
      meetings.sql        # Meetings migration skeleton
      messages.sql        # Messages migration skeleton
    macros/               # Reusable SQL macros
```

## Migration Tasks

The following checklist tracks the progress of migrating tables from v2 to v3.

> [!IMPORTANT]
> **Tenant Population**: The v3 database is multi-tenant. All migrated data must be assigned to the default tenant:
> - **Name**: `He4rt Developers`
> - **Slug**: `he4rt`
> - **Owner**: Initial admin user

- [ ] **Users & Authentication**
    - [ ] `users` -> `users`
    - [ ] `providers` -> `providers` (Add `tenant_id`)
    - [ ] `user_address` -> `user_address`
    - [ ] `user_information` -> `user_information`

- [ ] **RPG System**
    - [ ] `characters` -> `characters` (Add `tenant_id`)
    - [ ] `badges` -> `badges` (Add `tenant_id`)
    - [ ] `voice_messages` -> `voice_messages` (Add `tenant_id`)

- [ ] **Community**
    - [ ] `meetings` -> `meetings` (Add `tenant_id`)
    - [ ] `messages` -> `messages` (Add `tenant_id`)

## Structural Changes

The migration involves a shift from a single-tenant MySQL structure to a multi-tenant PostgreSQL architecture. While there are new tables introduced in v3 (such as `tenants`, `events`, and `cache`), the core data migration focuses on the tables that persist between versions.

### Matching Tables

The following tables are present in both the old (v2) and new (v3) database structures and are the primary subjects of this migration:

| Table Name | Description |
| :--- | :--- |
| `badges` | Stores information about badges. |
| `characters` | Represents user characters in the RPG system. |
| `characters_badges` | Mapping table between characters and their badges. |
| `characters_leveling_logs` | Logs character experience and leveling events. |
| `failed_jobs` | Records of queued jobs that failed execution. |
| `feedback_reviews` | Reviews and status of user feedbacks. |
| `feedbacks` | User submitted feedback entries. |
| `meeting_participants` | Records users who attended meetings. |
| `meeting_types` | Definitions of different meeting types. |
| `meetings` | Stores details of scheduled meetings. |
| `messages` | Logs chat messages for experience calculation. |
| `migrations` | tracks database schema migrations. |
| `password_resets` | Stores password reset tokens. |
| `personal_access_tokens` | API tokens for user authentication. |
| `providers` | Linked OAuth providers for users. |
| `seasons` | Defines operational seasons for rankings. |
| `seasons_rankings` | Stores character rankings per season. |
| `user_address` | Stores user address details. |
| `user_information` | Additional user profile information. |
| `users` | Core user account data. |
| `voice_messages` | Logs voice activity for experience calculation. |


## Migration Concerns

### Multi-tenancy Population

The v2 database was not tenant-aware, whereas the v3 architecture is built around multi-tenancy.

**Crucial Step**: The migration script **must** populate a single default tenant to serve as the basis for the migrated data modeling.

- **Tenant Name**: `He4rt Developers`
- **Tenant Slug**: `he4rt`
- **Ownership**: The tenant must be assigned to a single owner (e.g., the initial admin user).