function get_commit() {
    cd $HOME/trauc
    COMMIT_HASH="$(git log -1 --abbrev-commit --oneline $BRANCH \
         | awk '{print $1}')"
    cd ../ && rm -rf ${TMPDIR}

    echo "Commit hash=$COMMIT_HASH"
}
