/* @bruin

name: public.seasons
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - raw.seasons

columns:
  - name: id
    extends: Season.ID
  - name: name
    extends: Season.Name
  - name: description
    extends: Season.Description
  - name: started_at
    extends: Season.StartedAt
  - name: ended_at
    extends: Season.EndedAt
  - name: messages_count
    extends: Season.MessagesCount
  - name: participants_count
    extends: Season.ParticipantsCount
  - name: meeting_count
    extends: Season.MeetingCount
  - name: badges_count
    extends: Season.BadgesCount
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    s.id::uuid,
    s.name,
    s.description,
    s.started_at,
    s.ended_at,
    s.messages_count,
    s.participants_count,
    s.meeting_count,
    s.badges_count,
    s.created_at,
    s.updated_at,
    t.tenant_id
FROM raw.seasons s
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
