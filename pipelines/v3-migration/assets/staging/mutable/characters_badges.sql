/* @bruin

name: public.characters_badges
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.characters
  - public.badges
  - raw.characters_badges

columns:
  - name: character_id
    extends: CharacterBadge.CharacterID
  - name: badge_id
    extends: CharacterBadge.BadgeID
  - name: claimed_at
    extends: CharacterBadge.ClaimedAt
  - name: tenant_id
    type: integer

@bruin */

SELECT
    cb.character_id::uuid,
    cb.badge_id,
    cb.claimed_at,
    t.tenant_id
FROM raw.characters_badges cb
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
