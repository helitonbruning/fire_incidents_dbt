{% macro test_row_count_match(source_table, target_table) %}
    {% set source_count_query %}
    SELECT COUNT(*) AS row_count
    FROM {{ source_table }}
    {% endset %}

    {% set target_count_query %}
    SELECT COUNT(*) AS row_count
    FROM {{ target_table }}
    {% endset %}

    {% set source_count = run_query(source_count_query).columns[0][0] %}
    {% set target_count = run_query(target_count_query).columns[0][0] %}

    {% if execute %}
        {% if source_count != target_count %}
            {% do log('Test failed: Row count mismatch between ' ~ source_table ~ ' (' ~ source_count ~ ' rows) and ' ~ target_table ~ ' (' ~ target_count ~ ' rows)', info=True) %}
        {% else %}
            {% do log('Test passed: Row counts match between ' ~ source_table ~ ' and ' ~ target_table ~ ' (' ~ source_count ~ ' rows)', info=True) %}
        {% endif %}
    {% endif %}

    {% set mismatch_query %}
    SELECT
        'Row count mismatch' AS test_result,
        {{ source_count }} AS source_row_count,
        {{ target_count }} AS target_row_count
    WHERE {{ source_count }} != {{ target_count }}
    {% endset %}

    {{ mismatch_query }}
{% endmacro %}