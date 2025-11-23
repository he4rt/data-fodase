/* @bruin

name: public.feedback_reviews
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - public.tenants
  - public.feedbacks
  - public.users
  - raw.feedback_reviews

columns:
  - name: id
    extends: FeedbackReview.ID
  - name: feedback_id
    extends: FeedbackReview.FeedbackID
  - name: staff_id
    extends: FeedbackReview.StaffID
  - name: status
    extends: FeedbackReview.Status
  - name: reason
    extends: FeedbackReview.Reason
  - name: received_at
    extends: FeedbackReview.ReceivedAt
  - name: created_at
    type: timestamp
  - name: updated_at
    type: timestamp
  - name: tenant_id
    type: integer

@bruin */

SELECT
    fr.id::uuid,
    fr.feedback_id::uuid,
    fr.staff_id::uuid,
    fr.status,
    fr.reason,
    fr.received_at,
    fr.created_at,
    fr.updated_at,
    t.tenant_id
FROM raw.feedback_reviews fr
CROSS JOIN (SELECT id as tenant_id FROM public.tenants WHERE slug = 'he4rt') t
