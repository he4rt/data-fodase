{% macro tenant_default() -%}
WITH t AS (
  SELECT id AS tenant_id FROM tenants WHERE slug = 'he4rt'
)
SELECT tenant_id FROM t;
{%- endmacro %}
