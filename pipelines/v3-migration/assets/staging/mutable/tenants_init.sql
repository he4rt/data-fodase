/* @bruin

name: public.tenants
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.users

@bruin */

SELECT
    1 as id,
    'He4rt Developers' as name,
    'he4rt' as slug,
    (SELECT id FROM public.users ORDER BY created_at ASC LIMIT 1) as owner_id,
    true as active,
    NOW() as created_at,
    NOW() as updated_at,
    NULL::timestamp as deleted_at
WHERE NOT EXISTS (SELECT 1 FROM public.tenants WHERE slug = 'he4rt')
