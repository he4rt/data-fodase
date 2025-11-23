/* @bruin

name: public.providers
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.users
  - raw.providers

columns:
  - name: id
    extends: Provider.ID
  - name: model_id
    type: varchar
  - name: provider
    extends: Provider.Provider
  - name: provider_id
    extends: Provider.ProviderID
  - name: email
    extends: Provider.Email
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: model_type
    type: varchar
  - name: tenant_id
    type: integer

@bruin */

SELECT
    p.id::uuid,
    p.user_id::varchar as model_id,
    p.provider,
    p.provider_id,
    p.email,
    p.created_at,
    p.updated_at,
    'He4rt\\User\\Models\\User' as model_type,
    t.tenant_id
FROM raw.providers p
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
