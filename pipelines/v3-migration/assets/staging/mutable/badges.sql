/* @bruin

name: public.badges
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - raw.badges

columns:
  - name: id
    extends: Badge.ID
  - name: provider
    type: varchar
  - name: name
    extends: Badge.Name
  - name: description
    extends: Badge.Description
  - name: redeem_code
    extends: Badge.RedeemCode
  - name: active
    extends: Badge.Active
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    b.id,
    b.provider,
    b.name,
    b.description,
    b.redeem_code,
    CASE WHEN b.active = 1 THEN true ELSE false END as active,
    b.created_at,
    b.updated_at,
    t.tenant_id
FROM raw.badges b
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
