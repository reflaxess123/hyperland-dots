#!/usr/bin/env python3
"""Parse sing-box log and output unique domains by route type as JSON."""

import json
import re
import sys
from pathlib import Path
from collections import OrderedDict

LOG_FILE = Path.home() / ".local/share/singbox-traffic.log"
LIMIT = int(sys.argv[1]) if len(sys.argv) > 1 else 25

def parse_log():
    if not LOG_FILE.exists():
        return {"proxy": [], "direct": []}

    # Read last N lines for performance
    lines = LOG_FILE.read_text().splitlines()[-3000:]

    # Maps: connection_id -> domain
    conn_domains = {}
    # Maps: connection_id -> route (proxy/direct)
    conn_routes = {}

    domain_pattern = re.compile(r'\[(\d+).*domain:\s+(\S+)')
    route_pattern = re.compile(r'\[(\d+).*outbound/(vless\[proxy\]|direct\[direct\])')

    for line in lines:
        # Extract domain
        match = domain_pattern.search(line)
        if match:
            conn_id, domain = match.groups()
            conn_domains[conn_id] = domain
            continue

        # Extract route
        match = route_pattern.search(line)
        if match:
            conn_id, route = match.groups()
            conn_routes[conn_id] = "proxy" if "proxy" in route else "direct"

    # Combine: get unique domains per route (recent first)
    proxy_domains = OrderedDict()
    direct_domains = OrderedDict()

    # Process in reverse to get most recent first
    for conn_id in reversed(list(conn_domains.keys())):
        domain = conn_domains[conn_id]
        route = conn_routes.get(conn_id)

        if route == "proxy" and domain not in proxy_domains:
            proxy_domains[domain] = True
        elif route == "direct" and domain not in direct_domains:
            direct_domains[domain] = True

    return {
        "proxy": list(proxy_domains.keys())[:LIMIT],
        "direct": list(direct_domains.keys())[:LIMIT]
    }

if __name__ == "__main__":
    print(json.dumps(parse_log()))
