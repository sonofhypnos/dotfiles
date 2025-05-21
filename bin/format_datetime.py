#!/usr/bin/env python3
# title          :unix_time.sh
# description    :enter iso-date to unix time
# author         :Tassilo Neubauer
# date           :20230610
# version        :0.1
# usage          :./unix_time.sh
# notes          :
# bash_version   :5.1.16(1)-release
# ============================================================================

import sys
from datetime import datetime, timedelta

# Check if date or weekday is provided
input_value = sys.argv[1]
input_time = sys.argv[2]

input_format = "%Y-%m-%d"

#print(sys.argv)
# print args to log of system using sys:


#print(input_value)
if not input_value[0] in "abcdefghijklmnopqrstuvwxyz":
    # print args if error:
    date_str = input_value
else:
    weekdays = {
        "mo": 0,
        "tu": 1,
        "we": 2,
        "th": 3,
        "fr": 4,
        "sa": 5,
        "su": 6,
    }

    input_value_lower = "".join(c for c in input_value.lower() if c.isalpha())

    if input_value_lower not in weekdays:
        raise ValueError("Invalid weekday shorthand")

    today = datetime.now()
    target_weekday = weekdays[input_value_lower]
    days_ahead = (target_weekday - today.weekday() + 7) % 7
    if days_ahead == 0:
        days_ahead += 7

    target_date = today + timedelta(days=days_ahead)
    date_str = target_date.strftime(input_format)

date_time_str = f"{date_str}T{input_time}"
input_format = "%Y-%m-%dT%H:%M"

# Parse and convert the input datetime to Unix timestamp
parsed_date_time = datetime.strptime(date_time_str, input_format)
unix_time = int(parsed_date_time.timestamp())

# Print the Unix timestamp
print(unix_time)
