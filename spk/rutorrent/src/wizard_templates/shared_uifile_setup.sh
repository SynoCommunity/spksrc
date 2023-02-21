jsonify()
{
  echo "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}
