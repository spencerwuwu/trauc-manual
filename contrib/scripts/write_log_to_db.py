#!/usr/bin/python3
import sys
import os

def run_sql(sql):
    return os.popen("psql \
            -X \
            -t \
            -U pguser \
            --set ON_ERROR_STOP=on \
            --set AUTOCOMMIT=off \
            -d ci \
            --field-separator , \
            --quiet \
            --no-align \
            -c" + "\"" + sql + "\"").read()

def insert_sql(sql):
    return os.popen("psql \
            -X \
            -U pguser \
            -d ci \
            -c" + "\"" + sql + "\"").read()

# Usage ./write_log_to_db.py <Target id> <Target> <Benchmark> <commit>
def main(target_id, target, benchmark, commit):
    os.environ["PGPASSWORD"] = os.environ["CI_DB_PASSWORD"]
    log_dir = os.environ["HOME"] + "/output/"
    log = log_dir + target + "." + benchmark + ".log"

    data = os.popen("cat " + log + " | tail -n 1").read().replace(" ", "")
    data = data.split("(")[1].split(")")[0]
    tool_check_date, unsat, sat, timeout, unknown, exception, misc = data.split(",")
    check_date = tool_check_date.replace(target, "").replace("-", "")

    datetime = run_sql("SELECT now()").replace("\n", "")


    sql = "INSERT INTO test_results"
    sql = sql + "(target_id, "
    sql = sql + "created_at, "
    sql = sql + "updated_at, "
    sql = sql + "date, "
    sql = sql + "benchmark," 
    sql = sql + "commit," 
    sql = sql + "sat, "
    sql = sql + "unsat," 
    sql = sql + "unknown," 
    sql = sql + "timeout," 
    sql = sql + "exception," 
    sql = sql + "misc)" 
    sql = sql + "VALUES (" + target_id + ",\'" 
    sql = sql + datetime + "\',\'"
    sql = sql + datetime + "\',\'"
    sql = sql + check_date + "\',\'"
    sql = sql + benchmark + "\',\'"
    sql = sql + commit + "\',"
    sql = sql + sat + ","
    sql = sql + unsat + "," 
    sql = sql + unknown + "," 
    sql = sql + timeout + "," 
    sql = sql + exception + "," 
    sql = sql + misc + ")"

    print(sql)
    insert_sql(sql)

    # Parse log to ci_logs_full
    full_log_dir = "/home/deploy/ci_logs_full/" + target + "-" + check_date + "-" + benchmark + "/"
    os.system("rm -rf " + full_log_dir) 
    os.system("mkdir " + full_log_dir) 
    output = full_log_dir + benchmark + "." + check_date + "." + target + ".log"
    os.system("touch " + output)
    with open(log, "r") as source:
        lines = source.read().splitlines()
        for line in lines:
            if "LOG.ERR" in line:
                output = full_log_dir + benchmark + "." + check_date + "." + target + ".log.err"
                os.system("touch " + output)
            elif "LOG.END" in line:
                break
            else:
                os.system("echo \"" + line + "\" >> " + output)

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("./write_log_to_db.py <Target id> <Target> <Benchmark> <commit>")
        exit(1)

    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
