jsonify()
{
  echo "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

dsm_pre7_permissions_step() {
  cat <<END_OF_STEP
{
    "step_title": "${DSM_PERMISSIONS_STEP_TITLE}",
    "items": [
        {
            "desc": "${DSM_PERMISSIONS_STEP_DESC}"
        }
    ]
}
END_OF_STEP
}
