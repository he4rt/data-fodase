/* @bruin

name: public.voice_messages
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.providers
  - raw.voice_messages

columns:
  - name: id
    extends: VoiceMessage.ID
  - name: provider_id
    extends: VoiceMessage.ProviderID
  - name: channel_name
    extends: VoiceMessage.ChannelName
  - name: state
    extends: VoiceMessage.State
  - name: obtained_experience
    extends: VoiceMessage.ObtainedExperience
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    vm.id,
    vm.provider_id::uuid,
    vm.channel_name,
    vm.state,
    vm.obtained_experience,
    vm.created_at,
    vm.updated_at,
    t.tenant_id
FROM raw.voice_messages vm
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
