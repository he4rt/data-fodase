/* @bruin

name: public.characters
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.users
  - raw.characters

columns:
  - name: id
    extends: Character.ID
  - name: user_id
    extends: Character.UserID
  - name: experience
    extends: Character.Experience
  - name: reputation
    extends: Character.Reputation
  - name: daily_bonus_claimed_at
    extends: Character.DailyBonusClaimedAt
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    c.id::uuid,
    c.user_id::uuid,
    c.experience,
    c.reputation,
    c.daily_bonus_claimed_at,
    c.created_at,
    c.updated_at,
    t.tenant_id
FROM raw.characters c
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
