/* @bruin

name: public.feedbacks
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.users
  - raw.feedbacks

columns:
  - name: id
    extends: Feedback.ID
  - name: sender_id
    extends: Feedback.SenderID
  - name: target_id
    extends: Feedback.TargetID
  - name: type
    extends: Feedback.Type
  - name: message
    extends: Feedback.Message
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    f.id::uuid,
    f.sender_id::uuid,
    f.target_id::uuid,
    f.type,
    f.message,
    f.created_at,
    f.updated_at,
    t.tenant_id
FROM raw.feedbacks f
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
