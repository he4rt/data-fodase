/* @bruin

name: public.users
type: pg.sql

materialization:
  type: table
  strategy: append

depends:
  - raw.users
  - raw.messages
  - raw.providers

columns:
  - name: id
    extends: User.ID
  - name: username
    extends: User.Username
  - name: name
    extends: User.Name
  - name: email
    extends: User.Email
  - name: password
    extends: User.Password
  - name: is_donator
    extends: User.IsDonator
  - name: created_at
    extends: User.CreatedAt
  - name: updated_at
    extends: User.UpdatedAt

@bruin */

SELECT
    id::uuid as id,
    username,
    username as name, -- Mapping username to name as it is required
    NULL as email,
    NULL as password,
    CASE WHEN is_donator = 1 THEN true ELSE false END as is_donator,
    created_at,
    updated_at
FROM raw.users
