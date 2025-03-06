SET search_path TO "prepared statements";

PREPARE repartition_prepared(int) AS
	SELECT
		count(*)
	FROM
		repartition_prepared_test t1
			JOIN
		repartition_prepared_test t2
			USING (b)
		WHERE t1.a = $1;

EXECUTE repartition_prepared (1);

BEGIN;
	-- CREATE TABLE ... AS EXECUTE prepared_statement tests
	CREATE TEMP TABLE repartition_prepared_tmp AS EXECUTE repartition_prepared(1);
	SELECT count(*) from repartition_prepared_tmp;
ROLLBACK;

PREPARE xact_repartitioned_prepared AS
	SELECT count(*) FROM repartition_prepared_test t1 JOIN repartition_prepared_test t2 USING (b);

BEGIN;
	-- Prepared re-partition join in a transaction block after a write
	INSERT INTO repartition_prepared_test VALUES (1,2);
	EXECUTE xact_repartitioned_prepared;
ROLLBACK;

BEGIN;
	-- Prepared re-partition join in a transaction block before a write
	EXECUTE xact_repartitioned_prepared;
	INSERT INTO repartition_prepared_test VALUES (1,2);
ROLLBACK;
