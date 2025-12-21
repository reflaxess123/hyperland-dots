#!/bin/bash

LOG_FILE="$HOME/.local/share/singbox-traffic.log"

# Direct domains from config
DIRECT_DOMAINS="*.ru (все .ru домены)"

get_recent_traffic() {
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "Нет данных"
        return
    fi

    local direct_list=""
    local proxy_list=""
    local seen_direct=""
    local seen_proxy=""

    # Parse router match lines and DNS queries
    while IFS= read -r line; do
        local domain=""
        local route=""

        # Match router lines: "router: match[X] domain_suffix=.ru => route(direct)"
        if [[ "$line" =~ "router: match" ]]; then
            if [[ "$line" =~ =\>\ route\(([a-z]+)\) ]]; then
                route="${BASH_REMATCH[1]}"
            fi
            # Try to get domain from DNS query before this
            continue
        fi

        # Match DNS query lines: "dns: exchanged A domain.com"
        if [[ "$line" =~ dns:\ exchanged\ [A-Z]+\ ([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\. ]]; then
            domain="${BASH_REMATCH[1]}"
            # Check if .ru domain (direct)
            if [[ "$domain" =~ \.ru$ ]]; then
                if [[ ! "$seen_direct" =~ "$domain" ]]; then
                    direct_list="${direct_list}• ${domain}\\n"
                    seen_direct="$seen_direct $domain"
                fi
            fi
        fi

        # Match outbound lines with domains
        if [[ "$line" =~ outbound/direct.*connection\ to\ ([0-9.]+): ]]; then
            # Direct IP connection - skip, we get domains from DNS
            continue
        fi

        if [[ "$line" =~ outbound/vless.*connection ]]; then
            # Proxy connection - try to get domain from earlier DNS
            continue
        fi
    done < <(tail -300 "$LOG_FILE" 2>/dev/null)

    # Get proxy domains from DNS (non-.ru)
    while IFS= read -r line; do
        if [[ "$line" =~ dns:\ exchanged\ [A-Z]+\ ([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\. ]]; then
            local domain="${BASH_REMATCH[1]}"
            if [[ ! "$domain" =~ \.ru$ ]] && [[ "$domain" != *"in-addr.arpa"* ]]; then
                if [[ ! "$seen_proxy" =~ "$domain" ]]; then
                    proxy_list="${proxy_list}• ${domain}\\n"
                    seen_proxy="$seen_proxy $domain"
                fi
            fi
        fi
    done < <(tail -300 "$LOG_FILE" 2>/dev/null | grep "dns: exchanged" | tail -15)

    # Limit to last 5 each
    direct_list=$(echo -e "$direct_list" | head -5 | tr '\n' '\\n' | sed 's/\\n$//')
    proxy_list=$(echo -e "$proxy_list" | head -5 | tr '\n' '\\n' | sed 's/\\n$//')

    local result=""
    if [[ -n "$direct_list" ]]; then
        result="📤 Direct:\\n${direct_list}"
    fi
    if [[ -n "$proxy_list" ]]; then
        [[ -n "$result" ]] && result="${result}\\n"
        result="${result}🔒 Proxy:\\n${proxy_list}"
    fi

    if [[ -z "$result" ]]; then
        echo "Ожидание трафика..."
    else
        echo "$result"
    fi
}

if pgrep -x sing-box > /dev/null; then
    recent=$(get_recent_traffic)
    tooltip="VLESS VPN активен\\n\\nDirect: ${DIRECT_DOMAINS}\\n\\nТрафик:\\n${recent}"
    echo "{\"text\": \"󰌾 On\", \"class\": \"connected\", \"tooltip\": \"${tooltip}\"}"
else
    echo "{\"text\": \"󰌾 Off\", \"class\": \"disconnected\", \"tooltip\": \"VPN выключен\"}"
fi
