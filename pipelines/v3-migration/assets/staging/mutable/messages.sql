/* @bruin

name: public.messages
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.providers
  - raw.messages

columns:
  - name: id
    extends: Message.ID
  - name: provider_id
    extends: Message.ProviderID
  - name: provider_message_id
    extends: Message.ProviderMessageID
  - name: channel_id
    extends: Message.ChannelID
  - name: content
    extends: Message.Content
  - name: obtained_experience
    extends: Message.ObtainedExperience
  - name: sent_at
    extends: Message.SentAt
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    m.id::uuid,
    m.provider_id::uuid,
    m.provider_message_id,
    m.channel_id,
    m.content,
    m.obtained_experience,
    m.sent_at,
    m.created_at,
    m.updated_at,
    t.tenant_id
FROM raw.messages m
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
