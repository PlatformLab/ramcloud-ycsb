# This reads cluster_info.sh to find out the cluster information and export it in Python form.

from __future__ import print_function

with open("clusterInfo.sh") as f:
   for line in f:
     if line.strip().startswith("#"): continue
     if '=' not in line:
       continue
     key, value = line.strip().split('=', 1)
     # Remove quotes from confusing Python
     value = value.replace('"', '')
     if key == "COORD_LOCATOR":
        COORD_LOCATOR = value
     elif key == "CLIENTS":
        CLIENTS = value.split()
     elif key == "TOTAL_RECORDS":
        TOTAL_RECORDS = int(value)
     elif key == "LOG_DIR":
        LOG_DIR = value

def main():
    print("COORD_LOCATOR: " + str(COORD_LOCATOR))
    print("CLIENTS: " + str(CLIENTS))
    print("TOTAL_RECORDS: " + str(TOTAL_RECORDS))
    print("LOG_DIR: " + str(LOG_DIR))

if __name__ == "__main__":
    main()
