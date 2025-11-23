/* @bruin

name: public.seasons_rankings
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.characters
  - raw.seasons_rankings

columns:
  - name: id
    extends: SeasonRanking.ID
  - name: season_id
    extends: SeasonRanking.SeasonID
  - name: character_id
    extends: SeasonRanking.CharacterID
  - name: ranking_position
    extends: SeasonRanking.RankingPosition
  - name: level
    extends: SeasonRanking.Level
  - name: experience
    extends: SeasonRanking.Experience
  - name: messages_count
    extends: SeasonRanking.MessagesCount
  - name: badges_count
    extends: SeasonRanking.BadgesCount
  - name: meetings_count
    extends: SeasonRanking.MeetingsCount
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    sr.id::uuid,
    (SELECT id FROM public.seasons ORDER BY created_at ASC LIMIT 1) as season_id,
    sr.character_id::uuid,
    sr.ranking_position,
    sr.level,
    sr.experience,
    sr.messages_count,
    sr.badges_count,
    sr.meetings_count,
    sr.created_at,
    sr.updated_at,
    t.tenant_id
FROM raw.seasons_rankings sr
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
