import time
import urllib.request
import sys

urls = [
    'http://127.0.0.1:4444/',
    'http://127.0.0.1:4444/create/',
    'http://127.0.0.1:4444/accounts/login/'
]

def fetch(url):
    for attempt in range(12):
        try:
            r = urllib.request.urlopen(url, timeout=5)
            data = r.read()
            print(f"{url} -> {r.getcode()} (len={len(data)})")
            return 0
        except Exception as e:
            last = e
            time.sleep(0.5)
    print(f"{url} -> ERROR: {last}", file=sys.stderr)
    return 1

exit_code = 0
for u in urls:
    rc = fetch(u)
    if rc != 0:
        exit_code = rc

sys.exit(exit_code)
