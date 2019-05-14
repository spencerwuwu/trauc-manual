#!/usr/bin/python3
import sys
import os

def insert_sql(sql):
    return os.popen("psql \
            -X \
            -U pguser \
            -d ci \
            -c" + "\"" + sql + "\"").read()

def main(target_id):
    insert_sql("UPDATE ci_jobs SET status=0 WHERE target_id=" + target_id + ";")

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("./write_log_to_db.py <Target id>")
        exit(1)

    main(sys.argv[1])
