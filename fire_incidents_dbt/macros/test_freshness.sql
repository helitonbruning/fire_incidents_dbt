{% macro test_freshness(model, threshold_hours=24) %}
    SELECT *
    FROM {{ model }}
    WHERE last_updated_at < CURRENT_TIMESTAMP - INTERVAL '{{ threshold_hours }} hours'
    LIMIT 1
{% endmacro %}