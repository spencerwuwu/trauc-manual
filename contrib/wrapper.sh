#!/bin/bash

./scripts/run_z3_branch_by_cron.sh $1 $2
export PGPASSWORD=$CI_DB_PASSWORD
psql \
    -U pguser \
    -d ci \
    -c "UPDATE ci_jobs SET status = 0 WHERE target_id = $2" 
