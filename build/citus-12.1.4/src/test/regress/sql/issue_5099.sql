CREATE SCHEMA issue_5099;
SET search_path to 'issue_5099';
CREATE TYPE comp_type AS (
    int_field_1 BIGINT,
    int_field_2 BIGINT
);

CREATE TABLE range_dist_table_2 (dist_col comp_type);
SELECT create_distributed_table('range_dist_table_2', 'dist_col', 'range');
\set VERBOSITY TERSE
DROP SCHEMA issue_5099 CASCADE;
